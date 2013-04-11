require 'spec_helper'

describe "Oauth" do
  describe 'user not logged in and has had not account yet' do
    it "should succesfull authorized from facebook account" do
      set_omniauth(:facebook)
      visit "/"
      click_link "sign_in_with_facebook"
      page.should have_content "Successfully authorized from facebook account"
    end

    it "should increment all user counter after facebook authorisation" do
      set_omniauth(:facebook)
      visit "/"
      expect {
        click_link "sign_in_with_facebook"
      }.to change { User.count }.by(1)
    end

    it "should increment OAuthCredential count after facebook authorisation" do
      set_omniauth(:facebook)
      visit "/"
      expect {
        click_link "sign_in_with_facebook"
      }.to change { OAuthCredential.count }.by(1)
    end

    it "should succesfull authorized from twitter account" do
      set_omniauth(:twitter)
      visit "/"
      click_link "sign_in_with_twitter"
      page.should have_content "Successfully authorized from twitter account"
    end

    it "should increment User count after twitter authorisation" do
      set_omniauth(:twitter)
      visit "/"
      expect {
        click_link "sign_in_with_twitter"
      }.to change { User.count }.by(1)
    end

    it "should increment OAuthCredential count after twitter authorisation" do
      set_omniauth(:twitter)
      visit "/"
      expect {
        click_link "sign_in_with_twitter"
      }.to change { OAuthCredential.count }.by(1)
    end

    it "should succesfull authorized from github account" do
      set_omniauth(:github)
      visit "/"
      click_link "sign_in_with_github"
      page.should have_content "Successfully authorized from github account"
    end

    it "should increment User count after github authorisation" do
      set_omniauth(:github)
      visit "/"
      expect {
        click_link "sign_in_with_github"
      }.to change { User.count }.by(1)
    end

    it "should increment OAuthCredential count after github authorisation" do
      set_omniauth(:github)
      visit "/"
      expect {
        click_link "sign_in_with_github"
      }.to change { OAuthCredential.count }.by(1)
    end
  end

  describe 'user not logged in and had account' do
    before do
      @user = FactoryGirl.create(:user, email: get_omniauth_email(:facebook))
    end

    it "should succesfull authorized from facebook account" do
      set_omniauth(:facebook)
      visit "/"
      click_link "sign_in_with_facebook"
      page.should have_content "Successfully authorized from facebook account"
    end

    it "should not increment User count after facebook authorisation" do
      set_omniauth(:facebook)
      visit "/"
      expect {
        click_link "sign_in_with_facebook"
      }.not_to change { User.count }.by(1)
    end

    it "should succesfull authorized from twitter account" do
      set_omniauth(:twitter)
      visit "/"
      click_link "sign_in_with_twitter"
      page.should have_content "Successfully authorized from twitter account"
    end

    it "should increment User count after twitter authorisation" do
      set_omniauth(:twitter)
      visit "/"
      expect {
        click_link "sign_in_with_twitter"
      }.to change { User.count }.by(1)
    end

    it "should succesfull authorized from github account" do
      set_omniauth(:github)
      visit "/"
      click_link "sign_in_with_github"
      page.should have_content "Successfully authorized from github account"
    end

    it "should increment User count after github authorisation" do
      set_omniauth(:github)
      visit "/"
      expect {
        click_link "sign_in_with_github"
      }.to change { User.count }.by(1)
    end
  end

  describe 'user'
end


