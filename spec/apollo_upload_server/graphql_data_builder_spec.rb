require 'spec_helper'
require 'apollo_upload_server/graphql_data_builder'

describe ApolloUploadServer::GraphQLDataBuilder do
  describe '#call for single operation' do
    let(:params) do
      {
        'operations' => {
          'query' => 'mutation { blah blah }',
          'operationName' => 'SomeOperation',
          'variables' => { 'input' => { 'id' => '123', 'model' => {} } }
        }.to_json,
        'map' => { '0' => ['variables.input.avatar', 'variables.input.model.avatar'] }.to_json,
        '0' => :file0
      }
    end

    let(:expected_params) do
      {
        'query' => 'mutation { blah blah }',
        'operationName' => 'SomeOperation',
        'variables' => { 'input' => { 'id' => '123', 'avatar' => :file0, 'model' => { 'avatar' => :file0 } } }
      }
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end

  describe '#call for single operation with multiple files' do
    let(:params) do
      {
        'operations' => {
          'query' => 'mutation { blah blah }',
          'operationName' => 'SomeOperation',
          'variables' => { 'input' => { 'id' => '123', 'avatars' => [nil], 'model' => { 'avatars' => [nil] } } }
        }.to_json,
        'map' => { '0' => ['variables.input.avatars.0', 'variables.input.model.avatars.0'] }.to_json,
        '0' => :file0
      }
    end

    let(:expected_params) do
      {
        'query' => 'mutation { blah blah }',
        'operationName' => 'SomeOperation',
        'variables' => { 'input' => { 'id' => '123', 'avatars' => [:file0], 'model' => { 'avatars' => [:file0] } } }
      }
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end

    context 'when the index is not a string' do
      let(:params) do
        {
          'operations' => {
            'query' => 'mutation { blah blah }',
            'operationName' => 'SomeOperation',
            'variables' => { 'input' => { 'id' => '123', 'avatars' => [nil], 'model' => { 'avatars' => [nil] } } }
          }.to_json,
          'map' => { '0' => ['variables.input.avatars.foo', 'variables.input.model.avatars.0'] }.to_json,
          '0' => :file0
        }
      end

      specify do
        expect(described_class.new.call(params)).to eq(expected_params)
      end

      it 'is rejected in strict mode' do
        expect do
          described_class.new(strict_mode: true).call(params)
        end.to raise_error(described_class::OutOfBounds)
      end
    end

    context 'when the array is empty' do
      let(:params) do
        {
          'operations' => {
            'query' => 'mutation { blah blah }',
            'operationName' => 'SomeOperation',
            'variables' => { 'input' => { 'id' => '123', 'avatars' => [], 'model' => { 'avatars' => [nil] } } }
          }.to_json,
          'map' => { '0' => ['variables.input.avatars.0', 'variables.input.model.avatars.0'] }.to_json,
          '0' => :file0
        }
      end

      let(:expected_params) do
        {
          'query' => 'mutation { blah blah }',
          'operationName' => 'SomeOperation',
          'variables' => { 'input' => { 'id' => '123', 'avatars' => [:file0], 'model' => { 'avatars' => [:file0] } } }
        }
      end

      specify do
        expect(described_class.new.call(params)).to eq(expected_params)
      end

      it 'accepts this input in lax mode' do
        expect(described_class.new.call(params)).to eq(expected_params)
      end

      it 'rejects this input in strict mode' do
        expect do
          described_class.new(strict_mode: true).call(params)
        end.to raise_error(described_class::OutOfBounds)
      end
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
      {'_json' => [
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
      ]}
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
                           'hashKeyA' => { 'hashKeyB' => { 'id' => '123', 'model' => { 'id' => '23' } } }
                         }].to_json,
        'map' => { '0' => ['0.variables.input.avatar', '2.hashKeyA.hashKeyB.hashKeyC', '2.hashKeyA.hashKeyB.file0'],
                   '2' => ['0.variables.input.file2', '1.variables.input.profile_photo', '2.hashKeyA.hashKeyB.model.photo'] }.to_json,
        '0' => :file0,
        '1' => :file1,
        '2' => :file2
      }
    end

    let(:expected_params) do
      {'_json' => [
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
          'hashKeyA' => { 'hashKeyB' => { 'id' => '123', 'model' => { 'id' => '23', 'photo' => :file2 }, 'hashKeyC' => :file0, 'file0' => :file0 } }
        }
      ] }
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end

  describe '#call for multiple operations with multiple files' do
    let(:params) do
      {
        'operations' => [{
            'query' => 'mutation { blah blah1 }',
            'operationName' => nil,
            'variables' => { 'input' => { 'id' => '123', 'avatars' => [nil] } }
          },
          {
            'query' => 'mutation { blah blah2 }',
            'operationName' => 'hashKeyCzaza',
            'variables' => { 'input' => { 'id' => '123', 'avatars' => [nil] } }
          }
        ].to_json,
        'map' => { '0' => ['0.variables.input.avatars.0', '1.variables.input.avatars.0'] }.to_json,
        '0' => :file0
      }
    end

    let(:expected_params) do
      {'_json' => [
        {
          'query' => 'mutation { blah blah1 }',
          'operationName' => nil,
          'variables' => { 'input' => { 'id' => '123', 'avatars' => [:file0] } }
        },
        {
          'query' => 'mutation { blah blah2 }',
          'operationName' => 'hashKeyCzaza',
          'variables' => { 'input' => { 'id' => '123', 'avatars' => [:file0] } }
        }
      ]}
    end

    specify do
      expect(described_class.new.call(params)).to eq(expected_params)
    end
  end
end
