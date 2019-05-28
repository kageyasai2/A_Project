require 'spec_helper'

describe UserFoodsController, type: :request do
  before(:all) do
    # テストするためにUserを全て削除する
    User.destroy_all

    @user = User.create(
      name: 'NAKKA',
      email: 'nakka@example.com',
      password: 'password',
      password_confirmation: 'password',
    )
  end

  describe 'GET to /user_foods/food_upload' do
    it 'redirect to login page' do
      get '/user_foods/food_upload'
      expect(last_response.status).to eq 302
      follow_redirect!
      expect(last_response.body).to include 'ログインしているユーザのみ使用可能'
    end

    it 'returns 200 status' do
      get '/user_foods/food_upload', {}, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST to /user_foods/food_upload' do
    it 'returns 200 status' do
      post '/user_foods/food_upload'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST to /user_foods/register' do
    it 'redirects to index page, when successful' do
      post '/user_foods/register', {
        items: [
          { food_name: 'ばなな' },
        ],
      }, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 302
    end

    it 'returns user_foods register page again, when failed post request' do
      post '/user_foods/register', {
        items: [
          { food_name: '' },
        ],
      }, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 200
      expect(last_response.body).to include '食材登録画面'
    end
  end
end
