import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chat-agent"
export default class extends Controller {
  static targets = ["interface", "input", "messages"];
  connect() {
    this.observer = new MutationObserver((mutations) => {
      this.scrollToBottom();
    });
    this.observer.observe(this.messagesTarget, { childList: true });
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }

  toggleChat() {
    this.interfaceTarget.classList.toggle("hidden");
    this.interfaceTarget.classList.toggle("flex");
    this.scrollToBottom();
  }

  handleKeydown(event) {
    if (event.key === "Enter") {
      this.sendMessage();
    }
  }

  sendMessage() {
    const message = this.inputTarget.value.trim();

    if (message) {
      fetch("/chat_messages", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
        },
        body: JSON.stringify({ message: message }),
      });
      this.inputTarget.value = "";
    }
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    }
  }
}
