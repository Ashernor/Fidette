class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.string :title
      t.text :body
      t.decimal :value
      t.date :date

      t.timestamps
    end
  end
end
