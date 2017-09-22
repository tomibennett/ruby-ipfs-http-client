require 'date'

Gem::Specification.new do |s|
  s.name        = 'ruby-ipfs-api'
  s.version     = '0.1.0'
  s.date        = Date.today.to_s
  s.summary     = 'ipfs client'
  s.description = 'A client library for the IPFS HTTP API, implemented in Ruby'
  s.authors     = ['Thomas Nieto', 'Neil Nilou']
  s.email       = 'thms.no@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
    'https://github.com/mahloun/ruby-ipfs-api'
  s.license       = 'MIT'
end
