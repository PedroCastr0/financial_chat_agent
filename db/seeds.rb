# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a test user
user = User.create!(
  email_address: "admin@gmail.com",
  password: "123"
)

# Create accounts for the user
checking = Account.create!(
  user: user,
  account_type: "checking",
  account_number: "CHK123456",
  balance: 5000.00,
  currency: "USD"
)

savings = Account.create!(
  user: user,
  account_type: "savings",
  account_number: "SAV789012",
  balance: 15000.00,
  currency: "USD"
)

credit_card = Account.create!(
  user: user,
  account_type: "credit_card",
  account_number: "CC345678",
  balance: -1200.00,
  currency: "USD"
)

# Define realistic transaction descriptions by category
TRANSACTION_DESCRIPTIONS = {
  "groceries" => [
    "Whole Foods Market - Organic Groceries",
    "Trader Joe's - Weekly Groceries",
    "Walmart Grocery - Household Items",
    "Target - Grocery Shopping",
    "Local Farmers Market - Fresh Produce"
  ],
  "dining" => [
    "Starbucks Coffee - Morning Latte",
    "Chipotle Mexican Grill - Lunch Burrito",
    "Olive Garden - Family Dinner",
    "Local Pizza Place - Friday Night Pizza",
    "Sushi Restaurant - Anniversary Dinner"
  ],
  "transportation" => [
    "Uber Ride - Airport Transfer",
    "Lyft Ride - Downtown Trip",
    "Shell Gas Station - Weekly Fill-up",
    "Monthly Metro Pass",
    "City Parking - Downtown"
  ],
  "entertainment" => [
    "Netflix - Monthly Subscription",
    "Spotify Premium - Music Subscription",
    "AMC Theaters - Movie Night",
    "Ticketmaster - Concert Tickets",
    "Gold's Gym - Monthly Membership"
  ],
  "shopping" => [
    "Amazon.com - Electronics Purchase",
    "Target - Home Decor",
    "Best Buy - New Laptop",
    "Nike Store - Running Shoes",
    "Apple Store - iPhone Accessories"
  ],
  "utilities" => [
    "PG&E - Monthly Electric Bill",
    "City Water - Water Bill",
    "Comcast - Internet Service",
    "Verizon - Phone Bill",
    "Pacific Gas - Natural Gas Bill"
  ],
  "healthcare" => [
    "Kaiser Permanente - Doctor Visit",
    "CVS Pharmacy - Prescription",
    "Dental Care - Checkup",
    "Vision Center - Eye Exam",
    "Blue Cross - Health Insurance"
  ],
  "travel" => [
    "United Airlines - Flight to NYC",
    "Marriott Hotel - Weekend Stay",
    "Airbnb - Vacation Rental",
    "Hertz - Car Rental",
    "Allianz - Travel Insurance"
  ],
  "other" => [
    "Miscellaneous - Office Supplies",
    "General Store - Household Items",
    "7-Eleven - Snacks",
    "Local Shop - Gifts",
    "Online Store - Miscellaneous"
  ]
}

# Generate transactions for the last 30 days
30.times do |i|
  date = i.days.ago
  # Create 2-3 transactions per day
  rand(2..3).times do
    category = Transaction::CATEGORIES.sample
    transaction_type = Transaction::TRANSACTION_TYPES.sample
    
    # Adjust amount ranges based on category
    amount = case category
    when "groceries"
      rand(30.0..150.0)
    when "dining"
      rand(15.0..80.0)
    when "transportation"
      rand(10.0..50.0)
    when "entertainment"
      rand(10.0..100.0)
    when "shopping"
      rand(20.0..200.0)
    when "utilities"
      rand(50.0..200.0)
    when "travel"
      rand(100.0..500.0)
    when "healthcare"
      rand(30.0..300.0)
    when "other"
      rand(10.0..100.0)
    else
      rand(10.0..100.0)
    end.round(2)

    description = TRANSACTION_DESCRIPTIONS[category].sample
    merchant = description.split(" - ").first

    Transaction.create!(
      account: [checking, credit_card].sample,
      amount: amount,
      transaction_type: transaction_type,
      description: description,
      category: category,
      merchant: merchant,
      transaction_date: date
    )
  end
end

# Create some income transactions
5.times do |i|
  date = i.days.ago
  Transaction.create!(
    account: checking,
    amount: rand(2000.0..5000.0).round(2),
    transaction_type: "credit",
    description: "Monthly Salary - Direct Deposit",
    category: "other",
    merchant: "Employer",
    transaction_date: date
  )
end

puts "Seed data created successfully!"
