require 'http'

module IPFS
  class Client
    URL = 'http://localhost:5001/api/v0/'


    def self.request method, query_string
      begin
        HTTP.request(method, "#{URL}#{query_string}")
      rescue HTTP::ConnectionError
        {}
      end
    end
  end
end
