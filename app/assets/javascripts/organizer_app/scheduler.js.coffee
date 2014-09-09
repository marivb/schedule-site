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

    @add = (time, slot, session) ->
      addition = { timeId: time.id, slotId: slot.id, sessionId: session.id }
      schedule.additions = [addition]
      schedule.$update (->), -> delete schedule.additions

    @clear = (time, slot) ->
      deletion = { timeId: time.id, slotId: slot.id }
      schedule.deletions = [deletion]
      schedule.$update()

    return
]
