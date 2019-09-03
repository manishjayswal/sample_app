require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  # describe 'Association' do
  #   it { should belong_to(:user)}
  # end

  # describe 'valid attributes' do
  #   it { should validate_presence_of(:user_id) }
  #   it { should validate_presence_of(:content) }
  #   it { should validate_length_of(:content).is_at_most(140) }
  # end

  subject { @micropost }

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:user) }
  # its(:user) { should eq user }
  it 'has a matching user' do
    expect(subject.user).to eq user
  end


  it { is_expected.to be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { is_expected.not_to be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { is_expected.not_to be_valid }
  end
end