class SessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :duration, :timeSlotSpan

  def id
    object.id.to_s
  end

  def timeSlotSpan
    object.time_slot_span
  end
end
