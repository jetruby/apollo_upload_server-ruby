require 'spec_helper'
require 'apollo_upload_server/graphql_data_builder'

describe ApolloUploadServer::GraphQLDataBuilder do
  describe '#call' do
    let(:params) do
      {
        'operations' => ([
          {
            'query' => 'mutation { blah blah }',
            'operationName' => nil,
            'variables' => { 'input' => { 'id' => '123' } }
          }
        ] * 3).to_json,
        '0.variables.input.files.0' => :one0,
        '1.variables.input.files.0' => :two0,
        '1.variables.input.files.1' => :two1,
        '1.variables.input.files.3' => :two3,
        '3.variables.input.files.1' => :three1
      }
    end

    let(:expected_params) do
      [
        {
          'query' => 'mutation { blah blah }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123', 'files' => [:one0] } }
        },
        {
          'query' => 'mutation { blah blah }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123', 'files' => [:two0, :two1, nil, :two3] } }
        },
        {
          'query' => 'mutation { blah blah }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123' } }
        }
      ]
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end
end
