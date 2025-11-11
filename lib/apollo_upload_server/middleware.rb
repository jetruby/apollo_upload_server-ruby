require 'apollo_upload_server/graphql_data_builder'

module ApolloUploadServer
  class Middleware
    # Strict mode requires that all mapped files are present in the mapping arrays.
    class_attribute :strict_mode, default: false

    def initialize(app)
      @app = app
    end

    def call(env)
      unless env['CONTENT_TYPE'].to_s.include?('multipart/form-data')
        return @app.call(env)
      end

      request = ActionDispatch::Request.new(env)
      params = request.params

      if params['operations'].present? && params['map'].present?
        result = GraphQLDataBuilder.new(strict_mode: self.class.strict_mode).call(request.params)
        result&.each do |key, value|
          request.update_param(key, value)
        end
      end

      @app.call(env)
    end
  end
end
