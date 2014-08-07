require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }



  describe "Home page" do
    # this said to run it again if I want to use webrat functions,
    # i'm assuming webrat is an alternative to capybara?
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    # title!
    it "should have title base_title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title}")
    end
    it "should not have a custom title" do
      visit '/static_pages/home'
      expect(page).not_to have_title("| Home")
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
      expect(page).to have_title("#{base_title} | Help")
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
      expect(page).to have_title("#{base_title} | About")
    end

  end

  describe "Contact page" do
    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end
    it "should have the title 'RoRT Sample App | Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
    end
  end

end
