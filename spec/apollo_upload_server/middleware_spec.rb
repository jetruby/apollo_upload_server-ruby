require 'spec_helper'
require 'action_dispatch'
require 'apollo_upload_server/middleware'

describe ApolloUploadServer::Middleware do
  around do |example|
    mode = described_class.strict_mode
    example.run
    described_class.strict_mode = mode
  end

  describe '#call' do
    let(:app) do
      Rack::Builder.new do
        use ApolloUploadServer::Middleware
        run ->(_env) { [200, { 'Content-Type' => 'text/plain' }, 'Hello, World.'] }
      end
    end

    context "when CONTENT_TYPE is 'multipart/form-data'" do
      subject do
        Rack::MockRequest.new(app).post('/', { 'CONTENT_TYPE' => 'multipart/form-data', input: 'operations=foo&map=bar' })
      end

      it { expect(subject.status).to eq(200) }
    end

    context "when CONTENT_TYPE is not 'multipart/form-data'" do
      subject do
        Rack::MockRequest.new(app).post('/', { 'CONTENT_TYPE' => 'text/plain' })
      end

      it { expect(subject.status).to eq(200) }
    end

    context 'when configured to run in strict mode' do
      before do
        described_class.strict_mode = true
      end

      subject do
        Rack::MockRequest.new(app).post('/', { 'CONTENT_TYPE' => 'multipart/form-data', input: 'operations=foo&map=bar' })
      end

      it 'propagates this setting to the data builder' do
        expect(ApolloUploadServer::GraphQLDataBuilder).to receive(:new).with(strict_mode: true).and_call_original

        subject
      end
    end
  end
end
