require 'spec_helper'
require 'apollo_upload_server/upload'

RSpec.describe ApolloUploadServer::Upload do
  let(:ctx) { {} }

  describe '#coerce_input' do
    it { expect(described_class.coerce_input('test', ctx)).to eq 'test' }
  end

  describe '#coerce_result' do
    it { expect(described_class.coerce_result('test', ctx)).to eq 'test' }
  end
end
