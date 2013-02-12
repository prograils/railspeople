require 'spec_helper'

describe "UsersController" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user_with_email_for_no_one = FactoryGirl.create(:user, :email_privacy => 0)
    @user_with_email_for_logged_in = FactoryGirl.create(:user, :email_privacy => 1)
    @user_with_email_for_anyone = FactoryGirl.create(:user, :email_privacy => 2)
  end

  describe "GET 'show'" do
    context 'user not logged in' do

      it "show page content" do
        visit "/users/#{@user.id}"
        page.should have_content "People near"
        page.should have_content @user.first_name
      end

      it "don't show user email if is for no one" do
        visit "/users/#{@user_with_email_for_no_one.id}"
        page.should_not have_content @user.email
      end

      it "don't show user email if is for logged in only" do
        visit "/users/#{@user_with_email_for_logged_in.id}"
        page.should_not have_content @user.email
      end

      it "show user email if is for anyone" do
        visit "/users/#{@user_with_email_for_anyone.id}"
        page.should_not have_content @user.email
      end
    end

    context 'user logged in' do
      before(:each) { login_as(@user, :scope => :user) }

      it "show page content" do
        visit "/users/#{@user.id}"
        page.should have_content "People near"
        page.should have_content @user.first_name
      end

      it "show user email on his page" do
        visit "/users/#{@user.id}"
        page.should have_content @user.email
      end

      it "don't show user email if is for no one" do
        visit "/users/#{@user_with_email_for_no_one.id}"
        page.should_not have_content @user_with_email_for_no_one.email
      end

      it "show user email if is for logged in only" do
        visit "/users/#{@user_with_email_for_logged_in.id}"
        page.should have_content @user_with_email_for_logged_in.email
      end

      it "show user email if is for anyone" do
        visit "/users/#{@user_with_email_for_anyone.id}"
        page.should have_content @user_with_email_for_anyone.email
      end
    end
  end
end
