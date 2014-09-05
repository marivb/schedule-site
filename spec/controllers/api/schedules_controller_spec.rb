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

    shared_examples 'an update' do
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

    context 'valid addition' do
      before :each do
        @attributes = { id: @schedule.id, additions: [ { listOfAdditions: true } ] }
        post :update, @attributes
      end

      it 'processes additions with schedule editor' do
        expect(@editor_double).to have_received(:process_additions).with [{list_of_additions: true}]
      end

      it_behaves_like 'an update'
    end

    context 'valid deletion' do
      before :each do
        @attributes = { id: @schedule.id, deletions: [ { listOfDeletions: true } ] }
        post :update, @attributes
      end

      it 'processes deletions with schedule editor' do
        expect(@editor_double).to have_received(:process_deletions).with [{list_of_deletions: true}]
      end

      it_behaves_like 'an update'
    end

    context 'valid with both' do
      before :each do
        @attributes = { id: @schedule.id, additions: [ { listOfAdditions: true } ],
                        deletions: [ { listOfDeletions: true } ] }
        post :update, @attributes
      end

      it 'processes deletions before additions' do
        expect(@editor_double).to have_received(:process_deletions).ordered
        expect(@editor_double).to have_received(:process_additions).ordered
      end

      it_behaves_like 'an update'
    end
  end
end
