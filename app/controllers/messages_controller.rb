class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.valid? && @message.deliver
      redirect_to root_path, notice: 'Message sent!'
    else
      flash[:alert] = "The message could not be sent, please try again!"
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:email, :subject, :content)
  end
end
