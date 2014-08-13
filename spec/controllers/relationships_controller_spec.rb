require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user, no_capybara: true }

  describe "creating a relationship with ajax" do

    it "should increment the relationship count" do
      expect do
        # method, REST operation, resource?
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, :relationship => { followed_id: other_user.id }
    end

  end

  # if i'm going to destroy a relationship, i think i'd rather use bourbon, wouldn't i?
  # ah well, gotta do whatcha gotta do... UNFOLLOW!
  describe "destroying a relationship with ajax" do
    before do
      user.follow!( other_user )
    end
    let (:relationship) { user.relationships.find_by(followed_id: other_user.id) }

    it "should decrement Relationships count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end
    end

  end

end
