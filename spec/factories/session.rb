FactoryGirl.define do
  factory :session do
    title 'Sample Session'
    duration 45
    schedule_id { FactoryGirl.create(:schedule).id }
  end
end
