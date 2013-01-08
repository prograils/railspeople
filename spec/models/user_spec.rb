require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user, :latitude => '1.2345', :longitude => '6.7890')
  end

  it 'should to_gmaps4rails return expected json' do
    @json = User.all.to_gmaps4rails
    expected = %([{"lat":1.2345,"lng":6.7890}])

    @json.should be_json_eql(expected)
  end
end 
