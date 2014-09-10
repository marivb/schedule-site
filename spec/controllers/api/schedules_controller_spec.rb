require 'rails_helper'
require 'schedule_editor'

describe Api::SchedulesController, type: :controller do
  describe 'POST update' do
    before :each do
      @schedule = FactoryGirl.build :schedule
      allow(Schedule).to receive(:find).with(@schedule.id).and_return(@schedule)

      @editor_double = instance_double('ScheduleEditor').as_null_object
      allow(ScheduleEditor).to receive(:new).with(@schedule).and_return(@editor_double)
    end

    context 'valid changes' do
      before :each do
        attributes = { id: @schedule.id, changes: [ { listOfChanges: 'myChanges' } ] }
        post :update, attributes
      end

      it 'processes changes' do
        expect(@editor_double).to have_received(:process)
      end

      it 'converts keys in changes' do
        expect(@editor_double).to have_received(:process).with [{list_of_changes: 'myChanges'}]
      end

      it 'saves schedule' do
        expect(@schedule).to be_persisted
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders schedule as json' do
        expect(response_json['id']).to eq(@schedule.id.to_s)
      end
    end

    context 'invalid changes' do
      before :each do
        attributes = { id: @schedule.id, changes: [] }
        allow(@editor_double).to receive(:process) do
          @schedule.times[0].slots[0].type = 'invalid'
        end

        post :update, attributes
      end

      it 'does not save schedule' do
        expect(@schedule).to_not be_persisted
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'renders errors as json' do
        expect(response_json['errors'].size).to eq(1)
      end
    end
  end
end
