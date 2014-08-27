class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title

  belongs_to :schedule

  validates_presence_of :title, :schedule_id
end
