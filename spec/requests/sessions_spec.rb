require 'spec_helper'

describe SessionsController, type: :request do
  describe 'GET to /auth/logout' do
    it 'returns 302 status' do
      get '/auth/logout'
      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "#{TEST_DOMAIN}/"
    end
  end

  describe 'GET to /auth/login' do
    it 'returns 200 status' do
      get '/auth/login'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST to /auth/login' do
    let(:test_pass) { 'password' }

    before do
      # テストするためにUserを全て削除する
      User.destroy_all

      @user = User.create(
        name: 'NAKKA',
        email: 'nakka@example.com',
        password: test_pass,
        password_confirmation: test_pass
      )
    end

    it 'redirect to index, when successful' do
      post '/auth/login', { email: @user.email, password: test_pass }
      expect(last_response.status).to eq 302
    end

    it 'returns 200 status, when failed login post request' do
      post '/auth/login', { email: '', password: '' }
      expect(last_response.status).to eq 200
      expect(last_response.body).to include "ログイン"
    end
  end
end


