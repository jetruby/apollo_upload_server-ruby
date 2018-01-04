# ApolloUploadServer

Middleware which allows you to upload files using [graphql-ruby](https://github.com/rmosolgo/graphql-ruby), [apollo-upload-client](https://github.com/jaydenseric/apollo-upload-client) and Ruby on Rails.

Note: this implementation uses [v1 of the GraphQL multipart request spec](https://github.com/jaydenseric/graphql-multipart-request-spec/tree/v1.0.0), so you should use apollo-upload-client library v5.1.1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apollo_upload_server'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apollo_upload_server

Middleware will be used automatically.

Gem adds custom `Upload` type to your GraphQL types.
Use `ApolloUploadServer::Upload` type for your file as input field:
```ruby
  input_field :file, !ApolloUploadServer::Upload
```

That's all folks!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jetruby/apollo_upload_server-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ApolloUploadServer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jetruby/apollo_upload_server-ruby/blob/master/CODE_OF_CONDUCT.md).

## About JetRuby
ApolloUploadServer is maintained and founded by JetRuby Agency.

We love open source software!
See [our projects][portfolio] or
[contact us][contact] to design, develop, and grow your product.

[portfolio]: http://jetruby.com/portfolio/
[contact]: http://jetruby.com/#contactUs
