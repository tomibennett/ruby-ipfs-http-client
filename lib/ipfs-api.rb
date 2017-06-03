require_relative './client'
require_relative './api/generic/id'
require_relative './api/generic/version'

module Ipfs
  def self.id
    Command::Id.parse_response Client.call_api Command::Id.make_request
  end

  def self.version
    Command::Version.make_request
  end
end
