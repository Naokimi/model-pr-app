class PagesController < ApplicationController
  def dashboard
    @total_lesson_minutes = current_user.total_lesson_minutes

    window_start = 15.minutes.ago
    window_end   = 75.minutes.from_now

    @active_lesson = Lesson.find_by(start_time: window_start..window_end)
    @user_lesson = current_user.user_lessons.find_by(lesson: @active_lesson) if @active_lesson
  end
end
