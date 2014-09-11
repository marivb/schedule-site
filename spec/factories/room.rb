FactoryGirl.define do
  factory :room do
    id { BSON::ObjectId.new }
    name 'Room'
    schedule
  end
end
