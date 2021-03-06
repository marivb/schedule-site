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
        expect(response_json['name']).to eq(@schedule.name)
      end

      it 'contains the schedule times' do
        expect(response_json['times']).to be_a(Array)
      end
    end
  end

  describe 'PATCH /api/schedules/:id' do
    context 'adding session'do
      before :each do
        schedule = FactoryGirl.create :schedule, slot_interval: 15
        session = FactoryGirl.create :session, schedule: schedule, duration: 15

        attributes = {
          change: {
            type: 'sessionAdd',
            data: {
              timeId: schedule.times[0].id.to_s,
              slotId: schedule.times[0].slots[0].id.to_s,
              sessionId: session.id.to_s
            }
          }
        }
        patch "/api/schedules/#{schedule.id}", attributes
      end

      it 'adds session to first slot' do
        schedule = Schedule.first
        expect(schedule.times[0].slots[0]).to be_session
      end
    end

    context 'removing session'do
      before :each do
        schedule = FactoryGirl.create :schedule, slot_interval: 15
        session = FactoryGirl.create :session, schedule: schedule, duration: 15

        schedule.add_session schedule.times[0].slots[0], session
        schedule.save!

        attributes = {
          change: {
            type: 'sessionRemove',
            data: {
              timeId: schedule.times[0].id.to_s,
              slotId: schedule.times[0].slots[0].id.to_s
            }
          }
        }
        patch "/api/schedules/#{schedule.id}", attributes
      end

      it 'clears session from first slot' do
        schedule = Schedule.first
        expect(schedule.times[0].slots[0]).to be_blank
      end
    end
  end
end
