require 'spec_helper'

describe User do
  it 'is valid' do
    @user = User.create(
      name: 'NAKKA',
      email: 'nakka@example.com',
      password: 'password',
      password_confirmation: 'password'
    )

    expect(@user).to be_valid
  end
end

