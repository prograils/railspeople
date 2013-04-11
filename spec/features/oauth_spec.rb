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

  describe 'user signed in' do
    describe 'by /users/sign_in form' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        login_as(@user, :scope => :user)
        visit '/users/edit'
      end

      it 'should not increment User count after merge with facebook' do
        set_omniauth(:facebook)
        expect {
          click_link 'merge_account_with_facebook'
        }.not_to change { User.count }.by(1)
      end

      it 'should update User record after merge with facebook' do
        set_omniauth(:facebook)
        @user.facebook.should be_nil
        click_link 'merge_account_with_facebook'
        @user.reload
        @user.facebook.should_not be_nil
      end

      it 'should not increment User count after merge with twitter' do
        set_omniauth(:twitter)
        expect {
          click_link 'merge_account_with_twitter'
        }.not_to change { User.count }.by(1)
      end

      it 'should increment OAuthCredential count after merge with twitter' do
        expect {
          set_omniauth(:twitter)
          click_link 'merge_account_with_twitter'
        }.to change { OAuthCredential.count }.by(1)
      end

      it 'should update User record after merge with twitter' do
        set_omniauth(:twitter)
        @user.twitter.should be_nil
        click_link 'merge_account_with_twitter'
        @user.reload
        @user.twitter.should_not be_nil
      end

      it 'should not increment User count after merge with github' do
        set_omniauth(:github)
        expect {
          click_link 'merge_account_with_github'
        }.not_to change { User.count }.by(1)
      end

      it 'should increment OAuthCredential count after merge with github' do
        set_omniauth(:github)
        expect {
          click_link 'merge_account_with_github'
        }.to change { OAuthCredential.count }.by(1)
      end

      it 'should update User record after merge with github' do
        set_omniauth(:github)
        @user.github.should be_nil
        click_link 'merge_account_with_github'
        @user.reload
        @user.github.should_not be_nil
      end
    end
  end
end


