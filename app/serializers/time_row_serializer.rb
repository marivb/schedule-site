class TimeRowSerializer < ActiveModel::Serializer
  attributes :start
  has_many :slots
end
