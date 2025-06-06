class GenerateChatResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_message)
    response = chat(chat_message.message)
    chat_message.update(response: response)
  end

  def client
    @client ||= OpenAI::Client.new(
      uri_base: "http://127.0.0.1:11434"
    )
  end

  def chat(message)
    response = client.chat(
      parameters: {
        model: "llama3.2:latest",
        messages: [ { role: "user", content: message } ],
        temperature: 0.7,
        max_tokens: 128
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
