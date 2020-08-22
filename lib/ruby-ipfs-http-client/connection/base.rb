require 'http'
require 'uri'

module Ipfs
  module Connection
    class Base
      DEFAULT_BASE_PATH = '/api/v0'
      attr_reader :host, :port

      def build_uri
        URI::HTTP.build(host: @host, port: @port)
      end

      def up?
        begin
          HTTP.post("http://#{@host}:#{@port}#{DEFAULT_BASE_PATH}/id")
          true
        rescue HTTP::ConnectionError
          false
        end
      end

      def make_persistent
        HTTP.persistent build_uri
      end
    end
  end
end