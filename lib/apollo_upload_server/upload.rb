# frozen_string_literal: true

require 'graphql'

module ApolloUploadServer
  class Upload < GraphQL::Schema::Scalar
    graphql_name "Upload"

    def self.coerce_input(value, _ctx)
      raise GraphQL::CoercionError, "#{value.inspect} is not a valid upload" unless value.nil?

      value
    end

    def self.coerce_result(value, _ctx)
      value
    end
  end
end
