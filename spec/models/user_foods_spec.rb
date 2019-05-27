require 'spec_helper'

describe UserFood, type: :model do
  let(:user_food) do
    user = User.create(
      name: 'NAKKA',
      email: 'nakka@example.com',
      password: 'password',
      password_confirmation: 'password',
    )

    UserFood.new(
      name: 'トマト',
      limit_date: '2019-05-08',
      user_id: user.id,
      gram: 100,
    )
  end

  it 'is valid' do
    expect(user_food).to be_valid
  end

  it 'only the food name is entered' do
    user_food.limit_date = nil
    user_food.gram = nil
    expect(user_food).to be_valid
  end

  it 'Food name has not been entered' do
    user_food.name = nil
    expect(user_food).not_to be_valid
  end
end
