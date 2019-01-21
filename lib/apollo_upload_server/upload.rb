# frozen_string_literal: true

require 'graphql'

module ApolloUploadServer
  class Upload < GraphQL::Schema::Scalar
    graphql_name "Upload"

    def self.coerce_input(value, _ctx)
      value
    end

    def self.coerse_result(value, _ctx)
      value
    end
  end
end
