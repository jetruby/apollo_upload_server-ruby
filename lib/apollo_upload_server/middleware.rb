require 'apollo_upload_server/graphql_data_builder'

module ApolloUploadServer
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      if env['CONTENT_TYPE'].to_s.include?('multipart/form-data') && request.params['operations'].present? && request.params['map'].present?
        request.update_param('_json', GraphQLDataBuilder.new.call(request.params))
      end

      @app.call(env)
    end
  end
end
