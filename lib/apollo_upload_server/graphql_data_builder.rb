require 'json'
require 'active_support'

module ApolloUploadServer
  class GraphQLDataBuilder
    def call(params)
      operations = begin
                     JSON.parse(params['operations'])
                   rescue JSON::ParserError
                     nil
                   end
      return unless operations.is_a?(Array)

      files = transform(convert_to_hash(select_files(params)))
      operations.zip(files).map do |data, file|
        if file.nil?
          data
        else
          data.deep_merge(file)
        end
      end
    end

    private

    def select_files(params)
      params.select do |key, _value|
        key.include?('.variables') # && value.is_a?(ActionDispatch::Http::UploadedFile)
      end
    end

    def convert_to_hash(params)
      params.reduce({}) do |memo, (key, value)|
        memo.deep_merge(key.split('.').reverse.inject(value) { |hash, name| { name => hash } })
      end
    end

    def transform(hash)
      if hash.is_a?(Hash)
        if hash.keys.all? { |key| key.to_i.to_s == key }
          hash.keys.each_with_object([]) do |index, memo|
            memo[index.to_i] = transform(hash[index])
          end
        else
          hash.map { |k, v| [k, transform(v)] }.to_h
        end
      else
        hash
      end
    end
  end
end
