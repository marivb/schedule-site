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

    it 'loads schedule from back-end', ->
      expect(@data).toBeAngularEqual(@schedule)
