require 'spec_helper'

describe "Users" do
  describe 'GET /users/sign_up' do
    it "should successfully add new user" do
      visit '/users/sign_up'
      fill_in "Username", :with => 'prograils_user'
      fill_in "First name", :with => 'firstname'
      fill_in "Last name", :with => 'lastname'
      fill_in "Email", :with => "ruby@rails.com"
      fill_in "user[password]", :with => "foobar12"
      fill_in "user[password_confirmation]", :with => "foobar12"

      #TODO
      #fill_in "user[latitude]", :with => "1.2"
      #fill_in "user[longitude]", :with => "1.2"

      select "Poland", :from => 'user[country]'

      fill_in "Bio", :with => 'some description text ...'
      fill_in "Blog url", :with => 'http://www.myblog.app.com'
      fill_in "Twitter", :with => "http://www.twitter.com/1234"
      fill_in "Facebook", :with => "http://www.facebook.com/1234"
      fill_in "Google plus", :with => "http://www.googleplus.com/123"
      fill_in "Github", :with => 'http://www.github.com/123'
      fill_in "Stackoverflow", :with => "http://www.stackoverflow/1234"

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
end
