class Post < ApplicationRecord
  belongs_to :user

  validates :date_of_post, :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は1以上の半角数字のみ入力できます' }
  validates :select_yen, inclusion: [true, false]

  def self.search_month(current_user_id)
    Post.where(
      user_id: current_user_id
    ).where(date_of_post: Date.today.beginning_of_month..Date.today.end_of_month).order(date_of_post: 'DESC')
  end
end
