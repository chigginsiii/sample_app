require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do
    # this said to run it again if I want to use webrat functions,
    # i'm assuming webrat is an alternative to capybara?
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    # title!
    it "should have title 'RoRT Sample App | Home'" do
      visit '/static_pages/home'
      expect(page).to have_title('RoRT Sample App | Home')
    end

  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit "/static_pages/help"
      expect(page).to have_content('Help')
    end

    # title!
    it "should have title 'RoRT Sample App | Title'" do
      visit '/static_pages/help'
      expect(page).to have_title('RoRT Sample App | Help')
    end
  end

  describe "About page" do
    it "should have the content 'About'" do
      visit "/static_pages/about"
      expect(page).to have_content('About')
    end

    # title!
    it "should have title 'RoRT Sample App | About'" do
      visit '/static_pages/about'
      expect(page).to have_title('RoRT Sample App | About')
    end

  end

end
