require 'rails_helper'

describe Target do
  describe 'validations' do
    subject { build :target }
    it { should belong_to(:user) }
    it { should validate_presence_of(:topic) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:radius) }
    it { should validate_numericality_of(:radius).only_integer }
    it { should validate_presence_of(:latitude) }
    it { should validate_numericality_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_numericality_of(:longitude) }
  end
end
