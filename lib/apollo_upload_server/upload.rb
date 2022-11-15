# frozen_string_literal: true

require 'graphql'

module ApolloUploadServer
  class Upload < GraphQL::Schema::Scalar
    graphql_name "Upload"

    def self.coerce_input(value, _ctx)
      return super if value.nil? || value.is_a?(::ApolloUploadServer::Wrappers::UploadedFile)

      raise GraphQL::CoercionError, "#{value.inspect} is not a valid upload"
    end
  end
end
