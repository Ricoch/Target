require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build :user }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }

    context 'when was created with regular login' do
      subject { build :user }
      it { should validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
      it { should validate_presence_of(:email) }
    end
  end
end
