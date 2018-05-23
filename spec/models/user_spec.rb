require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  context 'is not valid without a valid name' do
    it 'name is nil' do
      user.name = nil
      expect(user).to_not be_valid
    end
    it 'name is too short' do
      user.name = 'ABC'
      expect(user).to_not be_valid
    end
    it 'name is too long' do
      user.name = 'a' * 26
      expect(user).to_not be_valid
    end
  end

  context "is not valid without a valid email" do
    it 'email is nil' do
      user.email = nil
      expect(user).to_not be_valid
    end
    it 'is missing an "@"' do
      user.email = 'p1.email.com'
      expect(user).to_not be_valid
    end
    it 'is missing a "."' do
      user.email = 'p1@email'
      expect(user).to_not be_valid
    end
    it 'is too long' do
      user.email = 'a' * 250 + '@email.com'
      expect(user).to_not be_valid
    end
  end

  it "is not valid without a valid password digest" do
    user.password_digest = nil
    expect(user).to_not be_valid
  end
end
