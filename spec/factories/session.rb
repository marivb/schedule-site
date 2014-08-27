FactoryGirl.define do
  factory :session do
    title 'Sample Session'
    schedule_id { FactoryGirl.create(:schedule).id }
  end
end
