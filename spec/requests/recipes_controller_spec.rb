require 'spec_helper'
require 'pp'
require 'nokogiri'

describe RecipesController, type: :request do
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

  describe 'GET to /recipes/' do
    it 'returns 200 status' do
      get '/recipes'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST to /recipes' do
    it 'redirect to /recipes, with not loggedin error' do
      post '/recipes'
      expect(last_response.status).to eq 302
      follow_redirect!
      expect(last_response.body).to include 'ログインしているユーザのみ使用可能'
    end

    it 'redirect to /recipes, with nothing user_food error' do
      post '/recipes', {}, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 302
      follow_redirect!
      expect(last_response.body).to include '冷蔵庫に食材がありません'
    end

    it 'returns 200 status' do
      UserFood.create(user_id: @user.id, name: 'じゃがいも')

      allow(RecipesController).to receive(:fetch_html_from).and_return(return_doc_mock(file_name: 'recipe_list.html'))
      post '/recipes', {}, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 200
      # HACK: 遷移先のページが正しいか間接的にテストしている
      expect(last_response.body).to include 'じゃがいも'
    end

    it 'returns 200 status, with genre' do
      UserFood.create(user_id: @user.id, name: 'じゃがいも')

      allow(RecipesController).to receive(:fetch_html_from).and_return(return_doc_mock(file_name: 'recipe_list.html'))
      post '/recipes', {
        genre: '和食',
      }, 'rack.session' => { user_id: @user.id }
      expect(last_response.status).to eq 200
    end
  end

  describe 'GET to /recipes/show' do
    it 'returns 200 status' do
      allow(RecipesController).to receive(:fetch_html_from).and_return(return_doc_mock(file_name: 'recipe_detail.html'))
      get '/recipes/show?recipe_path=/recipe/5406617'
      expect(last_response.status).to eq 200
    end

    it 'redirects to genre select page' do
      get '/recipes/show'
      expect(last_response.status).to eq 302
      follow_redirect!
      expect(last_response.body).to include 'レシピを探す'
    end
  end

  private

  def return_doc_mock(file_name: 'tmp.html')
    File.open("spec/mock_files/#{file_name}", 'r') do |file|
      Nokogiri::HTML.parse(file.read, nil, 'utf-8')
    end
  end
end
