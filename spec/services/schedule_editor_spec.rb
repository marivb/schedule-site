require 'rails_helper'

describe ScheduleEditor do
  before :each do
    @schedule = FactoryGirl.build :schedule, slot_interval: 15
    @session1 = FactoryGirl.build :session, schedule: @schedule, duration: 15
    @session2 = FactoryGirl.build :session, schedule: @schedule, duration: 15
    allow(Session).to receive(:find).with(@session1.id).and_return(@session1)
    allow(Session).to receive(:find).with(@session2.id).and_return(@session2)

    @time1 = @schedule.times[0]
    @slot1 = @time1.slots[0]
    @time2 = @schedule.times[1]
    @slot2 = @time2.slots[0]

    @editor = ScheduleEditor.new @schedule
  end

  describe 'process_additions' do
    before :each do
      additions = [ { time_id: @time1.id, slot_id: @slot1.id, session_id: @session1.id },
                    { time_id: @time2.id, slot_id: @slot2.id, session_id: @session2.id }]
      @editor.process_additions(additions)
    end

    it 'processes first addition' do
      expect(@schedule.times[0].slots[0]).to be_session
    end

    it 'processes other additions' do
      expect(@schedule.times[1].slots[0]).to be_session
    end
  end

  describe 'process_deletions' do
    before :each do
      @schedule.add_session @slot1, @session1
      @schedule.add_session @slot2, @session2

      deletions = [ { time_id: @time1.id, slot_id: @slot1.id },
                    { time_id: @time2.id, slot_id: @slot2.id }]
      @editor.process_deletions(deletions)
    end

    it 'processes first deletion' do
      expect(@schedule.times[0].slots[0]).to be_blank
    end

    it 'processes other deletions' do
      expect(@schedule.times[1].slots[0]).to be_blank
    end
  end
end
