#= require spec_helper

describe 'Sessions', ->
  beforeEach ->
    @Sessions = @injector.get 'Sessions'
    @Session = @injector.get 'Session'

  describe 'load', ->
    beforeEach ->
      @session = new @Session(scheduleId: @scheduleId, id: 'ss1', title: 'Title', duration: 45)

      @data = undefined
      @Sessions.load (data) => @data = data

      @http.whenGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [@session])
      @http.flush()

    it 'should load sessions from back-end when first called', ->
      expect(@data).toBeDefined()

    it 'should map sessions to their id', ->
      expect(@data[@session.id]).toBeAngularEqual(@session)

    it 'should return loaded sessions after first call', ->
      cachedData = undefined
      @Sessions.load (data) -> cachedData = data
      expect(cachedData).toBeDefined()

  describe 'build', ->
    beforeEach ->
      @session = @Sessions.build()

    it 'should build a new session', ->
      expect(@session).toBeDefined()

    it 'should not set session.id', ->
      expect(@session.id).toBeUndefined()

    it 'should not set session.title', ->
      expect(@session.title).toBeUndefined()

    it 'should not set session.duration', ->
      expect(@session.duration).toBeUndefined()

    it 'should set session.scheduleId', ->
      expect(@session.scheduleId).toEqual(@scheduleId)

  describe 'create', ->
    beforeEach ->
      @newSession = new @Session id: '1', scheduleId: @scheduleId, title: 'Title', duration: 45
      @http.whenPOST("/api/schedules/#{@scheduleId}/sessions").respond(200, @newSession)

      @Sessions.create new @Session(scheduleId: @scheduleId)

      @http.flush()

    it 'should save the session', ->
      expect(@Sessions.all['1']).toBeAngularEqual(@newSession)
