module = angular.module('organizer.scheduler', [])

module.service 'Scheduler', [
  'Schedule', 'scheduleId',
  (Schedule, scheduleId) ->
    @load = (callback) ->
      Schedule.get id: scheduleId, callback

    @add = (slot, session) ->
      slot.type = 'session'
      slot.session = session

    @clear = (slot) ->
      slot.type = 'blank'
      delete slot.session

    return
]
