require 'rails_helper'

describe 'Rooms API', type: :request do
  describe 'GET /api/schedules/:schedule_id/rooms' do
    before :each do
      @schedule = FactoryGirl.create :schedule, room_count: 2
      get "/api/schedules/#{@schedule.id}/rooms"
    end

    it 'has success status code' do
      expect(response).to be_success
    end

    it 'contains list of rooms' do
      expect(response_json[0]['name']).to eq(@schedule.rooms[0].name)
      expect(response_json[1]['name']).to eq(@schedule.rooms[1].name)
    end
  end
end
