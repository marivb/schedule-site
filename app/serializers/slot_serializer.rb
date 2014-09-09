class SlotSerializer < ActiveModel::Serializer
  attributes :id, :type, :sessionId

  def id
    object.id.to_s
  end

  def sessionId
    object.session_id.to_s if object.session?
  end
end
