class WebhookEventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @events = WebhookEvent.order(created_at: :desc).limit(10)
  end

  def create
    @webhook = WebhookEvent.new(event_params)

    if @webhook.save
      head :ok
    else
      head :bad_request
    end
  end

  private

  def event_params
    details = params.permit(:event, :timestamp, :token)
    details[:timestamp] = Time.zone.at(details[:timestamp].to_i)
    details
  end
end
