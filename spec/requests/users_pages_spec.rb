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
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "user@example"
          fill_in "Password", with: "fooba"
          fill_in "Confirmation", with: "toobar"
          click_button submit
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
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect{ click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("user@example.com") }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end
  end

end
