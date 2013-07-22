class AddStateToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :is_paid, :boolean
  end
end
