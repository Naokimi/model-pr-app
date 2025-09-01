require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /dashboard" do
    context "when not logged in" do
      it "redirects to login page" do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      let(:student) { create(:user, role: 'student', total_lesson_hours: 10) }
      let(:teacher) { create(:user, role: 'teacher') }

      before do
        sign_in student
      end

      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "displays total lesson hours" do
        get root_path
        expect(response.body).to include("Total Lesson Hours: 10")
      end

      context "with an active lesson" do
        let!(:lesson) { create(:lesson, teacher: teacher, start_time: 30.minutes.from_now) }

        it "shows the active lesson details" do
          get root_path
          expect(response.body).to include(lesson.subject)
          expect(response.body).to include(lesson.content)
          expect(response.body).to include(teacher.full_name)
        end

        context "when not clocked in" do
          it "shows enabled clock in button and disabled clock out button" do
            get root_path
            expect(response.body).to include('Clock In')
            expect(response.body).to include('btn-secondary disabled')
          end
        end

        context "when clocked in" do
          let!(:user_lesson) { create(:user_lesson, student: student, lesson: lesson) }

          it "shows disabled clock in button and enabled clock out button" do
            get root_path
            expect(response.body).to include('disabled')
            expect(response.body).to include('Clock Out')
          end

          context "when already clocked out" do
            let!(:user_lesson) { create(:user_lesson, student: student, lesson: lesson, clock_out_time: Time.current) }

            it "shows both buttons as disabled" do
              get root_path
              expect(response.body).to include('disabled')
              expect(response.body).to include('btn-secondary disabled')
            end
          end
        end
      end

      context "without an active lesson" do
        it "shows 'No active lessons' message" do
          get root_path
          expect(response.body).to include("No active lessons")
        end
      end
    end
  end
end
