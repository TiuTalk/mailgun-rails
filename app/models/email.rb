class Email
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def do_not_contact?
    unsubscribed? or has_complaints?
  end

  def events
    response = client.get("#{domain}/events", limit: 10, event: 'delivered', to: address)
    response = response.to_h!
    response['items']
  rescue Mailgun::Error
    []
  end

  def unsubscribed?
    response = client.get("#{domain}/unsubscribes/#{address}")
    response.code == 200
  rescue Mailgun::Error
    false
  end

  def has_complaints?
    response = client.get("#{domain}/complaints/#{address}")
    response.code == 200
  rescue Mailgun::Error
    false
  end

  private

  def client
    @client ||= Mailgun::Client.new
  end

  def domain
    Rails.application.secrets.mailgun_domain
  end
end
