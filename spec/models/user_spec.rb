require 'spec_helper'

describe 'User model', type: :model do
  let(:user) do
    User.new(
      name: 'NAKKA',
      email: 'nakka@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  before do
    # テストするために同じemailのUserを全て削除する
    User.where(email: user.email).destroy_all
  end

  it 'is valid' do
    expect(user).to be_valid
  end

  it 'is invalid email' do
    user.email = 'example.com'
    expect(user).to_not be_valid
  end

  it 'is invalid with a password less than 4 characters' do
    user.password = 'pas'
    user.password_confirmation = 'pas'
    expect(user).to_not be_valid
  end
end

