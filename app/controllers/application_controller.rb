class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_chat_messages

  private

  def set_chat_messages
    @chat_messages = ChatMessage.where(session_id: session.id.to_s)
  end
end
