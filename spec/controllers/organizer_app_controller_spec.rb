require 'rails_helper'

describe OrganizerAppController, type: :controller do

  describe 'GET home' do
    it 'returns http success' do
      get :home
      expect(response).to be_success
    end

    it 'renders home template' do
      get :home
      expect(response).to render_template(:home)
    end
  end

end
