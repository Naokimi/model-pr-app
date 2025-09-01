class UserLessonsController < ApplicationController
  def create
    @user_lesson = current_user.user_lessons.new(lesson_id: params[:lesson_id])

    if @user_lesson.save
      redirect_to root_path, notice: "Clocked in successfully."
    else
      redirect_to root_path, alert: "Unable to clock in."
    end
  end

  def update
    @user_lesson = current_user.user_lessons.find(params[:id])
    return redirect_to root_path, alert: "Unable to clock out." if @user_lesson.clock_out_time

    if update_lesson_time_attendance(Time.current)
      redirect_to root_path, notice: "Clocked out successfully."
    else
      redirect_to root_path, alert: "Unable to clock out."
    end
  end

  private

  def update_lesson_time_attendance(clock_out_time)
    lesson_start_time = @user_lesson.lesson.start_time
    minutes = [
      (clock_out_time - @user_lesson.created_at).round,
      (clock_out_time - lesson_start_time).round,
      (lesson_start_time + 60.minutes - @user_lesson.created_at).round,
      60.minutes
    ].min / 1.minute

    @user_lesson.update!(clock_out_time:)
    student = @user_lesson.student
    student.update!(total_lesson_minutes: student.total_lesson_minutes + minutes)
  end
end
