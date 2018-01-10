require_relative './connection'

module Ipfs
  class IpfsConfig < Connection
    CONFIG_FILEPATH = "#{ENV['HOME']}/.ipfs/config"

    def initialize
      parse_config.tap { |location|
        @host = location[:host]
        @port = location[:port]
      }
    end

    private

    def parse_config
      %r{.*API.*/ip4/(.*)/tcp/(\d+)}.match(::File.read CONFIG_FILEPATH) do |matched_data|
        {
          host: matched_data[1],
          port: matched_data[2].to_i
        }
      end
    end
  end
end