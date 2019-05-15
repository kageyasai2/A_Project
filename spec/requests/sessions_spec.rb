require 'spec_helper'

describe 'Sessions controller', type: :request do
  describe 'GET to /auth/logout' do
    it 'returns 302 status' do
      get '/auth/logout'
      expect(last_response.status).to eq 302
    end
  end
end


