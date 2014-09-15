module = angular.module('organizer.rooms', [])

module.service 'Rooms', [
  '$resource', 'scheduleId',
  ($resource, scheduleId) ->
    Room = $resource('/api/schedules/:scheduleId/rooms')
    @load = (callback) ->
      Room.query scheduleId: scheduleId, (rooms) ->
        callback(rooms)
    return
]
