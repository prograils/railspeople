require 'spec_helper'

describe "OAuthCredentials" do
  before(:each) do
    @country = FactoryGirl.create(:country)

    visit '/users/sign_up'
    fill_in "Username", :with => 'prograils_user'
    fill_in "First name", :with => 'firstname'
    fill_in "Last name", :with => 'lastname'
    fill_in "Email", :with => "ruby@rails.com"
    fill_in "user[password]", :with => "foobar12"
    fill_in "user[password_confirmation]", :with => "foobar12"

    #fill_in "user[latitude]", :with => "1.2"
    #fill_in "user[longitude]", :with => "1.2"
    select @country.printable_name, :from => 'user[country_id]'
  end

  describe 'GET /users/sign_up' do
    it "should  not increment OAuthCredential count" do
      # OAuthCredential count increments only if authorisation
      # is by twitter, facebook etc.
      expect {
        click_button "Sign me up"
      }.not_to change { OAuthCredential.count }.by(1)
    end
  end
end