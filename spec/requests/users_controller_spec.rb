require 'spec_helper'

describe UserController, type: :request do
  describe 'GET to /signup' do
    it 'returns 200 status' do
      get '/signup'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST to /signup' do
    let(:test_pass) { 'password' }
    let(:user) do
      User.new(
        name: 'NAKKA',
        email: 'nakka@example.com',
        password: test_pass,
        password_confirmation: test_pass,
      )
    end

    before do
      # テストするためにUserを全て削除する
      User.destroy_all
    end

    it 'returns login page, when successful' do
      post '/auth/login', {
        name: user.name,
        email: user.email,
        password: test_pass,
        password_confirmation: test_pass,
      }
      expect(last_response.status).to eq 200
      expect(last_response.body).to include "ログイン"
    end

    it 'returns signup page again, when failed post request' do
      post '/signup', {
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
      }
      expect(last_response.status).to eq 200
      expect(last_response.body).to include "送信する"
    end
  end
end



