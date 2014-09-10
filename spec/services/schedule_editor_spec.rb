require 'rails_helper'

describe ScheduleEditor do
  describe 'processing' do
    before :each do
      @schedule = FactoryGirl.build :schedule, slot_interval: 15
      session1 = FactoryGirl.build :session, schedule: @schedule, duration: 15
      session2 = FactoryGirl.build :session, schedule: @schedule, duration: 15
      allow(Session).to receive(:find).with(session1.id).and_return(session1)
      allow(Session).to receive(:find).with(session2.id).and_return(session2)

      time1 = @schedule.times[0]
      slot1 = time1.slots[0]
      @addition_data = { time_id: time1.id, slot_id: slot1.id, session_id: session1.id }

      time2 = @schedule.times[1]
      slot2 = time2.slots[0]
      @schedule.add_session slot2, session2
      @deletion_data = { time_id: time2.id, slot_id: slot2.id }

      @editor = ScheduleEditor.new @schedule
    end

    describe 'process_addition' do
      before :each do
        @editor.process_addition(@addition_data)
      end

      it 'adds session to schedule' do
        expect(@schedule.times[0].slots[0]).to be_session
      end
    end

    describe 'process_deletion' do
      before :each do
        @editor.process_deletion(@deletion_data)
      end

      it 'removes session from schedule' do
        expect(@schedule.times[1].slots[0]).to be_blank
      end
    end

    describe 'process' do
      before :each do
        changes = [
          {type: 'sessionAdd', data: @addition_data},
          {type: 'sessionRemove', data: @deletion_data }
        ]
        @editor.process(changes)
      end

      it 'processes addition' do
        expect(@schedule.times[0].slots[0]).to be_session
      end

      it 'processes deletion' do
        expect(@schedule.times[1].slots[0]).to be_blank
      end
    end
  end

  describe 'save' do
    context 'valid change' do
      before :each do
        @schedule = FactoryGirl.build :schedule, slot_interval: 15
        @editor = ScheduleEditor.new @schedule
      end

      it 'returns true' do
        expect(@editor.save).to eq(true)
      end

      it 'persists schedule' do
        @editor.save
        expect(@schedule).to be_persisted
      end
    end

    context 'invalid change' do
      before :each do
        @schedule = FactoryGirl.build :schedule, slot_interval: 15
        @schedule.times[0].slots[0].type = 'invalid'
        @editor = ScheduleEditor.new @schedule
      end

      it 'returns false' do
        expect(@editor.save).to eq(false)
      end

      it 'does not persist schedule' do
        @editor.save
        expect(@schedule).to_not be_persisted
      end

      it 'populates schedule errors' do
        @editor.save
        expect(@schedule.errors).to_not be_empty
      end
    end
  end
end
