class ChatMessage < ApplicationRecord
  broadcasts_to :session_id

  after_create_commit do
    GenerateChatResponseJob.perform_later(self)
  end
end
