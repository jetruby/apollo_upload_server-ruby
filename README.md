# ApolloUploadServer

Middleware which allows you to upload files using [graphql-ruby](https://github.com/rmosolgo/graphql-ruby), [apollo-upload-client](https://github.com/jaydenseric/apollo-upload-client) and Ruby on Rails.

Note: this implementation uses [v2 of the GraphQL multipart request spec](https://github.com/jaydenseric/graphql-multipart-request-spec/tree/v2.0.0-alpha.2), so you should use apollo-upload-client library >= v7.0.0-alpha.3. If you need support for [v1 of the GraphQL multipart request spec](https://github.com/jaydenseric/graphql-multipart-request-spec/tree/v1.0.0), you must
use [version 1.0.0](https://github.com/jetruby/apollo_upload_server-ruby/tree/1.0.0) of this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apollo_upload_server', '2.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apollo_upload_server

Middleware will be used automatically.

Gem adds custom `Upload` type to your GraphQL types.
Use `ApolloUploadServer::Upload` type for your file as input field:

```ruby
  input_field :file, ApolloUploadServer::Upload
```

That's all folks!

## Configuration

The following configuration options are supported:

### Strict Mode

This can be set on `ApolloUploadServer::Middleware`:

```ruby
ApolloUploadServer::Middleware.strict_mode = true
```

Doing so ensures that all mapped array values are present in the input. If this
is set to `true`, then for following request:

```json
{
  "operations": {
    "query": "mutation { ... }",
    "operationName": "SomeOperation",
    "variables": {
      "input": { "id": "123", "avatars": [null, null] }
    }
  }
}
```

A mapping for `variables.input.avatars.0` or `variables.input.avatars.1`, will work, but one for
`variables.input.avatars.100` will not, and will raise an error.

In strict mode, passing empty destination arrays will always fail.

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
