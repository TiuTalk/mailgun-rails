class WebhookEvent < ApplicationRecord
  # Validations
  validates :event, :timestamp, presence: true
end
