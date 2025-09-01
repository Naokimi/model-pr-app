# == Schema Information
#
# Table name: user_lessons
#
#  id             :bigint           not null, primary key
#  clock_out_time :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  lesson_id      :bigint           not null
#  student_id     :bigint           not null
#
# Indexes
#
#  index_user_lessons_on_lesson_id   (lesson_id)
#  index_user_lessons_on_student_id  (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (lesson_id => lessons.id)
#  fk_rails_...  (student_id => users.id)
#
class UserLesson < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :lesson

  validates :clock_out_time, presence: true, on: :update
  validates :student_id, uniqueness: { scope: :lesson_id, message: "has already joined this lesson" }
  validate :clock_out_time_after_creation_time, on: :update

  private

  def clock_out_time_after_creation_time
    return if clock_out_time.nil?

    errors.add(:clock_out_time, "must be in the future") unless clock_out_time > created_at
  end
end
