require 'spec_helper'

describe "Users" do
  describe 'GET /users/sign_up' do
    it "should successfully add new user" do
      visit '/users/sign_up'
      fill_in "Email", :with => "ruby@rails.com"
      fill_in "user[password]", :with => "foobar12"
      fill_in "user[password_confirmation]", :with => "foobar12"
      click_button "Sign up"
      page.should have_content("Welcome! You have signed up successfully.")
    end
  end
end
