require "../client"
require "./find"

class Hetzner::Network::Delete
  getter hetzner_client : Hetzner::Client
  getter network_name : String
  getter network_finder : Hetzner::Network::Find

  def initialize(@hetzner_client, @network_name)
    @network_finder = Hetzner::Network::Find.new(@hetzner_client, @network_name)
  end

  def run
    if network = network_finder.run
      puts "Deleting network..."

      hetzner_client.delete("/networks", network.id)

      puts "...network deleted.\n"
    else
      puts "Network does not exist, skipping.\n"
    end

    network_name

  rescue ex : Crest::RequestFailed
    STDERR.puts "Failed to delete network: #{ex.message}"
    STDERR.puts ex.response

    exit 1
  end
end
