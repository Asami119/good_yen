class Post < ApplicationRecord
  belongs_to :user

  validates :date_of_post, :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は1以上の半角数字のみ入力できます' }
  validates :select_yen, inclusion: [true, false]
end
