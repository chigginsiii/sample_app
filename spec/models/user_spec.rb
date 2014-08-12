require 'spec_helper'

describe User do

  before do
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'tryme!', password_confirmation: 'tryme!' )
  end
  subject {  @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when admin set to true" do
    before do
      @user.save
      @user.toggle(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before {  @user.email = ' ' }
    it {  should_not be_valid }
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com bob_at_fooooo.org heidi@pigtail foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_addr|
        @user.email = invalid_addr
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[example@foo.org bob_johnson@pinstripe.pants.com randy.moe@sheinhardt.gov wacky@bar.tv shimona@woohoo.net]
      addresses.each do |valid_addr|
        @user.email = valid_addr
        expect(@user).to be_valid
      end
    end
  end

  describe "when email is not unique" do
    before do
      user_same_email = @user.dup
      user_same_email.email = @user.email.upcase
      user_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new( name: 'Example', email: 'ex@ample.com',
                       password: '', password_confirmation: '' )
    end
    it {  should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before {  @user.password_confirmation = 'nomatch' }
    it { should_not be_valid }
  end

  # password too short
  describe "with a password that's too short" do
    before {  @user.password = @user.password_confirmation = 'a' * 5 }
    it {  should be_invalid }
  end

  # tests for authenticate:
  it { should respond_to(:authenticate) }

  describe "return value for authenticate" do
    # this will now have a digest...
    before { @user.save }
    # retrieve this user from db into a different var
    let(:found_user) { User.find_by(email: @user.email) }

    # use @user.password to check found_user.password_digest
    # and return the user on success
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    # this should return false instead of the user
    describe "with invalid password" do
      let(:user_for_invalid_password) {  found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_mp) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_mp) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_mp, older_mp]
    end

    describe "status" do
      let(:unfollowed) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
      its(:feed) { should include(newer_mp) }
      its(:feed) { should include(older_mp) }
      its(:feed) { should_not include(:unfollowed) }
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |m|
        expect( Micropost.find_by(id: m.id) ).to be_nil
      end
    end
  end

end
