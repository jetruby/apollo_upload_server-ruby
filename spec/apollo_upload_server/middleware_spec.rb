require 'spec_helper'
require 'action_dispatch'
require 'apollo_upload_server/middleware'

describe ApolloUploadServer::Middleware do
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
        Rack::MockRequest.new(app).post('/', { 'CONTENT_TYPE' => 'text/pain' })
      end

      it { expect(subject.status).to eq(200) }
    end
  end
end
