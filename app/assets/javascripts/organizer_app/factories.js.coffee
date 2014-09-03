module = angular.module('organizer.factories', ['ngResource'])

module.config [
  '$httpProvider',
  ($httpProvider) ->
    authToken = $('meta[name="csrf-token"]').attr('content')
    $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = authToken
]

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
