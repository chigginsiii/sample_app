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

      it { should be_signed_in(user) }

      describe "followed by signing out" do
        before { click_signout }
        it { should be_signed_out }
        it { should_not have_title(user.name) }
      end

    end

  end

  describe "authorization" do

    describe "for non-logged-in Users" do
      let(:user) { FactoryGirl.create(:user) }
      before { delete signout_path(user) }
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should_not have_content('Update your profile') }
          it { should have_content('Sign In') }

          describe "after signing in" do
            before do
              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign In"
            end
            it { should have_title('Edit Profile') }
          end
        end

        describe "submitting the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the users index" do
            before { visit users_path }
            it { should have_title("Sign In") }
        end
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wronguser) { FactoryGirl.create(:user, email: 'wrongo@example.com') }

      describe "submitting a GET request to Users#edit action" do
        before do
          sign_in user, no_capybara: true
          get edit_user_path( wronguser )
        end
        specify { expect(response.body).not_to match(full_title('Edit Profile')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH to Users#update action" do
        before do
          sign_in user, no_capybara: true
          patch user_path(wronguser)
        end
        specify { expect(response).to redirect_to(root_url) }
      end
    end

  end

end
