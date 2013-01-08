require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'show'" do
    it "returns http success for non logged in user" do
      get 'show', :id => @user.id
      response.should be_success
    end
    it "returns http success if user is logged in" do
      sign_in @user
      get 'show', :id => @user.id
      response.should be_success
    end
  end
end
