include ApplicationHelper

def signin_valid(user) do
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button "Sign In"
end

def click_signout do
  click_link "Account"
  click_link "Sign Out"
end

RSpec::Matchers.define :be_signed_out do
  match do |page|
    it { should have_link("Sign In") }
    it { should have_content("Welcome to the Sample App") }
  end
end

RSpec::Matchers.define be_signed_in do |user|
  match do |page|
    before { click_link "Account" }

    it { should have_title(user.name) }
    it { should_not have_link('Sign In', href: signin_path) }
    it { should have_link('Profile',  href: user_path(user)) }
    it { should have_link('Sign Out', href: signout_path) }
  end
end
