class Kitten < ApplicationRecord
  
  validates :name, presence: true, length: {maximum: 30}
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 1 }

end