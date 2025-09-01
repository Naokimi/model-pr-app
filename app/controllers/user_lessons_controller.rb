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

    if @user_lesson.update(clock_out_time: Time.current)
      current_user.update(total_lesson_hours: current_user.total_lesson_hours + 1)
      redirect_to root_path, notice: "Clocked out successfully."
    else
      redirect_to root_path, alert: "Unable to clock out."
    end
  end
end
