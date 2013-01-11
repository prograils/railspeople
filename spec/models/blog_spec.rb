require 'spec_helper'

describe Blog do
   it "should have valid factory" do
    @user = FactoryGirl.create(:user)
    FactoryGirl.build(:blog, :user_id => @user.id).should be_valid
  end

  describe "validatable attributes" do
    it "should not be valid if user is nil" do
      FactoryGirl.build(:blog, :user_id => nil).should_not be_valid
    end
  end
  describe "validatable blog url" do
    it "should not be valid if url is empty" do
      FactoryGirl.build(:blog, :url => "").should_not be_valid
    end
    it "should not be valid if title is empty" do
      FactoryGirl.build(:blog, :title => "").should_not be_valid
    end
  end
end
