class Room
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :order, type: Integer

  belongs_to :schedule
end
