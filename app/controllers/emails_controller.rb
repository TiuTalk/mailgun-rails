class EmailsController < ApplicationController
  def check
    if request.post?
      @email = Email.new(params[:email][:address])

      if @email.present? && @email.do_not_contact?
        flash.now[:error] = 'The email is on the DO NOT CONTACT list!'
      else
        flash.now[:success] = 'The email is not on the DO NOT CONTACT list!'
      end
    end
  end

  def history
    if request.post?
      @email = Email.new(params[:email][:address])
      @history = @email.events if @email.present?
      flash.now[:alert] = 'There are no events for this email' if @history.empty?
    end
  end

  private

  def mailgun_client
    @client ||= Mailgun::Client.new
  end
end
