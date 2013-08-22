class AddSolveToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :is_solved, :boolean, default: false
  end
end
