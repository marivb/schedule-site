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

  describe 'add', ->
    it 'adds session to time slot', ->
      slot = { id: 10, type: 'blank' }
      session = { id: 20, title: 'Title' }
      @Scheduler.add slot, session
      expect(slot).toBeAngularEqual({ id: 10, type: 'session', session: session })

  describe 'clear', ->
    it 'clears session from slot', ->
      session = { id: 20, title: 'Title' }
      slot = { id: 10, type: 'session', session: session }
      @Scheduler.clear slot
      expect(slot).toBeAngularEqual({ id: 10, type: 'blank' })
