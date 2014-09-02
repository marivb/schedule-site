require 'rails_helper'

describe OrganizerAppController, type: :controller do

  describe 'GET schedule' do
    before :each do
      @schedule = FactoryGirl.create :schedule
    end

    it 'returns http success' do
      get :schedule, id: @schedule.id
      expect(response).to be_success
    end

    it 'renders schedule template' do
      get :schedule, id: @schedule.id
      expect(response).to render_template(:schedule)
    end

    it 'assigns retrieved schedule' do
      get :schedule, id: @schedule.id
      expect(assigns(:schedule)).to eq(@schedule)
    end
  end

end
