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

    describe 'addSession', ->
      beforeEach ->
        @time = { id: 1 }
        @slot = { id: 11 }
        @session = { id: 500, placed: false }
        @patchData = { id: @scheduleId, change: { type: 'sessionAdd', \
              data: {timeId: @time.id, slotId: @slot.id, sessionId: @session.id} } }

      it 'calls back-end to add session', ->
        @http.expectPATCH("/api/schedules/#{@scheduleId}", @patchData)
             .respond(200, { id: @scheduleId, done: true })
        @Scheduler.addSession @time, @slot, @session
        @http.flush()
        expect(@schedule).toBeAngularEqual({ id: @scheduleId, done: true })

      describe 'when success', ->
        it 'sets session as placed', ->
          @http.whenPATCH("/api/schedules/#{@scheduleId}", @patchData).respond(200)
          @Scheduler.addSession @time, @slot, @session
          @http.flush()
          expect(@session.placed).toBeTruthy()

      describe 'when failed', ->
        it 'does not set session as placed', ->
          @http.whenPATCH("/api/schedules/#{@scheduleId}", @patchData).respond(400)
          @Scheduler.addSession @time, @slot, @session
          @http.flush()
          expect(@session.placed).toBeFalsy()

    describe 'clearSlot', ->
      beforeEach ->
        @time = { id: 1 }
        @slot = { id: 11 }
        @session = { id: 500, placed: true }
        @patchData = { id: @scheduleId, change: { type: 'sessionRemove', \
          data: {timeId: @time.id, slotId: @slot.id } } }

      it 'calls back-end to clear slot', ->
        @http.expectPATCH("/api/schedules/#{@scheduleId}", @patchData)
             .respond(200, { id: @scheduleId, done: true })

        @Scheduler.clearSlot @time, @slot, @session
        @http.flush()
        expect(@schedule).toBeAngularEqual({ id: @scheduleId, done: true })

      describe 'when success', ->
        it 'sets session as not placed', ->
          @http.whenPATCH("/api/schedules/#{@scheduleId}", @patchData).respond(200)
          @Scheduler.clearSlot @time, @slot, @session
          @http.flush()
          expect(@session.placed).toBeFalsy()

      describe 'when failed', ->
        it 'leaves session as placed', ->
          @http.whenPATCH("/api/schedules/#{@scheduleId}", @patchData).respond(400)
          @Scheduler.clearSlot @time, @slot, @session
          @http.flush()
          expect(@session.placed).toBeTruthy()
