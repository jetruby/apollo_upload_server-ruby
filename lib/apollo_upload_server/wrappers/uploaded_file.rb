# frozen_string_literal: true

require 'delegate'
require 'rack'

module ApolloUploadServer
  module Wrappers
    class UploadedFile < DelegateClass(Rack::Multipart::UploadedFile)
      def initialize(wrapped_foo)
        super
      end

      def as_json(options = nil)
        instance_values.except('tempfile').as_json(options)
      end
    end
  end
end
