class User < ApplicationRecord

  def as_json(options={})
    super(only: [:id, :name])
  end

  has_many :kittens, class_name: "Kitten", dependent: :destroy
  has_many :likes, class_name: "Like", foreign_key: "liker_id"
  has_many :liked_kittens, through: :likes, source: :liked, dependent: :destroy

  before_save { email.downcase! }

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

end
