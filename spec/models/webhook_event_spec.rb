require 'rails_helper'

RSpec.describe WebhookEvent, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:timestamp) }
  end
end
