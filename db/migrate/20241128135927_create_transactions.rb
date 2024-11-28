class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :points
      t.integer :given_by_id
      t.integer :given_to_id

      t.timestamps
    end
  end
end
