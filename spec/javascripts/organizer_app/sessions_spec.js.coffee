#= require spec_helper

describe 'Sessions', ->
  beforeEach ->
    @Sessions = @injector.get 'Sessions'

  describe 'load', ->
    beforeEach ->
      Session = @injector.get 'Session'
      @session = new Session(scheduleId: @scheduleId, id: 'ss1', title: 'Title', duration: 45)

      @data = undefined
      @Sessions.load (data) => @data = data

      @http.whenGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [@session])
      @http.flush()

    it 'should load sessions from back-end', ->
      expect(@data).toBeDefined()

    it 'should map sessions to their id', ->
      expect(@data[@session.id]).toBeAngularEqual(@session)
