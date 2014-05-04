require 'spec_helper'

describe OAuthCredential do
  it "should have valid factories" do
    @user = FactoryGirl.create(:user)
    FactoryGirl.build(:facebook_credential, user_id: @user.id).should be_valid
    FactoryGirl.build(:twitter_credential, user_id: @user.id).should be_valid
    FactoryGirl.build(:github_credential, user_id: @user.id).should be_valid
  end
end
