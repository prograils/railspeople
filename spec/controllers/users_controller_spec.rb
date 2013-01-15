require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user_with_email_for_no_one = FactoryGirl.create(:user, :email_privacy => 0)
    @user_with_email_for_logged_in = FactoryGirl.create(:user, :email_privacy => 1)
    @user_with_email_for_anyone = FactoryGirl.create(:user, :email_privacy => 2)
  end

  describe "GET 'show'" do
    
    context 'user signed in' do
      it "returns http success for non logged in user" do
        visit user_path(@user)
        page.should have_content @user.first_name 
      end
    end
   
    context 'user not signed in' do 
      it "returns http success if user is logged in" do
        sign_in @user
        visit user_path(@user)
        page.should have_content "People near"
      end
    end
  end
end
