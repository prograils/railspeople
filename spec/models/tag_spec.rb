require 'spec_helper'

describe Tag do
  
  before(:all) do
    @user = FactoryGirl.create(:user)
    Tag.delete_all
    Tagging.delete_all
  end

  it "should save only unique tags from tag_names" do
    @user.tag_names = "raz dwa trzy trzy"
    @user.save
    
    Tag.count.should == 3
    Tagging.count.should == 3
    @user.tags.count.should == 3
  end

  it "should destroy record in tagging table after change tags" do
    @user.tag_names = "trzy cztery"
    @user.save  
    
    @user.tags.count.should == 2 
    Tag.count.should == 4
    Tagging.count.should == 2 
  end
end
