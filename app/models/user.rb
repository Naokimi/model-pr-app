# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("student")
#  total_lesson_minutes   :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[student teacher]

  has_many :lessons, foreign_key: :teacher_id
  has_many :user_lessons, foreign_key: :student_id

  validates :first_name, :last_name, :role, :total_lesson_minutes, presence: true
  validates :total_lesson_minutes, numericality: { greater_than_or_equal_to: 0 }
  validates :role, inclusion: { in: ROLES }

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
