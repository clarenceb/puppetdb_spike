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
    current[count_key] = all_nodes.select { |n| n[:status] == count_type.to_s }.size
  end
  send_event(count_key.to_s, { current: current[count_key], last: last[count_key] })
end

def update_node_counts! current, last, all_nodes
  puts "Updating counts for nodes: #{all_nodes}"
  [:node, :changed, :failed, :unreported].each do |count_type|
    update_node_count!(current, last, all_nodes, count_type)
  end
end

SCHEDULER.every '10s' do
  update_node_counts! current, last, nodes(:with_status => true)

  #TODO
  # top n - modified host list? or just host list (truncated?)
  # avg memory free?
  # graph (convergence)
  # text (hello	)
  # list (buzzwords)
  # meter (synergy)
end
