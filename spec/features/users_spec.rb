require 'spec_helper'

describe "Users" do
  before(:all) do
    @country = FactoryGirl.create(:country)
  end
  after(:all) { Country.delete_all }

  describe 'GET /users/sign_up' do
    it "should successfully add new user" do
      visit '/users/sign_up'
      fill_in "Username", :with => 'prograils_user'
      fill_in "First name", :with => 'firstname'
      fill_in "Last name", :with => 'lastname'
      fill_in "Email", :with => "ruby@rails.com"
      fill_in "user[password]", :with => "foobar12"
      fill_in "user[password_confirmation]", :with => "foobar12"

      fill_in "user[latitude]", :with => "1.2"
      fill_in "user[longitude]", :with => "1.2"
      select @country.printable_name, :from => 'user[country_id]'

      fill_in "Bio", :with => 'some description text ...'
      fill_in "Twitter", :with => "http://rubyonrails.org/"
      fill_in "Facebook", :with => "http://rubyonrails.org/"
      fill_in "Google plus", :with => "http://rubyonrails.org/"
      fill_in "Github", :with => 'http://rubyonrails.org/'
      fill_in "Stackoverflow", :with => "http://rubyonrails.org/"

      click_button "Sign me up"
      page.should have_content("Welcome! You have signed up successfully.")
    end
  end

  describe "GET /users/sign_in" do
    it "allows users to sign in after they have registered" do
      user = FactoryGirl.create(:user, :email => "alindeman@example.com",
                         :password => "ilovegrapes", :password_confirmation => 'ilovegrapes')

      visit "/users/sign_in"

      fill_in "Email",    :with => "alindeman@example.com"
      fill_in "Password", :with => "ilovegrapes"

      click_button "Sign in"

      page.should have_content("Signed in successfully.")
    end
  end

  describe "GET /users/edit" do
    before do
      user = FactoryGirl.create(:user, :email => "alindeman@example.com",
                         :password => "ilovegrapes", :password_confirmation => 'ilovegrapes')
      sign_in(user)
      page.should have_content("Signed in successfully.")
      visit "/users/edit"
    end
    it "allows users to see edit page" do
      page.should have_content("Edit User")
    end
    it "allows to change username without current password" do
      fill_in "Username", :with => "Test"
      fill_in "First name", :with => "Mark"
      fill_in "Last name", :with => "Twain"
      fill_in "Email", :with => "mark@twain.eu"
      click_button "username_sub"
      page.should have_content("You updated your account successfully")
    end
    it "allows to change password" do
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      fill_in "user_current_password", :with => "ilovegrapes"
      click_button "password_sub"
      page.should have_content("You updated your account successfully")
    end
    it "doesn't allow to change password without current password" do
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end
    it "allows to change skills without current password" do
      fill_in "Tags", :with => "programmer"
      click_button "skills_sub"
      page.should have_content("You updated your account successfully")
    end
    it "allows to change biography without current password" do
      fill_in "Bio", :with => "I was born in ..."
      click_button "biography_sub"
      page.should have_content("You updated your account successfully")
    end
    #TODO
    it "allows to change blogs without current password" do
    end
    it "allows to change social profiles without current password" do
      fill_in "Twitter", :with => "http://rubyonrails.org/"
      fill_in "Facebook", :with => "http://rubyonrails.org/"
      fill_in "Google plus", :with => "http://rubyonrails.org/"
      fill_in "Github", :with => "http://rubyonrails.org/"
      fill_in "Stackoverflow", :with => "http://rubyonrails.org/"
      click_button "social_sub"
      page.should have_content("You updated your account successfully")
    end
  end

  describe "GET /user/:id" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @user_with_email_for_no_one = FactoryGirl.create(:user, :email_privacy => 0)
      @user_with_email_for_logged_in = FactoryGirl.create(:user, :email_privacy => 1)
      @user_with_email_for_anyone = FactoryGirl.create(:user, :email_privacy => 2)
    end

    after (:each) { Warden.test_reset! }

    context "user is not logged in" do
      it "should never show email" do
        visit user_path(@user_with_email_for_no_one)
        page.should_not have_content "Email"
        page.should_not have_content @user_with_email_for_no_one.email
      end

      it "should show email only for logged in" do
        visit user_path(@user_with_email_for_logged_in)
        page.should_not have_content "Email"
        page.should_not have_content @user.email
      end

      it "should show email for anyone" do
       visit user_path(@user_with_email_for_anyone)
       page.should have_content "Email"
       page.should have_content @user_with_email_for_anyone.email
      end
    end

    context "user is logged in" do
      before(:each) { login_as(@user, :scope => :user) }

      it "should never show email" do
        visit user_path(@user_with_email_for_no_one)
        page.should_not have_content "Email"
        page.should_not have_content @user_with_email_for_no_one.email
      end

      it "should show email only for logged in" do
        visit user_path(@user_with_email_for_logged_in)
        page.should have_content "Email"
        page.should have_content @user_with_email_for_logged_in.email
      end

      it "should show email for anyone" do
        visit user_path(@user_with_email_for_anyone)
        page.should have_content "Email"
        page.should have_content @user_with_email_for_anyone.email
      end
    end
  end
end
