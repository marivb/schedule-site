#= require organizer_app
#= require angular-mocks/angular-mocks

beforeEach ->
  jasmine.addMatchers
    toBeAngularEqual: ->
      compare: (actual, expected) ->
        result = {}
        result.pass = angular.equals(actual, expected)
        actual_json = angular.toJson actual
        expected_json = angular.toJson expected
        if result.pass
          result.message = "Expected #{actual_json} not to be angular.equals to #{expected_json}"
        else
          result.message = "Expected #{actual_json} to be angular.equals to #{expected_json}"
        result

beforeEach ->
  @scheduleId = 'sc1'
  module('organizer.main',
    ($provide) =>
      $provide.value('scheduleId', @scheduleId)
      return
  )
  inject ($httpBackend, $injector) ->
    @http = $httpBackend
    @injector = $injector

afterEach ->
  @http.resetExpectations()
  @http.verifyNoOutstandingExpectation()
