class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :account_type, presence: true
  validates :account_number, presence: true, uniqueness: true
  validates :balance, numericality: true

  ACCOUNT_TYPES = %w[checking savings credit_card].freeze

  def recent_transactions(limit = 5)
    transactions.order(transaction_date: :desc).limit(limit)
  end

  def monthly_spending
    transactions
      .where(transaction_type: 'debit')
      .where('transaction_date >= ?', 30.days.ago)
      .sum(:amount)
  end

  def monthly_income
    transactions
      .where(transaction_type: 'credit')
      .where('transaction_date >= ?', 30.days.ago)
      .sum(:amount)
  end
end 