require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  shared_examples_for "all static pages" do
    it { should have_selector(:css, "h1", page_name) }
    it { should have_title(full_title(page_title)) }
  end

  subject { page }
  describe "Home page" do
    before {  visit '/' }
    let(:page_name) { 'Welcome to the Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_title(full_title("Home")) }
  end

  describe "Help page" do
    before {  visit '/help' }
    let(:page_name) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before {  visit "/about" }
    let(:page_name) { 'About' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before {  visit "/contact" }
    let(:page_name) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  it "should have valid links in layout" do
    visit root_path
    click_link('About')
    expect(page).to have_title(full_title("About Us"))
    click_link('Help')
    expect(page).to have_title(full_title("Help"))
    click_link('Contact')
    expect(page).to have_title(full_title("Contact"))
    click_link("Home")
    click_link("sample app")
    expect(page).to have_css("h1", text: "Welcome to the Sample App")
    click_link("Sign up now!")
    expect(page).to have_title(full_title("Sign Up"))
  end

end
