require 'rails_helper'

RSpec.describe EmailsController, type: :controller do
  describe "GET #check" do
    it "returns http success" do
      get :check
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #check" do
    it "respond correctly when email is not blocked" do
      expect_any_instance_of(Email).to receive(:do_not_contact?).and_return(false)

      post :check, params: { email: { address: 'contato@thiagobelem.net' } }

      expect(flash[:success]).to eq('The email is not on the DO NOT CONTACT list!')
      expect(response).to have_http_status(:success)
    end

    it "respond correctly when email is blocked" do
      expect_any_instance_of(Email).to receive(:do_not_contact?).and_return(true)

      post :check, params: { email: { address: 'contato@thiagobelem.net' } }

      expect(flash[:error]).to eq('The email is on the DO NOT CONTACT list!')
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #history" do
    it "returns http success" do
      get :history
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #history" do
    it "return the list of email deliveries" do
      event = { 'timestamp' => Time.zone.now.to_i, 'message' => { 'headers' => { 'subject' => 'Something' } } }
      expect_any_instance_of(Email).to receive(:events).and_return([event])

      post :history, params: { email: { address: 'contato@thiagobelem.net' } }

      expect(response).to have_http_status(:success)
    end

    it "return a warning when the email has no events" do
      expect_any_instance_of(Email).to receive(:events).and_return([])

      post :history, params: { email: { address: 'contato@thiagobelem.net' } }

      expect(flash[:alert]).to eq('There are no events for this email')
      expect(response).to have_http_status(:success)
    end
  end
end
