FactoryGirl.define do
  factory :time, class: TimeRow do
    start_delta 9.hours
    slots []
  end
end
