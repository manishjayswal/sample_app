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

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  # its(:user) { should eq user }


  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end