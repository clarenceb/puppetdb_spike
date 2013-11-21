require 'rest_client'
require 'time_diff'
require 'addressable/template'

#----------------------------------------------------------------------
# Credits:
# Much of the code in this file is taken from `pypuppetdb`:
#   `https://github.com/nedap/pypuppetdb`
# 
# which is licensed under the Apache v2.0 License:
#   `http://www.opensource.org/licenses/Apache-2.0`
#
# I have used some of the Python code from files api/v3.py and api/__init__.py
# and converted it to Ruby for this demo.
#----------------------------------------------------------------------

API_BASE_URI = 'http://192.168.33.10:8080/v3'

def query(endpoint, options = {})
  default_options = {}
  options         = default_options.merge(options)
  uri             = "#{API_BASE_URI}/#{endpoint}"
  uri             = "#{uri}/#{options[:path]}" if options[:path]
  payload         = {}

  if options[:query]
      payload['query']         = options[:query]
      payload['order-by']      = options[:order_by]      if options[:order_by]
      payload['limit']         = options[:limit]         if options[:limit]
      payload['include-total'] = options[:include_total] if options[:include_total]
      payload['offset']        = options[:offset]        if options[:offset]
      payload['summarize-by']  = options[:summarize_by]  if options[:summarize_by]
      payload['count-by']      = options[:count_by]      if options[:count_by]
      payload['count-filter']  = options[:count_filter]  if options[:count_filter]
      template                 = Addressable::Template.new("#{uri}/{?payload*}")
      uri                      = template.expand(:payload => payload).to_s
  end

  response = RestClient.get uri, { :accept => :json }
  
  if response.code == 200
    JSON.parse(response)
  else
    []
  end
end

def nodes(options)
	default_options = { :name => nil, :query => nil, :unreported => 2, :with_status => false }
	options         = default_options.merge(options)
	name            = options[:name]
	query           = options[:query]
	unreported      = options[:unreported]
	with_status     = options[:with_status]

	results = []
  nodes = query('nodes', :path => name, :query => query)
  nodes = [nodes] unless nodes.kind_of?(Array)

  if with_status
    latest_events = query('event-counts', :query => '["=","latest-report?",true]', :summarize_by => 'certname')
  end

  for node in nodes
  	node['unreported_time'] = nil
    node['status'] = nil
    status = events_for_node(latest_events, node['name']) if with_status

    # node status from events
    if with_status && !status.empty?
      status = status[0]
      node['events'] = status 
      node['status'] = 'changed' if status['successes'] > 0
      node['status'] = 'failed'  if status['failures'] > 0
    else
      node['status'] = 'unchanged'
      node['events'] = nil
    end

    if with_status && node['report_timestamp']
      last_report = node['report_timestamp']
      now = Time.now.utc.iso8601
      last_report_datetime = DateTime.strptime(last_report, '%Y-%m-%dT%H:%M:%S')
      now_datetime = DateTime.strptime(now, '%Y-%m-%dT%H:%M:%S')
      unreported_border = now_datetime - (unreported / 24.0)
      if last_report_datetime < unreported_border
        delta = Time.diff(now, last_report)
        node['status'] = 'unreported'
        node['unreported_time'] = "#{delta[:day]}d #{delta[:hour]}h #{delta[:second]}m"
      end
    end

    if node['report_timestamp'].nil?
      node['status'] = 'unreported'
    end

    results << node 
  end
  results
end

def events_for_node latest_events, node_name
  latest_events.find_all { |event| event['subject']['title'] == node_name }
end
