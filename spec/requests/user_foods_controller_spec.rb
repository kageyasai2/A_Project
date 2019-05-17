require 'spec_helper'

describe UserFoodsController, type: :request do
  describe 'GET to /user_foods/register' do
    it 'returns 200 status' do
      get '/user_foods/register'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST to /user_foods/register' do
    before(:all) do
      # テストするためにUserを全て削除する
      User.destroy_all

      @user = User.create(
        name: 'NAKKA',
        email: 'nakka@example.com',
        password: 'password',
        password_confirmation: 'pasword',
      )
    end

    it 'redirects to index page, when successful' do
      post '/user_foods/register', {
        items: [
          { food_name: 'ばなな', },
        ]
      }, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 302
      #expect(last_response.body).to include "Hello"
    end

    it 'returns user_foods register page again, when failed post request' do
      post '/user_foods/register', {
        items: [
          { food_name: '', },
        ]
      }, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 200
      expect(last_response.body).to include ""
    end
  end
end




