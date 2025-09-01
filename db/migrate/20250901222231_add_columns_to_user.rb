class AddColumnsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :total_lesson_hours, :integer, default: 0
    add_column :users, :role, :string, default: "student"
  end
end
