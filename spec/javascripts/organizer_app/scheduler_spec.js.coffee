#= require spec_helper

describe 'Scheduler', ->
  beforeEach ->
    @Scheduler = @injector.get 'Scheduler'

  describe 'load', ->
    beforeEach ->
      @schedule = { id: @scheduleId, name: 'Conf', \
                    times: [ { id: 1, start: '09:00' }, { id: 2, start: '09:10' } ] }
      @http.expectGET("/api/schedules/#{@scheduleId}").respond(200, @schedule)
      @Scheduler.load (data) => @data = data
      @http.flush()

    it 'loads schedule from back-end', ->
      expect(@data).toBeAngularEqual(@schedule)

  describe 'modifying', ->
    beforeEach ->
      @http.whenGET("/api/schedules/#{@scheduleId}").respond(200, {id: @scheduleId})
      @Scheduler.load (data) => @schedule = data
      @http.flush()

    describe 'add', ->
      it 'calls back-end to add session', ->
        time = { id: 1 }
        slot = { id: 11 }
        session = { id: 500 }
        @http.expectPATCH("/api/schedules/#{@scheduleId}",
          { id: @scheduleId, additions: [{timeId: time.id, slotId: slot.id, sessionId: session.id}]}
        ).respond(200, { id: @scheduleId, done: true })

        @Scheduler.add time, slot, session
        @http.flush()
        expect(@schedule).toBeAngularEqual({ id: @scheduleId, done: true })

      it 'removes additions if failed', ->
        time = { id: 1 }
        slot = { id: 11 }
        session = { id: 500 }
        @http.expectPATCH("/api/schedules/#{@scheduleId}",
          { id: @scheduleId, additions: [{timeId: time.id, slotId: slot.id, sessionId: session.id}]}
        ).respond(400)

        @Scheduler.add time, slot, session
        @http.flush()
        expect(@schedule.additions).toBeUndefined()

    describe 'clear', ->
      it 'calls back-end to clear', ->
        time = { id: 1 }
        slot = { id: 11 }
        @http.expectPATCH("/api/schedules/#{@scheduleId}",
          { id: @scheduleId, deletions: [{timeId: time.id, slotId: slot.id }]}
        ).respond(200, { id: @scheduleId, done: true })

        @Scheduler.clear time, slot
        @http.flush()
        expect(@schedule).toBeAngularEqual({ id: @scheduleId, done: true })
