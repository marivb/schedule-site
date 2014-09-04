FactoryGirl.define do
  factory :blank_slot, class: Slot do
    type Slot::TYPES.BLANK
  end

  factory :cont_slot, class: Slot do
    type Slot::TYPES.CONT
  end

  factory :session_slot, class: Slot do
    type Slot::TYPES.SESSION
    session
  end
end
