class Api::SessionsController < ApplicationController
  def create
    schedule = Schedule.find params[:schedule_id]
    session = schedule.sessions.build params.permit(:title)
    if session.save
      render json: session, status: :ok, root: false
    else
      body = { errors: session.errors }
      render json: body, status: :bad_request
    end
  end
end
