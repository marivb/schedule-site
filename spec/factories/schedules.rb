FactoryGirl.define do
  factory :schedule do
    name           'Test Conference'
    start_time     9.hours
    end_time       10.hours
    slot_interval  15
  end
end