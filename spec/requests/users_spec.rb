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
      select "Poland", :from => 'user[country]'

      click_button "Sign up"
      page.should have_content("Welcome! You have signed up successfully.")
    end
  end

  describe "user sign in" do
    it "allows users to sign in after they have registered" do
      user = User.create(:email    => "alindeman@example.com",
                         :password => "ilovegrapes")

      visit "/users/sign_in"

      fill_in "Email",    :with => "alindeman@example.com"
      fill_in "Password", :with => "ilovegrapes"

      click_button "Sign in"

      page.should have_content("Signed in successfully.")
    end
  end
end
