module = angular.module('organizer.scheduler', [])

module.service 'Scheduler', [
  'Schedule', 'scheduleId',
  (Schedule, scheduleId) ->
    @load = (callback) ->
      Schedule.get id: scheduleId, (schedule) ->
        for time in schedule.times
          time.session = { blank: true }
        callback(schedule)

    return
]
