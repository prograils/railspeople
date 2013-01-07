require 'spec_helper'

describe "About" do
  it "should reditect to about page" do
    visit "/"
    click_link "About"
    page.should have_content "About Rails People"
  end
end
