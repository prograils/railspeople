require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
    it "returns http success if user is loggged in" do
      sign_in @user
      get 'show'
      response.should be_success
    end
  end
end
