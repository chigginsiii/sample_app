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

def fill_in_valid_signup
  fill_in "Name", with: "Example User"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

def fill_in_invalid_signup
  fill_in "Name", with: "Example User"
  fill_in "Email", with: "user@example"
  fill_in "Password", with: "fooba"
  fill_in "Confirmation", with: "toobar"
end

# this one's to give us sign-in capability without capybara
def sign_in( user, options={} )
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token,
                          User.digest(remember_token))
  else
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"
  end
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
    expect(page).to have_link('Users',       href: users_path)
    expect(page).to have_link('Profile',     href: user_path(user))
    expect(page).to have_link('Settings',    href: edit_user_path(user))
    expect(page).to have_link('Sign Out',    href: signout_path)
  end
end

RSpec::Matchers.define :have_error do |msg|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: msg)
  end
end

RSpec::Matchers.define :not_have_error do
  match do |page|
    expect(page).not_to have_selector('div.alert.alert-error')
  end
end

RSpec::Matchers.define :have_success do |msg|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: msg)
  end
end
