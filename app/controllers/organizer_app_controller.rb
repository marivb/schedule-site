class OrganizerAppController < ApplicationController
  def schedule
    @schedule = Schedule.find params[:id]
  end
end
