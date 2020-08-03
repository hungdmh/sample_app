class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.user.email.regex
  USER_PARAMS = %i(name email password password_confirmation).freeze

  attr_accessor :remember_token

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

  before_save :email_to_lowercase

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def email_to_lowercase
    email.downcase!
  end
end
