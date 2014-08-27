require 'rails_helper'

describe 'Sessions API', type: :request do
  describe 'POST /api/schedules/:schedule_id/sessions' do
    context 'response for valid session' do
      before :each do
        schedule = FactoryGirl.create :schedule
        session_attributes = FactoryGirl.attributes_for :session
        post "/api/schedules/#{schedule.id}/sessions", session_attributes
      end

      it 'has 200 status code' do
        expect(response).to be_success
      end

      it 'contains the session id' do
        expect(json['id']).to_not be_nil
      end
    end
  end
end
