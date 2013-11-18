require File.join(File.dirname(__FILE__), '..', 'lib', 'nodes')

current_node_count = 0
current_changed_node_count = 0
current_failed_node_count = 0
current_unreported_node_count = 0

SCHEDULER.every '10s' do
  all_nodes = nodes(:with_status => true)

  puts "PUPPETDB - JOB - ALL_NODES: #{all_nodes}"

  last_node_count = current_node_count
  current_node_count = all_nodes.size

  last_changed_nodes_count = current_changed_node_count
  current_changed_node_count = all_nodes.select { |n| n[:status] == "changed" }.size

  last_failed_nodes_count = current_failed_node_count
  current_failed_node_count = all_nodes.select { |n| n[:status] == "failed" }.size

  last_unreported_nodes_count = current_unreported_node_count
  current_unreported_node_count = all_nodes.select { |n| n[:status] == "failed" }.size

  send_event('node_count', { current: current_node_count, last: last_node_count })
  send_event('changed_count', { current: current_changed_node_count, last: last_changed_nodes_count })
  send_event('failed_count', { current: current_failed_node_count, last: last_failed_nodes_count })
  send_event('unreported_count', { current: current_unreported_node_count, last: last_unreported_nodes_count })
end
