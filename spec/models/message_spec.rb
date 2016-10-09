require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe '#deliver' do
    before do
      @client = double('Mailgun::Client.new', send_message: true)
      expect(Mailgun::Client).to receive(:new).and_return(@client)
    end

    let(:domain) {  Rails.application.secrets.mailgun_domain }
    let(:params) { { from: "no-reply@#{domain}", to: message.email, subject: message.subject, text: message.content } }

    context 'with valid params' do
      subject(:message) { described_class.new(email: 'contato@thiagobelem.net', subject: 'Testing', content: 'Something') }

      let(:result) { OpenStruct.new(code: 200) }

      it 'deliver the message using Mailgun::Client' do
        expect(@client).to receive(:send_message).with(domain, params).and_return(result)
        expect(message.deliver).to be_truthy
      end
    end

    context 'with invalid params' do
      subject(:message) { described_class.new(email: 'test@example.com', subject: 'Testing', content: 'Something') }

      it 'return false' do
        expect(@client).to receive(:send_message).with(domain, params).and_raise(Mailgun::Error, 'Something')
        expect(message.deliver).to be_falsy
      end
    end
  end
end
