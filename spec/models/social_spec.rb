require 'spec_helper'

describe Social do
   it "should have valid factory" do
    @user = FactoryGirl.create(:user)
    FactoryGirl.build(:social, :user_id => @user.id).should be_valid
  end

  describe "validatable attributes" do
    it "should be valid if user is nil" do
      FactoryGirl.build(:social, :user_id => nil).should be_valid
    end
    it "should be valid if title is empty" do
      FactoryGirl.build(:social, :title => "").should be_valid
    end
  end

  describe "validatable social url" do
    it "should not be valid if url is empty" do
      FactoryGirl.build(:social, :url => "").should_not be_valid
    end
    it "should not be valid if url is invalid" do
      FactoryGirl.build(:social, :url => "http://www").should_not be_valid
    end
  end

  describe "social title" do
    it "should be added after create" do
      @social = FactoryGirl.create(:social, :user_id => 1)
      @social.title.should eq("stackoverflow")
    end
  end
end
