require 'spec_helper'

describe "OAuthCredentials" do
  describe "sign_up action" do
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

    describe 'after click_link Sign me up' do
      it "should  not increment OAuthCredential count" do
        # OAuthCredential count increments only if authorisation
        # is by twitter, facebook etc.
        expect {
          click_button "Sign me up"
        }.not_to change { OAuthCredential.count }.by(1)
      end
    end
  end

  describe "sign_up by socials" do
    it "should increment OAuthCredential count after facebook authorisation" do
      set_omniauth(:facebook)
      visit "/"
      expect {
        click_link "sign_in_with_facebook"
      }.to change { OAuthCredential.count }.by(1)
    end

    it "should increment OAuthCredential count after twitter authorisation" do
      set_omniauth(:twitter)
      visit "/"
      expect {
        click_link "sign_in_with_twitter"
      }.to change { OAuthCredential.count }.by(1)
    end

    it "should increment OAuthCredential count after github authorisation" do
      set_omniauth(:github)
      visit "/"
      expect {
        click_link "sign_in_with_github"
      }.to change { OAuthCredential.count }.by(1)
    end
  end

  describe "users/edit form" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as(@user, :scope => :user)
      visit '/users/edit'
    end

    describe "after merge with facebook" do
      it 'should add new OAuthCredential record with provider column filled "facebook"' do
        set_omniauth(:facebook)
        OAuthCredential.where(user: @user).where(provider: "facebook").any?.should be_false
        click_link 'merge_account_with_facebook'
        OAuthCredential.where(user: @user).where(provider: "facebook").any?.should be_true
      end
    end

    describe "after merge with twitter" do
      it 'should add new OAuthCredential record with provider column filled "twitter"' do
        set_omniauth(:twitter)
        OAuthCredential.where(user: @user).where(provider: "twitter").any?.should be_false
        click_link 'merge_account_with_twitter'
        OAuthCredential.where(user: @user).where(provider: "twitter").any?.should be_true
      end
    end

    describe "after merge with github" do
      it 'should add new OAuthCredential record with provider column filled "github"' do
        set_omniauth(:github)
        OAuthCredential.where(user: @user).where(provider: "github").any?.should be_false
        click_link 'merge_account_with_github'
        OAuthCredential.where(user: @user).where(provider: "github").any?.should be_true
      end
    end

    describe "after merge with github, twitter and facebook" do
      it 'should increment OAuthCredential count by 3' do
        expect {
          set_omniauth(:facebook)
          click_link 'merge_account_with_facebook'
          set_omniauth(:github)
          click_link 'merge_account_with_github'
          set_omniauth(:twitter)
          click_link 'merge_account_with_twitter'
        }.to change { OAuthCredential.count }.by(3)
      end
    end

    describe "after click cancell account button" do
      it 'should delete all credentials' do
        set_omniauth(:facebook)
        click_link 'merge_account_with_facebook'
        set_omniauth(:github)
        click_link 'merge_account_with_github'
        set_omniauth(:twitter)
        click_link 'merge_account_with_twitter'

        expect {
          click_on "destroy_link"
        }.to change { OAuthCredential.count }.by(-3)

        OAuthCredential.where(user: @user).any?.should be_false
      end
    end
  end
end