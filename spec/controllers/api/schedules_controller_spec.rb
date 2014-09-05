require 'rails_helper'
require 'schedule_editor'

describe Api::SchedulesController, type: :controller do
  describe 'POST update' do
    context 'valid editions' do
      before :each do
        @schedule = FactoryGirl.build :schedule
        allow(Schedule).to receive(:find).with(@schedule.id).and_return(@schedule)

        @editor_double = instance_double('ScheduleEditor').as_null_object
        allow(ScheduleEditor).to receive(:new).with(@schedule).and_return(@editor_double)

        @attributes = { id: @schedule.id, additions: 'list_of_additions',
                        deletions: 'list_of_deletions' }
        post :update, @attributes
      end

      it 'processes additions with schedule editor' do
        expect(@editor_double).to have_received(:process_additions).with('list_of_additions')
      end

      it 'processes deletions with schedule editor' do
        expect(@editor_double).to have_received(:process_deletions).with('list_of_deletions')
      end

      it 'saves schedule' do
        expect(@schedule).to be_persisted
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders schedule as json' do
        expect(json['id']).to eq(@schedule.id.to_s)
      end
    end
  end
end
