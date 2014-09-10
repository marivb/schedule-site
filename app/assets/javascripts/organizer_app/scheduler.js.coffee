module = angular.module('organizer.scheduler', [])

module.service 'Scheduler', [
  '$resource', 'scheduleId', '$log'
  ($resource, scheduleId, $log) ->
    Schedule = $resource('/api/schedules/:id', {}, update: {method: 'PATCH', params: {id: '@id'} })
    schedule = undefined

    @load = (callback) ->
      Schedule.get id: scheduleId, (data) ->
        schedule = data
        callback(schedule)

    @addSession = (time, slot, session) ->
      data = { timeId: time.id, slotId: slot.id, sessionId: session.id }
      schedule.change = { type: 'sessionAdd', data: data }
      schedule.$update()

    @clearSlot = (time, slot) ->
      data = { timeId: time.id, slotId: slot.id }
      schedule.change = { type: 'sessionRemove', data: data }
      schedule.$update()

    return
]
