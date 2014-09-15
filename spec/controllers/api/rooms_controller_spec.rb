require 'rails_helper'

describe Api::RoomsController, type: :controller do
  describe 'GET index' do
    before :each do
      schedule = FactoryGirl.build :schedule, room_count: 2
      allow(Room).to receive(:where).and_return(schedule.rooms)
      get :index, schedule_id: schedule.id
    end

    it 'returns ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns json with list of rooms' do
      expect(response_json.length).to eq(2)
    end
  end
end
