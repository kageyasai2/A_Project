require 'spec_helper'

describe IndexController, type: :request do
  after(:all) do
    UserFood.delete_all
  end

  describe 'GET to /' do
    it 'returns 200 status' do
      get '/'
      expect(last_response.status).to eq 200
    end
  end

  describe 'GET to /home' do
    before(:all) do
      # テストするためにUserを全て削除する
      User.destroy_all

      @user = User.create(
        name: 'NAKKA',
        email: 'nakka@example.com',
        password: 'password',
        password_confirmation: 'password',
      )
      UserFood.create(
        name: '豚肉',
        user_id: @user.id,
      )
    end

    it 'return own user_foods, when loggedin' do
      get '/home', {}, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 200
      expect(last_response.body).to include '豚肉'
    end

    it 'not return user_foods, when not loggein' do
      get '/home', {}, 'rack.session' => { user_id: nil }
      expect(last_response.status).to eq 200
      expect(last_response.body).not_to include '豚肉'
    end
  end
end
