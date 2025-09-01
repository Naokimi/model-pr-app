# == Schema Information
#
# Table name: lessons
#
#  id         :bigint           not null, primary key
#  content    :text
#  start_time :datetime         not null
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  teacher_id :bigint           not null
#
# Indexes
#
#  index_lessons_on_teacher_id  (teacher_id)
#
# Foreign Keys
#
#  fk_rails_...  (teacher_id => users.id)
#
class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  has_many :user_lessons
  has_many :students, through: :user_lessons, class_name: "User"

  validates :start_time, :subject, presence: true

  def end_time
    start_time + 1.hour
  end
end
