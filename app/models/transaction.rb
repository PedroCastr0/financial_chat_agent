class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true
  validates :transaction_date, presence: true

  TRANSACTION_TYPES = %w[credit debit].freeze
  CATEGORIES = %w[
    groceries
    dining
    transportation
    entertainment
    shopping
    utilities
    healthcare
    travel
    other
  ].freeze

  scope :recent, -> { order(transaction_date: :desc) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_date_range, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }
end 