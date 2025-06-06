class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :transaction_type, null: false
      t.string :description
      t.string :category
      t.string :merchant
      t.date :transaction_date, null: false
      t.string :status, default: 'completed'

      t.timestamps
    end

    add_index :transactions, :transaction_date
    add_index :transactions, :category
  end
end 