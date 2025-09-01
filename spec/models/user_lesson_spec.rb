# == Schema Information
#
# Table name: user_lessons
#
#  id             :integer          not null, primary key
#  clock_out_time :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  lesson_id      :integer          not null
#  student_id     :integer          not null
#
# Indexes
#
#  index_user_lessons_on_lesson_id   (lesson_id)
#  index_user_lessons_on_student_id  (student_id)
#
# Foreign Keys
#
#  lesson_id   (lesson_id => lessons.id)
#  student_id  (student_id => users.id)
#
require "rails_helper"

RSpec.describe UserLesson, type: :model do
  let(:student) { create(:user) }
  let(:teacher) { create(:user, :teacher) }
  let(:lesson)  { create(:lesson, teacher: teacher) }

  subject(:user_lesson) { build(:user_lesson, student: student, lesson: lesson) }

  describe "associations" do
    it "belongs to a student (User)" do
      assoc = described_class.reflect_on_association(:student)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:class_name]).to eq("User")
    end

    it "belongs to a lesson" do
      assoc = described_class.reflect_on_association(:lesson)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    context "on create" do
      it "does not require clock_out_time" do
        expect(user_lesson).to be_valid
      end

      it "does not allow the same student to join the same lesson twice" do
        create(:user_lesson, student: student, lesson: lesson)
        duplicate = build(:user_lesson, student: student, lesson: lesson)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:student_id]).to include("has already joined this lesson")
      end
    end

    context "on update" do
      it "requires clock_out_time to be present" do
        user_lesson = create(:user_lesson, student: student, lesson: lesson, clock_out_time: Time.current)

        user_lesson.clock_out_time = nil
        expect(user_lesson).not_to be_valid
        expect(user_lesson.errors[:clock_out_time]).to include("can't be blank")
      end

      it "requires clock_out_time to be in the future" do
        user_lesson = create(:user_lesson, student: student, lesson: lesson)

        user_lesson.clock_out_time = user_lesson.created_at
        expect(user_lesson).not_to be_valid
        expect(user_lesson.errors[:clock_out_time]).to include("must be in the future")
      end
    end
  end
end
