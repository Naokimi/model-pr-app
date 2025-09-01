# == Schema Information
#
# Table name: lessons
#
#  id         :integer          not null, primary key
#  content    :text
#  start_time :datetime         not null
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  teacher_id :integer          not null
#
# Indexes
#
#  index_lessons_on_teacher_id  (teacher_id)
#
# Foreign Keys
#
#  teacher_id  (teacher_id => users.id)
#
require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:teacher) { create(:user, :teacher) }
  subject(:lesson) { build(:lesson, teacher: teacher) }

  describe "validations" do
    it "is valid with all required attributes" do
      expect(lesson).to be_valid
    end

    context "when missing attributes" do
      it "requires a start_time" do
        lesson.start_time = nil
        expect(lesson).not_to be_valid
        expect(lesson.errors[:start_time]).to include("can't be blank")
      end

      it "requires a teacher" do
        lesson.teacher = nil
        expect(lesson).not_to be_valid
        expect(lesson.errors[:teacher]).to include("must exist").or include("can't be blank")
      end

      it "requires a subject" do
        lesson.subject = nil
        expect(lesson).not_to be_valid
        expect(lesson.errors[:subject]).to include("can't be blank")
      end
    end
  end

  describe "#end_time" do
    it "returns start_time plus one hour" do
      now = Time.current.change(usec: 0)
      custom = build(:lesson, start_time: now, teacher: teacher, subject: "Sci", content: "")
      expect(custom.end_time).to eq(now + 1.hour)
    end

    it "returns a Time object" do
      expect(lesson.end_time).to be_a(ActiveSupport::TimeWithZone).or be_a(Time)
    end
  end

  describe "associations" do
    it "belongs to a teacher (User)" do
      assoc = described_class.reflect_on_association(:teacher)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:class_name]).to eq("User")
    end
  end
end
