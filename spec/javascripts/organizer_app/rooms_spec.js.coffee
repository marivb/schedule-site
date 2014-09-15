#= require spec_helper

describe 'Rooms', ->
  beforeEach ->
    @Rooms = @injector.get 'Rooms'

  describe 'load', ->
    beforeEach ->
      @room = { id: 'r1', name: 'Test Room' }
      @http.expectGET("/api/schedules/#{@scheduleId}/rooms").respond(200, [@room])

      @Rooms.load (data) => @data = data
      @http.flush()

    it 'loads rooms from back-end', ->
      expect(@data.length).toEqual(1)
