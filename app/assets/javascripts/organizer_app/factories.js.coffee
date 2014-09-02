module = angular.module('organizer.factories', ['ngResource'])

module.factory 'Schedule', [
  '$resource',
  ($resource) ->
    $resource('/api/schedules/:id')
]

module.factory 'Session', [
  '$resource',
  ($resource) ->
    $resource('/api/schedules/:scheduleId/sessions/:sessionId',
        {scheduleId: '@scheduleId', sessionId: '@id'})
]
