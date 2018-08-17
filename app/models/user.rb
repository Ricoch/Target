class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :uid, uniqueness: { scope: :provider }
  validates :email, presence: true

  before_validation :init_uid

  def self.from_social_provider(provider, user_params)
    where(provider: provider, uid: user_params['id']).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      user.assign_attributes user_params.except('id')
    end
  end

  private

  def uses_email?
    provider == 'email' || email.present?
  end

  def init_uid
    self.uid = email if uid.blank? && provider == 'email'
  end
end
