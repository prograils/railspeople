require 'spec_helper'

describe User do
  it "should have valid factory" do
    FactoryGirl.build(:user).should be_valid
  end
  describe "validatable attributes" do
    it "should not be valid if country is nil" do
      FactoryGirl.build(:user, :country => nil).should_not be_valid
    end
    it "should not be valid if email is nil" do
      FactoryGirl.build(:user, :email => nil).should_not be_valid
    end
    it "should not be valid if password is nil" do
      FactoryGirl.build(:user, :password => nil).should_not be_valid
    end
    it "should not be valid if password is nil" do
      FactoryGirl.build(:user, :username => nil).should_not be_valid
    end
    it "should not be valid if password is nil" do
      FactoryGirl.build(:user, :first_name => nil).should_not be_valid
    end
    it "should not be valid if password is nil" do
      FactoryGirl.build(:user, :last_name => nil).should_not be_valid
    end
    it "should not be valid if password is nil" do
      FactoryGirl.build(:user, :latitude => nil).should_not be_valid
    end
    it "should not be valid if password is nil" do
      FactoryGirl.build(:user, :longitude => nil).should_not be_valid
    end
  end
  it 'should to_gmaps4rails return expected json' do
    @user = FactoryGirl.create(:user, :latitude => '1.2345', :longitude => '6.7890')
    @json = User.all.to_gmaps4rails
    expected = %([{"lat":1.2345,"lng":6.7890}])
    @json.should be_json_eql(expected)
  end
end

