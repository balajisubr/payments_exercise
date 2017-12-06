class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.date :payment_date
      t.timestamps null: false
      t.belongs_to :loan
    end
  end
end
