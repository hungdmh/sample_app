class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  scope :date_desc_posts, ->{order created_at: :desc}
  scope :users_feed, ->(user_ids){where user_id: user_ids}

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.validations.micropost.max_length}
  validates :image,
            content_type: {in: Settings.validations.image_content_type,
                           message: I18n.t("microposts.errors.image_format")},
            size: {less_than: Settings.size.max_file_size.megabytes,
                   message: I18n.t("microposts.errors.size_too_big")}
end
