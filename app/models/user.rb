class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email.regex
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {minimum: Settings.validations.user.name.min_length,
             maximum: Settings.validations.user.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validations.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sentitive: true}

  validates :password, presence: true,
    length: {minimum: Settings.validations.user.password.min_length}

  has_secure_password

  before_save :email_tolowercase

  private

  def email_tolowercase
    email.downcase!
  end
end
