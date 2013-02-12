require 'spec_helper'

describe "UsersController" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user_with_email_for_no_one = FactoryGirl.create(:user, :email_privacy => 0)
    @user_with_email_for_logged_in = FactoryGirl.create(:user, :email_privacy => 1)
    @user_with_email_for_anyone = FactoryGirl.create(:user, :email_privacy => 2)
    @user_with_im_privacy = FactoryGirl.create(:user, im_privacy: true)
    @user_without_im_privacy = FactoryGirl.create(:user, im_privacy: false)
  end

  describe "GET 'show'" do
    describe 'user not logged in' do

      it "show page content" do
        visit "/users/#{@user.id}"
        page.should have_content "People near"
        page.should have_content @user.first_name
      end

      it "don't show user email if email if is for no one" do
        visit "/users/#{@user_with_email_for_no_one.id}"
        page.should_not have_content @user.email
      end

      it "don't show user email if email is for logged in only" do
        visit "/users/#{@user_with_email_for_logged_in.id}"
        page.should_not have_content @user.email
      end

      it "show user email if email is for anyone" do
        visit "/users/#{@user_with_email_for_anyone.id}"
        page.should_not have_content @user.email
      end

      it "show user details if privacy is set to false" do
        visit "/users/#{@user_without_im_privacy.id}"
        #page.should have_content "Finding"
      end
      it "don't show user details if privacy is set to true" do
        visit "/users/#{@user_with_im_privacy.id}"
        #page.should_not have_content "Finding"
      end

    end

    describe 'user logged in' do
      before(:each) { login_as(@user, :scope => :user) }

      it "show page content" do
        visit "/users/#{@user.id}"
        page.should have_content "People near"
        page.should have_content @user.first_name
      end

      it "don't show user email if email has set visibility for no one" do
        visit "/users/#{@user_with_email_for_no_one.id}"
        page.should_not have_content @user_with_email_for_no_one.email
      end

      it "show user email if user visit own profile page" do
        visit "/users/#{@user.id}"
        page.should have_content @user.email
      end

      it "show user email if email has set visibility for logged in only" do
        visit "/users/#{@user_with_email_for_logged_in.id}"
        page.should have_content @user_with_email_for_logged_in.email
      end

      it "show user email if email has set visibility for anyone" do
        visit "/users/#{@user_with_email_for_anyone.id}"
        page.should have_content @user_with_email_for_anyone.email
      end

      it "show user details if privacy is set to false" do
        visit "/users/#{@user_without_im_privacy.id}"
        page.should have_content "Finding"
      end
      it "show user details if privacy is set to true" do
        visit "/users/#{@user_with_im_privacy.id}"
        page.should have_content "Finding"
      end

    end
  end
end
