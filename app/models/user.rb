class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :accounts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def total_balance
    accounts.sum(:balance)
  end

  def monthly_spending
    accounts.sum(&:monthly_spending)
  end

  def monthly_income
    accounts.sum(&:monthly_income)
  end

  def recent_transactions(limit = 10)
    Transaction.joins(:account)
              .where(accounts: { user_id: id })
              .order(transaction_date: :desc)
              .limit(limit)
  end
end
