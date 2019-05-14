require 'spec_helper'

describe User do
  before do
    @user = User.new(
      name: 'NAKKA',
      email: 'nakka@example.com',
      password: 'password',
      password_confirmation: 'password'
    )

    # テストするために同じemailのUserを全て削除する
    User.where(email: @user.email).destroy_all
  end

  it 'is valid' do
    expect(@user).to be_valid
  end

  it 'is invalid email' do
    @user.email = 'example.com'
    expect(@user).to_not be_valid
  end
end

