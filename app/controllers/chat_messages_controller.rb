class ChatMessagesController < ApplicationController
  def create
    @chat_message = ChatMessage.new(chat_message_params)
    @chat_message.session_id = session.id.to_s
    @chat_message.save
    head :ok
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:message)
  end
end
