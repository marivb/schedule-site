class Api::RoomsController < ApplicationController
  def index
    rooms = Room.where(schedule_id: params[:schedule_id])
    render json: rooms, root: false
  end
end
