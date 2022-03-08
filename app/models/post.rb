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

  def self.calc_for_graph(posts)
    price_true = posts.where(select_yen: true).sum(:price)
    price_false = posts.where(select_yen: false).sum(:price)
    total_price = (price_true + price_false).to_f
    price_true_percent = (price_true / total_price * 100).floor(1)
    return price_for_graph = {'good yen!': price_true, 'あと一歩': price_false}, price_true_percent
  end
end
