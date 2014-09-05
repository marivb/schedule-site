#= require spec_helper

describe 'Sessions', ->
  beforeEach ->
    @Sessions = @injector.get 'Sessions'

  describe 'load', ->
    beforeEach ->
      @session = { scheduleId: @scheduleId, id: 'ss1', title: 'Title', duration: 45 }
      @http.expectGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [@session])

      @Sessions.load (data) => @data = data
      @http.flush()

    it 'loads sessions from back-end', ->
      expect(@data.length).toEqual(1)

    it 'puts sessions in a list', ->
      expect(@data[0]).toBeAngularEqual(@session)

  describe 'build', ->
    beforeEach ->
      @session = @Sessions.build()

    it 'builds a new session', ->
      expect(@session).toBeDefined()

    it 'does not set session.id', ->
      expect(@session.id).toBeUndefined()

    it 'does not set session.title', ->
      expect(@session.title).toBeUndefined()

    it 'does not set session.duration', ->
      expect(@session.duration).toBeUndefined()

    it 'sets session.scheduleId', ->
      expect(@session.scheduleId).toEqual(@scheduleId)

  describe 'create', ->
    beforeEach ->
      @http.whenGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [])
      @Sessions.load (data) => @data = data

      @newSession = { scheduleId: @scheduleId, id: '1', title: 'Title', duration: 45 }
      @http.expectPOST("/api/schedules/#{@scheduleId}/sessions").respond(200, @newSession)

      @Sessions.create @Sessions.build()

      @http.flush()

    it 'saves the session', ->
      expect(@data.length).toEqual(1)
      expect(@data[0]).toBeAngularEqual(@newSession)

  describe 'find', ->
    beforeEach ->
      @session1 = { scheduleId: @scheduleId, id: '1', title: 'Title 1', duration: 45 }
      @session2 = { scheduleId: @scheduleId, id: '2', title: 'Title 2', duration: 45 }
      @http.expectGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [@session1, @session2])

      @Sessions.load (data) => @data = data
      @http.flush()

    it 'finds session by id', ->
      expect(@Sessions.find('2')).toBeAngularEqual(@session2)

    it 'is undefined when session is not found', ->
      expect(@Sessions.find('3')).toBeUndefined()
