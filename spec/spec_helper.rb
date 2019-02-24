require 'webmock/rspec'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  begin
    config.order = :random

    # # clean up Ipfs cache after running specs
    # config.after(:all) do
    #   %x(var/bin/clear_garbage_collector.sh)
    # end
    #
    # # clean up Ipfs local storage after each spec
    # config.after do
    #   %x(var/bin/remove_pinned_objects.sh)
    # end

    Kernel.srand config.seed
  end

  WebMock.disable_net_connect!(allow_localhost: true)
end

require_relative '../lib/ruby-ipfs-api/client'