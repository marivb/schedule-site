module = angular.module('organizer.scheduler', [])

module.service 'Scheduler', [
  'Schedule', 'scheduleId',
  (Schedule, scheduleId) ->
    @load = (callback) ->
      Schedule.get id: scheduleId, callback

    return
]
