include ApplicationHelper

def signin_valid(user)
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button "Sign In"
end

def click_signout
  click_link "Account"
  click_link "Sign Out"
end

RSpec::Matchers.define :be_signed_out do
  match do |page|
    expect(page).to have_link("Sign In")
    expect(page).to have_content("Welcome to the Sample App")
  end
end

RSpec::Matchers.define :be_signed_in do |user|
  match do |page|
    click_link "Account"

    expect(page).to have_title(user.name)
    expect(page).not_to have_link('Sign In', href: signin_path)
    expect(page).to have_link('Profile',  href: user_path(user))
    expect(page).to have_link('Sign Out', href: signout_path)
  end
end
