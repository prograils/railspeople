require 'spec_helper'

describe "Oauth" do

  it "should succesfull authorized from facebook account" do
    set_omniauth(:facebook)
    visit "/"
    click_link "sign_in_with_facebook"
    page.should have_content "Successfully authorized from facebook account"
  end

  it "should succesfull authorized from twitter account" do
    set_omniauth(:twitter)
    visit "/"
    click_link "sign_in_with_twitter"
    page.should have_content "Successfully authorized from twitter account"
  end

  it "should succesfull authorized from github account" do
    set_omniauth(:github)
    visit "/"
    click_link "sign_in_with_github"
    page.should have_content "Successfully authorized from github account"
  end
end


