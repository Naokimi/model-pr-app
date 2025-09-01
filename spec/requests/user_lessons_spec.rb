require 'rails_helper'

RSpec.describe "UserLessons", type: :request do
  let(:student) { create(:user, role: 'student') }
  let(:teacher) { create(:user, role: 'teacher') }
  let(:lesson) { create(:lesson, teacher: teacher, start_time: 60.minutes.ago) }

  before do
    sign_in student
  end

  describe "POST /user_lessons" do
    subject { post user_lessons_path, params: { lesson_id: lesson.id } }

    context "when clocking in for the first time" do
      it "creates a new user_lesson" do
        expect { subject }.to change(UserLesson, :count).by(1)
      end

      it "redirects with success message" do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Clocked in successfully.")
      end
    end

    context "when already clocked in" do
      before do
        create(:user_lesson, student: student, lesson: lesson)
      end

      it "does not create a new user_lesson" do
        expect { subject }.not_to change(UserLesson, :count)
      end

      it "redirects with error message" do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Unable to clock in.")
      end
    end
  end

  describe "PATCH /user_lessons/:id" do
    let!(:user_lesson) { create(:user_lesson, student: student, lesson: lesson, created_at: 60.minutes.ago) }

    subject { patch user_lesson_path(user_lesson) }

    context "when clocking out for the first time" do
      context "with full lesson time" do
        it "updates clock_out_time" do
          expect { subject }.to change { user_lesson.reload.clock_out_time }.from(nil)
        end

        it "increases total_lesson_minutes" do
          expect { subject }.to change { student.reload.total_lesson_minutes }.from(300).to(360)
        end

        it "redirects with success message" do
          subject
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq("Clocked out successfully.")
        end
      end

      context "when clock in late" do
        let!(:user_lesson) { create(:user_lesson, student: student, lesson: lesson, created_at: 15.minutes.ago) }

        it "partially increases total_lesson_minutes" do
          expect { subject }.to change { student.reload.total_lesson_minutes }.from(300).to(315)
        end
      end

      context "when clock out early" do
        before { allow(Time).to receive(:current).and_return(Time.current - 30.minutes) }

        it "partially increases total_lesson_minutes" do
          expect { subject }.to change { student.reload.total_lesson_minutes }.from(300).to(330)
        end
      end

      context "when clockin early and clockout later" do
        let!(:user_lesson) { create(:user_lesson, student: student, lesson: lesson, created_at: 70.minutes.ago) }

        before { allow(Time).to receive(:current).and_return(Time.current + 10.minutes) }

        it "increases total_lesson_minutes by the max 60" do
          expect { subject }.to change { student.reload.total_lesson_minutes }.from(300).to(360)
        end
      end
    end

    context "when already clocked out" do
      before do
        user_lesson.update(clock_out_time: Time.current)
      end

      it "does not update clock_out_time" do
        expect { subject }.not_to change { user_lesson.reload.clock_out_time }
      end

      it "does not increase total_lesson_minutes" do
        expect { subject }.not_to change { student.reload.total_lesson_minutes }
      end

      it "redirects with error message" do
        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Unable to clock out.")
      end
    end
  end
end
