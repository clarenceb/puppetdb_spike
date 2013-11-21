require File.join(File.dirname(__FILE__), '..', 'lib', 'nodes')

current = {
  :node_count       => 0,
  :changed_count    => 0,
  :failed_count     => 0,
  :unreported_count => 0
}

last = current.clone

def update_node_count!(current, last, all_nodes, count_type)
  count_key = "#{count_type}_count".to_sym
  last[count_key] = current[count_key]
  if count_key == :node_count
    current[count_key] = all_nodes.size
  else
    current[count_key] = all_nodes.select { |n| n['status'] == count_type.to_s }.size
  end
  send_event(count_key.to_s, { :current => current[count_key], :last => last[count_key] })
end

def update_node_counts! current, last, all_nodes
  puts "Updating counts for nodes: #{all_nodes}"
  [:node, :changed, :failed, :unreported].each do |count_type|
    update_node_count!(current, last, all_nodes, count_type)
  end
end

def list_puppet_agents all_nodes
  send_event('puppet_agents', { :items =>  all_nodes.map { |node| { :label => node['name'], :value => '' } } })
end

def show_memory_usage all_facts
  memorysize_mb = all_facts.find { |fact| fact['name'] == 'memorysize_mb' }
  memoryfree_mb = all_facts.find { |fact| fact['name'] == 'memoryfree_mb' }
  memory_usage = (((memorysize_mb['value'].to_f - memoryfree_mb['value'].to_f) / memorysize_mb['value'].to_f) * 100.0).round(1)

  send_event('memory_usage', { :value => memory_usage })
end

def show_random_fact all_facts
  random_fact = all_facts[rand(all_facts.size)]
  send_event('random_fact', { :title => random_fact['name'], :text => random_fact['value'] })
end

SCHEDULER.every '10s' do
  all_nodes = nodes(:with_status => true)

  update_node_counts! current, last, all_nodes
  list_puppet_agents all_nodes

  all_facts = facts('puppetmaster.example.com')

  show_memory_usage all_facts
  show_random_fact all_facts
end
