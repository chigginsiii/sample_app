require 'spec_helper'

describe "UsersPages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }
    it { should have_content('Sign Up') }
    it { should have_title(full_title('Sign Up')) }
  end

  describe "signup" do

    before { visit signup_path }
    let(:submit) { 'Create my account' }

    describe "with invalid information" do
      it "should not create a user" do
        expect{ click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before do
          fill_in_invalid_signup
          click_button 'Create my account'
        end
        it { should have_title("Sign Up") }
        it { should have_content("3 errors") }
        it { should have_content("Email is invalid") }
        it { should have_content("doesn't match Password") }
        it { should have_content("is too short") }
      end
    end

    describe "with valid information" do
      before do
        fill_in_valid_signup
      end

      it "should create a user" do
        expect{ click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("user@example.com") }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign Out') }
      end
    end
  end

  describe "edit" do

    describe "page" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit edit_user_path(user)
      end

      it { should have_content("Update your profile") }
      it { should have_title("Edit Profile") }
      it { should have_link('Change', href: "http://gravatar.com/email") }

      # XXX: this describes the menu of any logged in page, should RSpec::Matcher it
      it { should have_link("Account") }
      describe "after clicking Account" do
        before { click_link "Account" }
        it { should have_link("Profile", href: user_path(user) ) }
        it { should have_link("Settings", href: edit_user_path(user)) }
        it { should have_link("Sign Out", href: signout_path) }
      end
    end

    describe "update" do

      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe "with invalid information" do
        before { click_button "Save Changes" }
        it { should have_error }
      end

      describe "with valid information" do
        before do
          fill_in_valid_signup
          fill_in "Name", with: "CDH"
          click_button 'Save Changes'
        end
        it { should have_success("Profile updated!") }
      end
    end #update

  end #edit

end #UsersPages
