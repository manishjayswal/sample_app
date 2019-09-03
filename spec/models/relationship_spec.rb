require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'Association' do
    it { should belong_to(:follower).class_name("User") }
    it { should belong_to(:followed).class_name("User") }
  end

  describe 'valid attributes' do
    it { should validate_presence_of(:follower_id) }
    it { should validate_presence_of(:followed_id) }
  end

end
