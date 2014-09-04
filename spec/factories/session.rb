FactoryGirl.define do
  factory :session do
    id { BSON::ObjectId.new }
    title 'Sample Session'
    duration 45
    schedule_id { BSON::ObjectId.new }
  end
end
