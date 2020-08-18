require 'spec_helper'
require 'apollo_upload_server/upload'

RSpec.describe ApolloUploadServer::Upload do
  let(:ctx) { {} }

  describe '#coerce_input' do
    let(:uploaded_file) { ApolloUploadServer::Wrappers::UploadedFile.new('test') }

    specify do
      expect(described_class.coerce_input(uploaded_file, ctx)).to eq(uploaded_file)
      expect { described_class.coerce_input('test', ctx) }.to raise_error(GraphQL::CoercionError)
    end
  end

  describe '#coerce_result' do
    it { expect(described_class.coerce_result('test', ctx)).to eq 'test' }
  end
end
