# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  username               :string           not null
#  verified               :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar, dependent: :destroy


  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :ensure_username

  def avatar_url
    avatar.attached? && url_for(avatar)
  end


  private

  def ensure_username
    return if self.username.present?

    base = if self.name.present?
      self.name.parameterize(separator: "_")
    elsif self.email.present?
      self.email.split("@").first.parameterize(separator: "_")
    else
      "user"
    end

    candidate = base

    while self.class.exists?(username: candidate)
      hex = SecureRandom.hex(2)
      candidate = "#{base}_#{hex}"
    end

    self.username = candidate
  end
end
