require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do

    context 'with valid data' do
      let(:params) do
        { email: 'test@example.com',
          subject: 'My message',
          content: 'Testing' }
      end

      it 'deliver the message' do
        expect_any_instance_of(Message).to receive(:deliver).and_return(true)

        post :create, params: { message: params }
      end

      it 'redirect to root_path' do
        allow_any_instance_of(Message).to receive(:deliver).and_return(true)

        post :create, params: { message: params }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid data' do
      let(:params) do
        { email: 'text@example.com',
          subject: 'My message',
          content: '' }
      end

      it 'does not deliver the message' do
        expect_any_instance_of(Message).to_not receive(:deliver)

        post :create, params: { message: params }
      end
    end
  end
end
