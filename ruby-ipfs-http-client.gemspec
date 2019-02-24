require 'date'

require_relative './lib/ruby-ipfs-http-client/version'

Gem::Specification.new do |s|
  s.name        = 'ruby-ipfs-http-client'
  s.version     = Ipfs::VERSION
  s.date        = Date.today.to_s
  s.summary     = 'ipfs client'
  s.description = 'A client library for the IPFS HTTP API, implemented in Ruby'
  s.authors     = ['Tom Benett', 'Neil Nilou']
  s.email       = 'tom@benett.io'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
    'https://github.com/tbenett/ruby-ipfs-http-client'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.4'

  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'webmock', '~>3.5.1'
end

