class GenerateCategoryResponse
  def self.call(category, user)
    new(category, user).call
  end

  def initialize(category, user)
    @category = category
    @user = user
  end

  def call
    case @category
    when "Greeting"
      "Hello, how can I help you today?"
    when "Checking Account Balance"
      "Your checking account balance is $#{number_with_precision(@user.accounts.find_by(account_type: 'checking')&.balance || 0, precision: 2)}"
    when "Savings Account Balance"
      "Your savings account balance is $#{number_with_precision(@user.accounts.find_by(account_type: 'savings')&.balance || 0, precision: 2)}"
    when "Transaction History"
      recent_transactions = @user.recent_transactions(5)
      if recent_transactions.any?
        response = "Here are your 5 most recent transactions:\n"
        recent_transactions.each do |transaction|
          response += "#{transaction.transaction_date.strftime('%b %d')} - #{transaction.description}: $#{number_with_precision(transaction.amount, precision: 2)}\n"
        end
        response
      else
        "You don't have any recent transactions."
      end
    when "Credit Card Information"
      credit_card = @user.accounts.find_by(account_type: "credit_card")
      if credit_card
        "Your credit card balance is $#{number_with_precision(credit_card.balance, precision: 2)}"
      else
        "You don't have a credit card account."
      end
    when "Account Management"
      "You can manage your account settings in the dashboard. Would you like me to guide you through any specific changes?"
    when "Fraud Alert"
      "Please contact your bank immediately at 867-5309."
    when "Monthly Spending"
      "Your total spending this month is $#{number_with_precision(@user.monthly_spending, precision: 2)}"
    when "Monthly Income"
      "Your total income this month is $#{number_with_precision(@user.monthly_income, precision: 2)}"
    when "Spending Categories"
      categories = @user.recent_transactions.group_by(&:category)
      if categories.any?
        response = "Here's your spending by category:\n"
        categories.each do |category, transactions|
          total = transactions.sum(&:amount)
          response += "#{category.capitalize}: $#{number_with_precision(total, precision: 2)}\n"
        end
        response
      else
        "You don't have any recent transactions to categorize."
      end
    else
      "I'm not sure how to help with that. Could you please rephrase your question?"
    end
  end

  private

  def number_with_precision(number, precision: 2)
    format("%.#{precision}f", number)
  end
end
