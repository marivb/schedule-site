FactoryGirl.define do
  factory :schedule do
    name           'Test Conference'
    start_time     9.hours
    end_time       10.hours
    slot_interval  15

    ignore do
      room_count   1
    end

    initialize_with { Schedule.build_empty(attributes) }

    after(:build) do |object, evaluator|
      evaluator.room_count.times do |i|
        object.rooms.build name: "Room #{i}"
        object.add_slot_column
      end
    end

    after(:create) do |object|
      object.rooms.each do |room|
        room.save!
      end
    end
  end
end
