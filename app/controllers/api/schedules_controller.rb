class Api::SchedulesController < ApplicationController
  def show
    schedule = Schedule.find params[:id]
    render json: schedule, status: 200, root: false
  end

  def update
    schedule = Schedule.find params[:id]
    editor = ScheduleEditor.new(schedule)
    editor.process convert_keys(params[:change])
    if editor.save
      render json: schedule, status: 200, root: false
    else
      render json: { errors: schedule.errors }, status: 400
    end
  end

  private

  def convert_keys(object)
    case object
    when Array
      object.map { |element| convert_keys(element) }
    when Hash
      Hash[object.map { |k, v| [convert_key(k), convert_keys(v)] }]
    else
      object
    end
  end

  def convert_key(symbol)
    symbol.to_s.underscore.to_sym
  end
end
