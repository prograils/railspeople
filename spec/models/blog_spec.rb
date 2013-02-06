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
    it "should not be valid if title is empty" do
      FactoryGirl.build(:blog, :title => "").should_not be_valid
    end
  end
  describe "validatable blog url" do
    it "should not be valid if url is empty" do
      FactoryGirl.build(:blog, :url => "").should_not be_valid
    end
    it "should not be valid if url is invalid" do
      FactoryGirl.build(:blog, :url => "http://www").should_not be_valid
    end
  end

  describe "blog title" do
    before do
      @blog = FactoryGirl.build(:blog)
      @blog.save
    end
    it "should be added after save" do
      @blog.title.should eq("Wirtualna Polska - www.wp.pl")
    end
    it "should update after url change" do
      @blog.url = "http://twitter.com"
      @blog.save
      @blog.title.should eq("Twitter")
    end
  end
end
