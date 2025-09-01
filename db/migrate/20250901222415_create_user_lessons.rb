class CreateUserLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :user_lessons do |t|
      t.datetime :clock_out_time
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
