class TimeRowSerializer < ActiveModel::Serializer
  attributes :id, :start
  has_many :slots

  def id
    object.id.to_s
  end
end
