require 'spec_helper'

describe Sessions do
  it 'is valid' do
    get '/auth/logout'
    expect(last_response.status).to eq 302
  end
end


