class Like < ApplicationRecord
  belongs_to :liker, class_name: "User", foreign_key: "liker_id"
  belongs_to :liked, class_name: "Kitten", foreign_key: "liked_id"
  
  validates :liked_id, presence: true
  validates :liker_id, presence: true
end
