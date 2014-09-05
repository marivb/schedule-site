class Api::SchedulesController < ApplicationController
  def show
    schedule = Schedule.find params[:id]
    render json: schedule, status: 200, root: false
  end

  def update
    schedule = Schedule.find params[:id]
    editor = ScheduleEditor.new(schedule)
    editor.process_deletions convert_keys(params[:deletions])
    editor.process_additions convert_keys(params[:additions])
    schedule.save
    render json: schedule, status: 200, root: false
  end

  private

  def convert_keys(camelized_array)
    camelized_array.map do |hash|
      Hash[hash.map { |k, v| [k.to_s.underscore.to_sym, v] } ]
    end
  end
end
