module = angular.module('organizer.factories', [])

module.factory 'Schedule', [
  '$resource',
  ($resource) ->
    $resource('/api/schedules/:id')
]
