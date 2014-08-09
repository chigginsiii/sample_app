require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "sign in" do
    before { visit signin_path }

    it { should have_title("Sign In") }
    it { should have_selector('h1', text: 'Sign In') }
  end

end
