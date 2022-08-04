lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apollo_upload_server/version'

Gem::Specification.new do |spec|
  spec.name          = 'apollo_upload_server'
  spec.version       = ApolloUploadServer::VERSION
  spec.authors       = ['JetRuby']
  spec.email         = ['engineering@jetruby.com']

  spec.summary       = 'Middleware which allows you to upload files using graphql and multipart/form-data.'
  spec.description   = 'apollo-upload-server implementation for Ruby on Rails as middleware.'
  spec.homepage      = 'https://github.com/jetruby/apollo_upload_server-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>=7.0.3.1'
  spec.add_dependency 'graphql', '>= 1.8'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
