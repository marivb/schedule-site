#= require spec_helper

describe 'Sessions', ->
  beforeEach ->
    @Session = @injector.get 'Session'

  describe 'on construction', ->
    beforeEach ->
      @session = new @Session(scheduleId: @scheduleId, id: 'ss1', title: 'Title', duration: 45)

      @Sessions = @injector.get 'Sessions'

      @http.whenGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [@session])
      @http.flush()

    it 'should load sessions from back-end', ->
      expect(@Sessions.all.length).toEqual(1)

    it 'should put sessions in a list', ->
      expect(@Sessions.all[0]).toBeAngularEqual(@session)

  describe 'after constructed', ->
    beforeEach ->
      @Sessions = @injector.get 'Sessions'

      @http.whenGET("/api/schedules/#{@scheduleId}/sessions").respond(200, [])
      @http.flush()

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
        expect(@Sessions.all.length).toEqual(1)
        expect(@Sessions.all[0]).toBeAngularEqual(@newSession)
