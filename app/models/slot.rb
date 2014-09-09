class Slot
  include Mongoid::Document
  TYPES = OpenStruct.new(BLANK: 'blank', CONT: 'cont', SESSION: 'session').freeze

  field :type
  field :session_id, type: BSON::ObjectId

  embedded_in :time, class_name: 'TimeRow'

  validates :type, presence: true, inclusion: { in: TYPES.to_h.values }
  validates :session_id, presence: { if: :session? },
                      absence: { unless: :session? }

  def blank?
    type == TYPES.BLANK
  end

  def cont?
    type == TYPES.CONT
  end

  def session?
    type == TYPES.SESSION
  end

  def session
    Session.find(session_id) if session?
  end

  def add_session session
    fill_with type: TYPES.SESSION, session_id: session.id
  end

  def continue
    fill_with type: TYPES.CONT
  end

  def invalidate
    write_attributes(type: 'invalid')
  end

  def clear
    write_attributes type: TYPES.BLANK, session_id: nil
  end

  private

  def fill_with(attributes)
    if blank?
      write_attributes(attributes)
    else
      invalidate
    end
  end
end
