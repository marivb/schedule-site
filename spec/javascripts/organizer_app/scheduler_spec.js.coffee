#= require spec_helper

describe 'Scheduler', ->
  beforeEach ->
    @Scheduler = @injector.get 'Scheduler'

  describe 'load', ->
    beforeEach ->
      @schedule = { id: @scheduleId, name: 'Conf', \
                    times: [ { id: 1, start: "09:00" }, { id: 2, start: "09:10" } ] }
      @http.expectGET("/api/schedules/#{@scheduleId}").respond(200, @schedule)
      @Scheduler.load (data) => @data = data
      @http.flush()

    it 'should load schedule from back-end', ->
      expect(@data).toBeDefined()

    it 'should initialize times with empty sessions', ->
      expect(@data.times[0].session).toBeAngularEqual({blank: true})
      expect(@data.times[1].session).toBeAngularEqual({blank: true})
