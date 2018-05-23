require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    Rails.application.load_seed
  end

  let(:event) { Event.find_by(title: 'This is the 3rd event') }

  it "is valid with valid attributes" do
    expect(event).to be_valid
  end

  context 'is not valid without a valid title' do
    it 'title is nil' do
      event.title = nil
      expect(event).to_not be_valid
    end
    it 'title is too short' do
      event.title = 'ABC'
      expect(event).to_not be_valid
    end
    it 'title is too long' do
      event.title = 'A' * 51
      expect(event).to_not be_valid
    end
  end

  context "is not valid without a valid description" do
    it 'description is nil' do
      event.description = nil
      expect(event).to_not be_valid
    end
    it 'is too short' do
      event.description = 'aa'
      expect(event).to_not be_valid
    end
    it 'is too long' do
      event.description = 'a' * 1001
      expect(event).to_not be_valid
    end
  end

  context "is not valid without a valid location" do
    it "location is nil" do
      event.location = nil
      expect(event).to_not be_valid
    end
    it 'is too short' do
      event.location = 'aa'
      expect(event).to_not be_valid
    end
    it 'is too long' do
      event.location = 'a' * 101
      expect(event).to_not be_valid
    end
  end

  context "is not valid without a valid date" do
    it 'date is nil' do
      event.date = nil
      expect(event).to_not be_valid
    end
    it 'date is a string' do
      event.date = 'not a date'
      expect(event).to_not be_valid
    end
    it 'date is not real' do
      event.date = '2018-02-31'
      expect(event).to_not be_valid
    end
  end
end
