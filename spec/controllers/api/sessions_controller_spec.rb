require 'rails_helper'

describe Api::SessionsController, type: :controller do
  describe 'POST create' do
    context 'valid session' do
      before :each do
        schedule = FactoryGirl.build :schedule
        allow(Schedule).to receive(:find).and_return(schedule)
        @attributes = FactoryGirl.attributes_for :session, schedule_id: schedule.id

        post :create, @attributes

        @created_session = Session.first
      end

      it 'creates a session' do
        expect(@created_session).to_not be_nil
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns session json' do
        expect(response_json['id']).to eq(@created_session.id.to_s)
      end

      it 'saves title' do
        expect(@created_session.title).to eq(@attributes[:title])
      end

      it 'saves duration' do
        expect(@created_session.duration).to eq(@attributes[:duration])
      end

      it 'saves schedule_id' do
        expect(@created_session.schedule_id).to eq(@attributes[:schedule_id])
      end
    end

    context 'invalid session' do
      before :each do
        schedule = FactoryGirl.create :schedule
        @attributes = FactoryGirl.attributes_for :session, schedule_id: schedule.id, title: ''
        @schedule_id = @attributes[:schedule_id]

        post :create, @attributes
      end

      it 'does not create a session' do
        expect(Session.where(schedule_id: @schedule_id).count).to eq(0)
      end

      it 'returns bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        expect(response_json['errors']).to be_a(Hash)
      end
    end
  end
end
