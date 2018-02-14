require 'spec_helper'
require 'apollo_upload_server/upload'

RSpec.describe ApolloUploadServer::Upload do

  describe '#coerce_input' do
    it { expect(described_class.coerce_input('test')).to eq 'test' }
  end

  describe '#coerce_result' do
    it { expect(described_class.coerce_result('test')).to eq 'test' }
  end
end
