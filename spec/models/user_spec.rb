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
  end

  context "validate depends on country_validation" do
    it "should set prop to true after initialize" do
      user = FactoryGirl.build(:user)
      user.country_validation.should be_true
    end
    it "should be valid on create if prop is set to false" do
      FactoryGirl.build(:user, :country => nil, country_validation: false).should be_valid
    end
    it "should not be valid on create if prop is set to true" do
      FactoryGirl.build(:user, :country => nil, country_validation: true).should_not be_valid
    end
    it "should not be valid on update if prop is default" do
      user = FactoryGirl.create(:user)
      user.country_id = nil
      user.should_not be_valid
    end
    it "should not be valid on update if prop is false" do
      # = not depends from prop on update action
      user = FactoryGirl.create(:user)
      user.country_validation = false
      user.country_id = nil
      user.should_not be_valid
    end
  end

  context "validate depends on first_name_validation" do
    it "should set prop to true after initialize" do
      user = FactoryGirl.build(:user)
      user.first_name_validation.should be_true
    end
    it "should be valid on create if prop is set to false" do
      FactoryGirl.build(:user, :first_name => nil, first_name_validation: false).should be_valid
    end
    it "should not be valid on create if prop is set to true" do
      FactoryGirl.build(:user, :first_name => nil, first_name_validation: true).should_not be_valid
    end
    it "should not be valid on update if prop is default" do
      user = FactoryGirl.create(:user)
      user.first_name = nil
      user.should_not be_valid
    end
    it "should not be valid on update if prop is false" do
      # = does not depend on prop of update action
      user = FactoryGirl.create(:user)
      user.first_name_validation = false
      user.first_name = nil
      user.should_not be_valid
    end
  end

  context "validate depends on last_name_validation" do
    it "should set prop to true after initialize" do
      user = FactoryGirl.build(:user)
      user.last_name_validation.should be_true
    end
    it "should be valid on create if prop is set to false" do
      FactoryGirl.build(:user, :last_name => nil, last_name_validation: false).should be_valid
    end
    it "should not be valid on create if prop is set to true" do
      FactoryGirl.build(:user, :last_name => nil, last_name_validation: true).should_not be_valid
    end
    it "should not be valid on update if prop is default" do
      user = FactoryGirl.create(:user)
      user.last_name = nil
      user.should_not be_valid
    end
    it "should not be valid on update if prop is false" do
      # = does not depend on prop of update action
      user = FactoryGirl.create(:user)
      user.last_name_validation = false
      user.last_name = nil
      user.should_not be_valid
    end
  end

  context "validate email depends on action type" do
    it "should be valid on create" do
      FactoryGirl.build(:user, :email => "12312@5h0u1d-change.it").should be_valid
    end
    it "should not be valid on update" do
      user = FactoryGirl.create(:user, :email => "12312@5h0u1d-change.it")
      user.username = "John" # Force update
      user.should_not be_valid
    end
  end

  context "no_email_filled? method" do #private method
    it "should return true if email comes from autogenerator" do
      user = FactoryGirl.create(:user, :email => "1231544542@5h0u1d-change.it")
      user.send(:no_email_filled?).should be_true
    end
    it "should return true if email is filled by user" do
      user = FactoryGirl.create(:user, :email => "some@email.com")
      user.send(:no_email_filled?).should be_false
    end
  end

  context "temporary_email method" do #private method
    it "should return autogenerated email" do
      user = FactoryGirl.create(:user)
      user.temporary_email.should include("@5h0u1d-change.it")
      user.temporary_email.length.should be > "@5h0u1d-change.it".length
    end
  end


  context "profile_url method" do
    it "should return facebook profile url" do
      user = FactoryGirl.create(:user)
      user.profile_url(:facebook).should include("http://www.facebook.com/")
    end
    it "should return twitter profile url" do
      user = FactoryGirl.create(:user)
      user.profile_url(:twitter).should include("https://twitter.com/")
    end
    it "should return github profile url" do
      user = FactoryGirl.create(:user)
      user.profile_url(:github).should include("https://github.com/")
    end
  end

  context "has_account_merged_with? method" do
    it "should return false if user's account has not been merged with facebook yet" do
      user = FactoryGirl.create(:user)
      user.has_account_merged_with?(:facebook).should be_false
    end

    it "should return true if user's account has been merged with facebook" do
      user = FactoryGirl.create(:user_facebook_valid_profile)
      user.has_account_merged_with?(:facebook).should be_true
    end
  end

  it "should add new user with some coordinates values" do
    lambda{
    @user = FactoryGirl.create(:user, :latitude => "1.2", :longitude => "1.2")
    @user = FactoryGirl.create(:user, :username => "walter22", :latitude => "21.2", :longitude => "41.2")
    }.should change(User, :count).by(2)
  end

  it 'should to_gmaps4rails return expected json' do
    @user = FactoryGirl.create(:user, :first_name => "ted", :last_name => "tylor",:latitude => '1.2345', :longitude => '6.789')
    @json = User.last.to_gmaps4rails

    @json.should include("#{@user.id}-#{@user.username}")
    @json.should include("#{@user.to_s}")
    @json.should include("1.2345")
    @json.should include("6.789")
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
    it "accept more nested blogs with https" do
      expect {
        @user.update_attributes(:blogs_attributes => {'0' => {'url'=>'https://delicious.com/', "_destroy"=>"false"}, '1' => {'url'=>'https://twitter.com/', "_destroy"=>"false"}})
      }.to change { Blog.count }.by(2)
    end
    it "accept more nested socials with https" do
      expect {
        @user.update_attributes('socials_attributes' => {'0' => {'url'=>'https://twitter.com/'}, '1' => {'url'=>'https://delicious.com/'}})
      }.to change { Social.count }.by(2)
    end
  end
end

