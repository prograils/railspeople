require 'spec_helper'

describe User do
  it "should have valid factory" do
    FactoryGirl.build(:user).should be_valid
  end

  describe "validatable attributes" do
    it "should not be valid if country is nil" do
      FactoryGirl.build(:user, :country_id => nil).should_not be_valid
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

    describe "validatable url attributes" do
      it "should not be valid if stackoverflow url is invalid" do
        @user = FactoryGirl.build(:user)
        @user.stackoverflow = "http://www"
        @user.should have(1).error_on(:stackoverflow)
        @user.stackoverflow = "http://www.6768"
        @user.should have(2).error_on(:stackoverflow)
        @user.stackoverflow = "httpd://www.onet.pl"
        @user.should have(2).error_on(:stackoverflow)
      end
      it "should be valid if stackoverflow url is valid" do
        @user = FactoryGirl.build(:user)
        @user.stackoverflow = "www.onet.pl"
        @user.should have(0).error_on(:stackoverflow)
        @user.stackoverflow = "http://onet.pl"
        @user.should have(0).error_on(:stackoverflow)
        @user.stackoverflow = "http://www.onet.pl"
        @user.should have(0).error_on(:stackoverflow)
        @user.stackoverflow = "https://poczta.onet.pl/"
        @user.should have(0).error_on(:stackoverflow)
      end
    end
  end

  it "should add new user with some coordinates values" do
    @user = FactoryGirl.create(:user, :latitude => "1.2", :longitude => "1.2")
    @user = FactoryGirl.create(:user, :username => "walter22", :latitude => "21.2", :longitude => "41.2")

    User.count.should == 2
  end

  it 'should to_gmaps4rails return expected json' do
    @user = FactoryGirl.create(:user, :latitude => '1.2345', :longitude => '6.7890')
    @json = User.all.to_gmaps4rails
    expected = %([{"lat":1.2345,"lng":6.7890}])
    @json.should be_json_eql(expected)
  end

  it 'should geocode return valid address' do
    @user = FactoryGirl.create(:user)
    @user.address.should_not be_empty
    @user.address.should include("60-575")
    @user.address.should include("Poland")
  end
end

