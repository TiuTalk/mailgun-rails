class Message
  include ActiveModel::Model

  attr_accessor :email, :subject, :content, :campaign

  # Validations
  validates :email, :subject, :content, presence: true

  def deliver
    params = {
      from: "no-reply@#{mailgun_domain}",
      to: email,
      subject: subject,
      html: content,
      'o:campaign' => campaign
    }

    response = mailgun_client.send_message(mailgun_domain, params)
    response.code == 200
  rescue Mailgun::Error
    false
  end

  private

  def mailgun_client
    @mailgun_client ||= Mailgun::Client.new
  end

  def mailgun_domain
    Rails.application.secrets.mailgun_domain
  end
end
