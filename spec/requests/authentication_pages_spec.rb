require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "sign in" do
    before { visit signin_path }
    let(:title) { 'Sign In'}

    it { should have_title(title) }
    it { should have_selector('h1', text: title) }

    describe "with invalid credentials" do
      before { click_button title }
      it { should have_title(title) }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { visit root_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before { signin_valid(user) }

      it { should be_signed_in }

      describe "followed by signing out" do
        before { click_signout }
        it { should be_signed_out }
        it { should_not have_title(user.name) }
      end

    end

  end

end
