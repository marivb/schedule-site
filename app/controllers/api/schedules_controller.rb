class Api::SchedulesController < ApplicationController
  def show
    schedule = Schedule.find(params[:id])
    render json: schedule, status: 200, root: false
  end
end
