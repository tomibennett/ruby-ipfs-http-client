require 'http'

module IPFS
  class Client
    def self.id
      begin
        JSON.parse HTTP.get 'http://localhost:5001/api/v0/id'
      rescue HTTP::ConnectionError => e
        {
          "error" => e.message,
          "description" => "Daemon is not running"
        }
      end
    end
  end
end
