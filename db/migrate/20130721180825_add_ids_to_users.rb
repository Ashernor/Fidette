class AddIdsToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :creditor_id, :integer
    add_column :debts, :debtor_id, :integer
  end
end
