require 'rails_helper'

RSpec.describe Relationship, type: :model do
  # describe 'Association' do
  #   it { is_expected.to belong_to(:follower).class_name("User") }
  #   it { is_expected.to belong_to(:followed).class_name("User") }
  # end

  # describe 'valid attributes' do
  #   it { is_expected.to validate_presence_of(:follower_id) }
  #   it { is_expected.to validate_presence_of(:followed_id) }
  # end

  let(:follower) { FactoryBot.create(:user) }
  let(:followed) { FactoryBot.create(:user) }
  let(:relationship) { follower.active_relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { is_expected.to be_valid }

  describe "follower methods" do
    it { is_expected.to respond_to(:follower) }
    it { is_expected.to respond_to(:followed) }
    it { expect(subject.follower).to eq follower }
    it { expect(subject.followed).to eq followed }
  end

  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { is_expected.not_to be_valid }
  end


end
