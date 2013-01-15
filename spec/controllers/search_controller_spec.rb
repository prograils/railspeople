require 'spec_helper'

describe SearchController do

  before(:all) do
    @user_1 = FactoryGirl.create(:user, :username => "johnc", :first_name => "Parker", :last_name => "Coltrane")
    @user_2 = FactoryGirl.create(:user, :username => "parker", :first_name => "Miles", :last_name => "Davis")
    @user_3 = FactoryGirl.create(:user, :username => "johniea", :first_name => "Johnie", :last_name => "Armstrong")
    @user_4 = FactoryGirl.create(:user, :username => "johnp", :first_name => "John", :last_name => "Parker")
    @user_5 = FactoryGirl.create(:user, :username => "chrisp", :first_name => "Chris", :last_name => "Parker")
  end
  
  after(:all) do
    User.delete_all
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    describe do "search by username"
      it "should return correct record with query params" do
        get 'index', :q => 'chrisp'
        assigns[:results].count.should == 1  
      end

      it "should return three records with similar usernames" do
        get 'index', :q => 'john'
        assigns[:results].count.should == 3 
      end

      it "should return correct record if query params is part of the word" do
        get 'index', :q => 'hri'
        assigns[:results].first.username.should == "chrisp"
      end
      
      it "should return empty array if user does not exist" do
        get 'index', :q => "errnie"
        assigns[:results].should be_empty
      end
      
      it "should return empty array if query string is blank" do
        get 'index', :q => ""
        assigns[:results].should be_empty
      end

      it "should return empty array if query string has less than 3 characters" do
        get 'index', :q => "jo"
        assigns[:results].should be_empty
      end
    end

    describe 'search by username, first_name or last_name' do
      it "should return four records" do
        get 'index', :q => 'parker'
        assigns[:results].count.should == 4
      end
    end
  end
end
