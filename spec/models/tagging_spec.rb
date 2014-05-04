require 'spec_helper'

describe Tagging do
  it "should have valid factory" do
    @user = FactoryGirl.create(:user)
    FactoryGirl.build(:tagging, user_id: @user.id).should be_valid
  end
end
