require 'spec_helper'
require 'apollo_upload_server/graphql_data_builder'

describe ApolloUploadServer::GraphQLDataBuilder do
  describe '#call for single operation' do
    let(:params) do
      {
        'operations' => {
          'query' => 'mutation { blah blah }',
          'operationName' => 'SomeOperation',
          'variables' => { 'input' => { 'id' => '123' } }
        }.to_json,
        'map' => { '0' => ['variables.input.avatar'] }.to_json,
        '0' => :file0
      }
    end

    let(:expected_params) do
      [
        {
          'query' => 'mutation { blah blah }',
          'operationName' => 'SomeOperation',
          'variables' => { 'input' => { 'id' => '123', 'avatar' => :file0 } }
        }
      ]
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end

  describe '#call for multiple operations' do
    let(:params) do
      {
        'operations' => [{
          'query' => 'mutation { blah blah1 }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123' } }
        },
                         {
                           'query' => 'mutation { blah blah2 }',
                           'operationName' => 'hashKeyCzaza',
                           'variables' => { 'input' => { 'id' => '123' } }
                         },
                         {
                           'query' => 'mutation { blah blah3 }',
                           'operationName' => 'Some_Operation',
                           'hashKeyA' => { 'hashKeyB' => { 'id' => '123' } }
                         }].to_json,
        'map' => { '0' => ['0.variables.input.avatar', '2.hashKeyA.hashKeyB.hashKeyC'] }.to_json,
        '0' => :file0
      }
    end

    let(:expected_params) do
      [
        {
          'query' => 'mutation { blah blah1 }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123', 'avatar' => :file0 } }
        },
        {
          'query' => 'mutation { blah blah2 }',
          'operationName' => 'hashKeyCzaza',
          'variables' => { 'input' => { 'id' => '123' } }
        },
        {
          'query' => 'mutation { blah blah3 }',
          'operationName' => 'Some_Operation',
          'hashKeyA' => { 'hashKeyB' => { 'id' => '123', 'hashKeyC' => :file0 } }
        }
      ]
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end

  describe '#call for multiple operations and many files' do
    let(:params) do
      {
        'operations' => [{
          'query' => 'mutation { blah blah1 }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123' } }
        },
                         {
                           'query' => 'mutation { blah blah2 }',
                           'operationName' => 'hashKeyCzaza',
                           'variables' => { 'input' => { 'id' => '123' } }
                         },
                         {
                           'query' => 'mutation { blah blah3 }',
                           'operationName' => 'Some_Operation',
                           'hashKeyA' => { 'hashKeyB' => { 'id' => '123' } }
                         }].to_json,
        'map' => { '0' => ['0.variables.input.avatar', '2.hashKeyA.hashKeyB.hashKeyC', '2.hashKeyA.hashKeyB.file0'],
                   '2' => ['0.variables.input.file2', '1.variables.input.profile_photo'] }.to_json,
        '0' => :file0,
        '1' => :file1,
        '2' => :file2
      }
    end

    let(:expected_params) do
      [
        {
          'query' => 'mutation { blah blah1 }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123', 'avatar' => :file0, 'file2' => :file2 } }
        },
        {
          'query' => 'mutation { blah blah2 }',
          'operationName' => 'hashKeyCzaza',
          'variables' => { 'input' => { 'id' => '123', 'profile_photo' => :file2 } }
        },
        {
          'query' => 'mutation { blah blah3 }',
          'operationName' => 'Some_Operation',
          'hashKeyA' => { 'hashKeyB' => { 'id' => '123', 'hashKeyC' => :file0, 'file0' => :file0 } }
        }
      ]
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end
end
