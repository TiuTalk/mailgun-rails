require 'rails_helper'

RSpec.describe WebhookEventsController, type: :controller do
  render_views

  describe 'GET #index' do
    let!(:event) { WebhookEvent.create!(event: 'click', timestamp: Time.zone.now, token: SecureRandom.hex(10)) }

    it 'return the list of stored events' do
      get :index
      expect(response).to be_ok
      expect(response.body).to include(event.token)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:params) { { "event"=>"opened", "timestamp"=>"1476026395", "token"=>"3bde27c0d057dd973e904324370bda5b46d468a64d41cb00c5" } }

      it 'create an WebhookEvent and return ok' do
        expect do
          post :create, params: params
        end.to change(WebhookEvent, :count).by(1)

        expect(response).to be_ok
        expect(response.body).to be_empty
      end
    end

    context 'with invalid params' do
      let(:params) { { "timestamp"=>"1476026395", "token"=>"3bde27c0d057dd973e904324370bda5b46d468a64d41cb00c5" } }

      it 'create an WebhookEvent and return ok' do
        expect do
          post :create, params: params
        end.to_not change(WebhookEvent, :count)

        expect(response).to be_bad_request
        expect(response.body).to be_empty
      end
    end
  end
end
