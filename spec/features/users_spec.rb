require 'spec_helper'

describe "Users" do
  before(:each) do
    @country = FactoryGirl.create(:country)
  end

  describe 'GET /users/sign_up' do
    it "should successfully add new user" do
      visit '/users/sign_up'
      fill_in "Username", :with => 'prograils_user'
      fill_in "First name", :with => 'firstname'
      fill_in "Last name", :with => 'lastname'
      fill_in "Email", :with => "ruby@rails.com"
      fill_in "user[password]", :with => "foobar12"
      fill_in "user[password_confirmation]", :with => "foobar12"
      select @country.printable_name, :from => 'user[country_id]'
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
      @user = FactoryGirl.create(:user, password: 'ilovegrapes', password_confirmation: 'ilovegrapes')
      login_as(@user, :scope => :user)
      visit '/users/edit'
    end

    it "allows users to see edit page" do
      page.should have_content("Edit User")
    end

    it "should be set flag change_password_needed to false" do
      @user.change_password_needed.should == false
    end

    it "allows to change username without current password" do
      fill_in "Username", :with => "Test"
      fill_in "First name", :with => "Mark"
      fill_in "Last name", :with => "Twain"
      click_button "username_sub"
      page.should have_content("You updated your account successfully")
    end

    it "doesn't allow to change email without current password" do
      fill_in "Email", :with => "different@test.pl"
      click_button "username_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "allows to change password" do
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      fill_in "user_current_password", :with => "ilovegrapes"
      click_button "password_sub"
      page.should have_content("You updated your account successfully")
    end

    it "doesn't allow to change password if confirmation doesn't match" do
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "blablabla"
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
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

    it "allows to change social profiles without current password" do
      fill_in "Gtalk", :with => "Bar"
      fill_in "Skype", :with => "Bar"
      fill_in "Jabber", :with => "Bar"
      click_button "social_sub"
      page.should have_content("You updated your account successfully")
    end

    it "allows to cancel the account" do
      click_on "destroy_link"
      page.should have_content("Bye! Your account was successfully cancelled. We hope to see you again soon.")
    end
  end

  context "GET /users/edit after registration by facebook" do
    before do
      @user = FactoryGirl.create(:user_facebook_auth, country_validation: false)
      login_as(@user, :scope => :user)
      visit '/users/edit'
      second_option_xpath = "//*[@id='user_country_id']/option[2]"
      @second_option = find(:xpath, second_option_xpath).text
    end

    it "allows users to see edit page" do
      page.should have_content("Edit User")
    end

    it "should be set flag change_password_needed to true" do
      @user.change_password_needed.should == true
    end

    it "should be set flag change_password_needed to false after profile updated" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "Email", :with => "different@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      @user.reload
      @user.change_password_needed.should == false
    end

    it "not allows to change user data without set password first" do
      fill_in "Username", :with => "Test"
      fill_in "First name", :with => "Mark"
      fill_in "Last name", :with => "Twain"
      click_button "username_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows to change email without set password first" do
      fill_in "Email", :with => "different@test.pl"
      click_button "username_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows allows to change skills and etc. without set password first" do
      fill_in "Tags", :with => "programmer"
      click_button "skills_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows to change password if country is not set" do
      fill_in "Email", :with => "different@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      #page.should_not have_content("You updated your account successfully")
    end

    it "allows to update profile if country, password and password confirmation are set" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "Email", :with => "different@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      page.should have_content("You updated your account successfully")
    end

    it "doesn't allow to change password if confirmation doesn't match" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "Email", :with => "different@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "blablabla"
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "allows to cancel the account" do
      click_on "destroy_link"
      page.should have_content("Bye! Your account was successfully cancelled. We hope to see you again soon.")
    end
  end

  context "GET /users/edit after registration by twitter" do
    before do
      @user = FactoryGirl.create(:user_twitter_auth, country_validation: false)
      login_as(@user, :scope => :user)
      visit '/users/edit'
      second_option_xpath = "//*[@id='user_country_id']/option[2]"
      @second_option = find(:xpath, second_option_xpath).text
    end

    it "allows users to see edit page" do
      page.should have_content("Edit User")
    end

    it "should be set flag change_password_needed to true" do
      @user.change_password_needed.should == true
    end

    it "should be set flag change_password_needed to false after profile updated" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "Email", :with => "some_email@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      @user.reload
      @user.change_password_needed.should == false
    end

    it "not allows to change user data without set password first" do
      fill_in "Username", :with => "Test"
      fill_in "First name", :with => "Mark"
      fill_in "Last name", :with => "Twain"
      fill_in "Email", :with => "some_email@test.pl"
      click_button "username_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows to change email without set password first" do
      fill_in "Email", :with => "some_email@test.pl"
      click_button "username_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows allows to change skills and etc. without set password first" do
      fill_in "Email", :with => "some_email@test.pl"
      fill_in "Tags", :with => "programmer"
      click_button "skills_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows to change password if country is not set" do
      fill_in "Email", :with => "some_email@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      #page.should_not have_content("You updated your account successfully")
    end

    it "allows to update profile if country, password and password confirmation and email are set" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "Email", :with => "some_email@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      page.should have_content("You updated your account successfully")
    end

    it "doesn't allow to update profile if email is not changed" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "doesn't allow to change password if confirmation doesn't match" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "Email", :with => "some_email@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "blablabla"
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "allows to cancel the account" do
      click_on "destroy_link"
      page.should have_content("Bye! Your account was successfully cancelled. We hope to see you again soon.")
    end
  end

  context "GET /users/edit after registration by github" do
    before do
      @user = FactoryGirl.create(:user_github_auth, country_validation: false, name_validation: false)
      login_as(@user, scope: :user)
      visit '/users/edit'
      @old_email = @user.email
      second_option_xpath = "//*[@id='user_country_id']/option[2]"
      @second_option = find(:xpath, second_option_xpath).text

      # fill form with default values
      page.select(@second_option, :from => "user_country_id")
      fill_in "user_first_name", :with => "Mark"
      fill_in "user_last_name", :with => "Twain"
      fill_in "Email", :with => "some_email@test.pl"
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "admin1"
    end

    it "allows users to see edit page" do
      page.should have_content("Edit User")
    end

    it "should be set flag change_password_needed to true" do
      @user.change_password_needed.should == true
    end

    it "should be set flag change_password_needed to false after profile updated" do
      click_button "password_sub"
      @user.reload
      @user.change_password_needed.should == false
    end

    it "not allows to change user data without set password first" do
      fill_in "Username", :with => "Test"
      fill_in "user_password", :with => ""
      fill_in "user_password_confirmation", :with => ""
      click_button "username_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows to change skills and etc. without set password first" do
      fill_in "user_password", :with => ""
      fill_in "user_password_confirmation", :with => ""
      fill_in "Tags", :with => "programmer"
      click_button "skills_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "do not allows to change password if country is not set" do
      click_button "password_sub"
      #page.should_not have_content("You updated your account successfully")
    end

    it "allows to update profile if country, password and password confirmation, email and first and last names are set" do
      click_button "password_sub"
      page.should have_content("You updated your account successfully")
    end

    it "doesn't allow to update profile if email is not changed" do
      fill_in "Email", :with => @old_email
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "doesn't allow to update profile if first and last name are not filled" do
      page.select(@second_option, :from => "user_country_id")
      fill_in "First name", :with => ""
      fill_in "Last name", :with => ""
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "doesn't allow to change password if confirmation doesn't match" do
      fill_in "user_password", :with => "admin1"
      fill_in "user_password_confirmation", :with => "blablabla"
      click_button "password_sub"
      page.should_not have_content("You updated your account successfully")
    end

    it "allows to cancel the account" do
      click_on "destroy_link"
      page.should have_content("Bye! Your account was successfully cancelled. We hope to see you again soon.")
    end
  end

  #NESTED ATTRIBUTES
  context "nested attribiutes", :js => true do
    it "allows to change blogs without current password" do
      user = FactoryGirl.create(:user, :email => "alinde@example3.com", :password => "ilovegrapes", :password_confirmation => 'ilovegrapes')
      login_as(user, :scope => :user)
      visit "/users/edit"
      #page.should have_content "Change my username"
      click_on("Add next")
      find("input[id^='user_blogs_attributes'][id$='url']").set("http://www.pandora.com")
      click_button "blogs_sub"

      page.should have_content("You updated your account successfully")
    end

    it "allows to change two socials without current password" do
      user = FactoryGirl.create(:user, :email => "alinde@example4.com", :password => "ilovegrapes", :password_confirmation => 'ilovegrapes')
      login_as(user, :scope => :user)
      visit "/users/edit"
      click_on("Add service")
      find("input[id^='user_socials_attributes'][id$='url']").set("http://www.pandora.com")
      click_on("Add service")
      #find("input[id^='user_socials_attributes'][id$='url']").set("http://www.pandora.com")
      all("input[id^='user_socials_attributes'][id$='url']")[1].set("http://www.pandora.com")
      click_button "blogs_sub"

      page.should have_content("You updated your account successfully")
    end
  end

  describe "GET /user/:id" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @user_with_email_for_no_one = FactoryGirl.create(:user, :email_privacy => 0)
      @user_with_email_for_logged_in = FactoryGirl.create(:user, :email_privacy => 1)
      @user_with_email_for_anyone = FactoryGirl.create(:user, :email_privacy => 2)

      @user_with_im_details_for_logged_in = FactoryGirl.create(:user, im_privacy: false)
      @user_with_im_details_for_anyone = FactoryGirl.create(:user, im_privacy: true)
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

      it "should show email for all" do
       visit user_path(@user_with_email_for_anyone)
       page.should have_content "Email"
       page.should have_content @user_with_email_for_anyone.email
      end

      it "should show im_details only for logged in" do
        visit user_path(@user_with_im_details_for_logged_in)
        page.should_not have_content "Finding"
      end

      it "should show im_details for all" do
       visit user_path(@user_with_im_details_for_anyone)
       page.should have_content "Finding"
      end

      it "im_details should show facebook profile" do
        user = FactoryGirl.create(:user_facebook_valid_profile, im_privacy: true)
        visit user_path(user)
        page.should have_content user.facebook
      end

      it "im_details should show twitter profile" do
        user = FactoryGirl.create(:user_twitter_valid_profile, im_privacy: true)
        visit user_path(user)
        page.should have_content user.twitter
      end

      it "im_details should show github profile" do
        user = FactoryGirl.create(:user_github_valid_profile, im_privacy: true)
        visit user_path(user)
        page.should have_content user.github
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

      it "should show email for all" do
        visit user_path(@user_with_email_for_anyone)
        page.should have_content "Email"
        page.should have_content @user_with_email_for_anyone.email
      end

      it "should show im_details only for logged in" do
        visit user_path(@user_with_im_details_for_logged_in)
        page.should have_content "Finding"
      end

      it "should show im_details for all" do
        visit user_path(@user_with_im_details_for_anyone)
        page.should have_content "Finding"
      end

      it "im_details should show facebook profile" do
        user = FactoryGirl.create(:user_facebook_valid_profile, im_privacy: true)
        visit user_path(user)
        page.should have_content user.facebook
      end

      it "im_details should show twitter profile" do
        user = FactoryGirl.create(:user_twitter_valid_profile, im_privacy: true)
        visit user_path(user)
        page.should have_content user.twitter
      end

      it "im_details should show github profile" do
        user = FactoryGirl.create(:user_github_valid_profile, im_privacy: true)
        visit user_path(user)
        page.should have_content user.github
      end

      it "should show blogs" do
        @blog = FactoryGirl.create(:blog, :user_id => @user.id)
        visit user_path(@user)
        find(:css, "a:contains('wp')")
      end

      it "should show socials" do
        @social = FactoryGirl.create(:social, :user_id => @user.id)
        visit user_path(@user)
        find(:css, "a:contains('stackoverflow')")
      end
    end
  end

  describe "GET user show loggedd as user" do
    before(:each) do
      @user = FactoryGirl.create(:user, :email => "brown@test.pl")
      login_as(@user, :scope => :user)
      @country = FactoryGirl.create(:country)
      @near = FactoryGirl.create(:user, :first_name => "Jessy", :last_name => "Black", :username => "JeBe", :country_id => @country.id,
        :email_privacy => 0, :latitude => 52.350, :longitude => 16.750, :email => "jb@test.pl")
    end

    it "should can click on near people" do
      visit user_path(@user)
      click_on("JeBe")
      page.should have_content "Jessy Black"
    end

    it "should show people with the same tags" do
      @tag = FactoryGirl.create(:tag)
      FactoryGirl.create(:tagging, :user => @user, :tag => @tag)
      FactoryGirl.create(:tagging, :user => @near, :tag => @tag)
      visit user_path(@user)
      click_on "MyString"
      page.should have_content "2 Ruby on Rails people mention this skill"
    end
  end

  describe "user show map" do
    before do
      @user = FactoryGirl.create(:user)
      visit user_path(@user)
      page.execute_script("init()")
    end
  end
end
