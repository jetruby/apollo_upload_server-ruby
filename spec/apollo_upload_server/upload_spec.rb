require 'spec_helper'
require 'apollo_upload_server/upload'

RSpec.describe ApolloUploadServer::Upload do
  let(:ctx) { {} }

  describe '#coerce_input' do
    specify do
      expect(described_class.coerce_input(nil, ctx)).to eq(nil)
    end
  end

  describe '#coerce_result' do
    it { expect(described_class.coerce_result('test', ctx)).to eq 'test' }
  end
end
