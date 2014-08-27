require 'rails_helper'

describe Api::SessionsController, type: :controller do
  describe 'POST create' do
    context 'valid session' do
      before :each do
        @attributes = FactoryGirl.attributes_for :session
        @schedule_id = @attributes[:schedule_id]

        post :create, @attributes
      end

      it 'creates a session' do
        expect(Session.where(schedule_id: @schedule_id).count).to eq(1)
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns session json' do
        session = Session.where(schedule_id: @schedule_id).first
        expect(json['id']).to eq(session.id.to_s)
      end
    end

    context 'invalid session' do
      before :each do
        @attributes = FactoryGirl.attributes_for :session, title: ''
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
        expect(json['errors']).to be_a(Hash)
      end
    end
  end
end
