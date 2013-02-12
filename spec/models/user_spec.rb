require 'spec_helper'

describe User do

  before(:all) do
    User.delete_all
  end

  after(:all) do
    User.delete_all
  end

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
    it "should not be valid if username is nil" do
      FactoryGirl.build(:user, :username => nil).should_not be_valid
    end
    it "should not be valid if first name is nil" do
      FactoryGirl.build(:user, :first_name => nil).should_not be_valid
    end
    it "should not be valid if last name is nil" do
      FactoryGirl.build(:user, :last_name => nil).should_not be_valid
    end
    it "should not be valid if looking for work is nil" do
      FactoryGirl.build(:user, :looking_for_work => nil).should_not be_valid
    end
    it "should not be valid if email privacy is nil" do
      FactoryGirl.build(:user, :email_privacy => nil).should_not be_valid
    end

    it "should not be valid if username is not unique" do
      FactoryGirl.create(:user, :username => "Abcde")
      FactoryGirl.build(:user, :username => "Abcde").should_not be_valid
    end

    #TO DO -> CHANGE
    # describe "validatable url attributes" do
    #   it "should not be valid if stackoverflow url is invalid" do
    #     @user = FactoryGirl.build(:user)
    #     @user.stackoverflow = "http://www"
    #     @user.should have(1).error_on(:stackoverflow)
    #     @user.stackoverflow = "http://www.6768"
    #     @user.should have(2).error_on(:stackoverflow)
    #     @user.stackoverflow = "httpd://www.onet.pl"
    #     @user.should have(2).error_on(:stackoverflow)
    #   end
    #   it "should be valid if stackoverflow url is valid" do
    #     @user = FactoryGirl.build(:user)
    #     @user.stackoverflow = "www.onet.pl"
    #     @user.should have(0).error_on(:stackoverflow)
    #     @user.stackoverflow = "http://onet.pl"
    #     @user.should have(0).error_on(:stackoverflow)
    #     @user.stackoverflow = "http://www.onet.pl"
    #     @user.should have(0).error_on(:stackoverflow)
    #     @user.stackoverflow = "https://poczta.onet.pl/"
    #     @user.should have(0).error_on(:stackoverflow)
    #   end
    # end
  end

  it "should add new user with some coordinates values" do
    @user = FactoryGirl.create(:user, :latitude => "1.2", :longitude => "1.2")
    @user = FactoryGirl.create(:user, :username => "walter22", :latitude => "21.2", :longitude => "41.2")

    User.count.should == 2
  end

  it 'should to_gmaps4rails return expected json' do
    @user = FactoryGirl.create(:user, :first_name => "ted", :last_name => "tylor",:latitude => '1.2345', :longitude => '6.7890')
    @json = User.last.to_gmaps4rails
    expected = %([{"description":"<a href= /users/#{@user.id}-#{@user.username}> #{@user.to_s}</a>","lat":1.2345,"lng":6.7890}])

    @json.should be_json_eql(expected)
  end

  it 'should geocode return valid address' do
    @user = FactoryGirl.create(:user)
    @user.address.should_not be_empty
    @user.address.should include("60-575")
    @user.address.should include("Poland")
  end

  describe "user should" do
    before do
      @user = FactoryGirl.create(:user)
    end
    it "accept nested socials" do
      expect {
        @user.update_attributes('socials_attributes' => {'0' => {'url'=>'http://rubyonrails.org/'}})
      }.to change { Social.count }.by(1)
    end
    it "accept nested blogs" do
      expect {
        @user.update_attributes(:blogs_attributes => {'0' => {'url'=>'http://rubyonrails.org/', "_destroy"=>"false"}})
      }.to change { Blog.count }.by(1)
    end
  end
end

