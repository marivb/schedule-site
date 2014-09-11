module = angular.module('organizer.scheduler', [])

module.service 'Scheduler', [
  '$resource', 'scheduleId',
  ($resource, scheduleId) ->
    Schedule = $resource('/api/schedules/:id', {}, update: {method: 'PATCH', params: {id: '@id'} })
    schedule = undefined

    doChange = (type, data, success) ->
      schedule.change = { type: type, data: data }
      schedule.$update success

    @load = (callback) ->
      Schedule.get id: scheduleId, (data) ->
        schedule = data
        callback(schedule)

    @addSession = (time, slot, session) ->
      data = { timeId: time.id, slotId: slot.id, sessionId: session.id }
      doChange 'sessionAdd', data, ->
        session.placed = true

    @clearSlot = (time, slot, session) ->
      data = { timeId: time.id, slotId: slot.id }
      doChange 'sessionRemove', data, ->
        session.placed = false

    @addRoom = ->
      doChange 'roomAdd', { name: 'Room' }

    return
]
