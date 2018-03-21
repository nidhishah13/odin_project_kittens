class Kitten < ApplicationRecord

  def as_json(options={})
    if options.key?(:only) or options.key?(:methods) or options.key?(:include) or options.key?(:except)
      current_user = options[:current_user]
      options.delete(:current_user)
      h = super(options)
      h[:my_kitten] = my_kitten(current_user.id) if current_user.present?
      h[:liked_by_me] = liked_by_me(current_user.id) if current_user.present?
      h
    else
      h = super(only: [:name, :age, :cuteness, :softness, :user_id], 
                methods: [:likes_count, :my_kitten, :liked_by_me] )
    end  
  end

  def likes_count
      self.likes.count
  end

  def my_kitten(current_user_id)
    # binding.pry
    if current_user_id == self.user.id 
      return true
    else
      return false
    end
  end

  def liked_by_me(current_user_id)
    # binding.pry
    if self.likes.find_by(liker_id: current_user_id)
      return true
    else
      return false
    end
  end
  
  def liked_by_user
    liked_by = Like.where(liked_id: self.id)
    liked_by.map(&:liker)
  end

  belongs_to :user
  has_many :likes, class_name: "Like", foreign_key: "liked_id"
  has_many :likers, through: :likes, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 30}
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 1, less_than: 40 }
  validates :cuteness, inclusion: {in: 1..10, message: "cuteness should be between 1 to 10"}
  validates :softness, inclusion: {in: 1..10, message: "cuteness should be between 1 to 10"}

end
