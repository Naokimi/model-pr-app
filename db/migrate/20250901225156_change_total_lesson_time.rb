class ChangeTotalLessonTime < ActiveRecord::Migration[8.0]
  def up
    rename_column :users, :total_lesson_hours, :total_lesson_minutes
    User.all.each { |user| user.update!(total_lesson_minutes: user.total_lesson_minutes * 60) }
  end

  def down
    rename_column :users, :total_lesson_minutes, :total_lesson_hours
    User.all.each { |user| user.update!(total_lesson_hours: user.total_lesson_hours / 60) }
  end
end
