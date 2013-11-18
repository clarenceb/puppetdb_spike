require 'rubygems'
require 'rest-client'
require 'json'

API_BASE_URI='http://192.168.33.10:8080/v3'
NODES_ENDPOINT="#{API_BASE_URI}/nodes"

response = RestClient.get NODES_ENDPOINT, { :accept => :json }
if response.code == 200
   nodes = JSON.parse(response)
   nodes.each do |node|
     if node['deactivated'].nil?
         puts "#{node['name']}: " + node.to_s
     end
   end
end 

