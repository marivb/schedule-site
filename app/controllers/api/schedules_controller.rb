class Api::SchedulesController < ApplicationController
  def show
    schedule = Schedule.find params[:id]
    render json: schedule, status: 200, root: false
  end

  def update
    schedule = Schedule.find params[:id]
    editor = ScheduleEditor.new(schedule)
    editor.process_deletions convert_keys(params[:deletions]) if params.has_key? :deletions
    editor.process_additions convert_keys(params[:additions]) if params.has_key? :additions
    if schedule.save
      render json: schedule, status: 200, root: false
    else
      render json: { errors: schedule.errors }, status: 400
    end
  end

  private

  def convert_keys(camelized_array)
    camelized_array.map do |hash|
      Hash[hash.map { |k, v| [k.to_s.underscore.to_sym, v] } ]
    end
  end
end
