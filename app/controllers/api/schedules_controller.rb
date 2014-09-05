class Api::SchedulesController < ApplicationController
  def show
    schedule = Schedule.find params[:id]
    render json: schedule, status: 200, root: false
  end

  def update
    schedule = Schedule.find params[:id]
    editor = ScheduleEditor.new(schedule)
    editor.process_additions(params[:additions])
    editor.process_deletions(params[:deletions])
    schedule.save
    render json: schedule, status: 200, root: false
  end
end
