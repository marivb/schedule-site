require 'rails_helper'

describe 'Schedules API', type: :request do
  describe 'GET /api/schedules/:id' do
    context 'for existing schedule' do
      before :each do
        @schedule = FactoryGirl.create :schedule
        get "/api/schedules/#{@schedule.id}"
      end

      it 'has 200 status code' do
        expect(response).to be_success
      end

      it 'contains the schedule name' do
        expect(json['name']).to eq(@schedule.name)
      end

      it 'contains the schedule times' do
        expect(json['times']).to be_a(Array)
      end
    end
  end
end
