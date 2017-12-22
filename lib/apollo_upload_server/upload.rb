module ApolloUploadServer
  Upload = GraphQL::ScalarType.define do
    name 'Upload'

    coerce_input ->(value, _ctx) { value }
    coerce_result ->(value, _ctx) { value }
  end
end
