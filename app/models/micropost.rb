class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  scope :recent_posts, ->{order created_at: :desc}

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.validations.micropost.max_length}
  validates :image,
    content_type: {in: %w(image/jpeg image/gif image/png),
                   message: I18n.t("microposts.errors.image_format")},
    size: {less_than: Settings.size.max_file_size.megabytes,
           message: I18n.t("microposts.errors.size_too_big")}
end
