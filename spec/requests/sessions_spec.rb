require 'spec_helper'

describe SessionsController, type: :request do
  describe 'GET to /auth/logout' do
    it 'returns 302 status' do
      get '/auth/logout'
      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{TEST_DOMAIN}/"
    end
  end
end


