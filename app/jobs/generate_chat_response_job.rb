class GenerateChatResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_message, user)
    request = Net::HTTP.post(
      URI("http://127.0.0.1:8000/classify"),
        { query: chat_message.message }.to_json,
      "Content-type" => "application/json"
    ).body

    category, confidence = JSON.parse(request).dig("results")

    puts category, confidence

    response = if confidence > 60
      GenerateCategoryResponse.call(category, user)
    else
      "Sorry i don't understand your request"
    end
    chat_message.update(response: response)
  end

  # def perform(chat_message)
  #   response = chat(chat_message.message)
  #   chat_message.update(response: response)
  # end
  #
  # def client
  #   @client ||= OpenAI::Client.new(
  #     uri_base: "http://127.0.0.1:11434"
  #   )
  # end
  #
  # def chat(message)
  #   response = client.chat(
  #     parameters: {
  #       model: "llama3.2:latest",
  #       messages: [ { role: "user", content: message } ],
  #       temperature: 0.7,
  #       max_tokens: 128
  #     }
  #   )
  #   response.dig("choices", 0, "message", "content")
  # end
end
