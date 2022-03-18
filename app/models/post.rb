class Post < ApplicationRecord
  belongs_to :user

  validates :date_of_post, :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'は1以上の半角数字のみ入力できます' }
  validates :select_yen, inclusion: [true, false]

  def self.search_month(current_user_id)
    @posts = Post.where(user_id: current_user_id).where(
      date_of_post: Date.today.beginning_of_month..Date.today.end_of_month
    ).order(date_of_post: 'DESC')
    @sum_price_month = @posts.sum(:price)
    [@posts, @sum_price_month]
  end

  def self.calc_donut(posts)
    price_true = posts.where(select_yen: true).sum(:price)
    price_false = posts.where(select_yen: false).sum(:price)
    total_price = (price_true + price_false).to_f
    price_true_percent = (price_true / total_price * 100).floor(1)
    [{ 'Good yen!': price_true, 'あと一歩': price_false }, price_true_percent]
  end

  def self.calc_column(posts)
    year = Date.today.year
    data_year = posts.where(date_of_post: "#{year}-01-01".."#{year}-12-31")
    price_year = data_year.sum(:price)
    array_true = []
    array_false = []

    1.upto(12) do |i|
      first_day_month = Date.new(year, i, 1)
      month_post = data_year.where(date_of_post: first_day_month..first_day_month.end_of_month)
      sum_price_true = month_post.where(select_yen: true).sum(:price)
      sum_price_false = month_post.where(select_yen: false).sum(:price)

      array_true.push(["#{i}月", sum_price_true])
      array_false.push(["#{i}月", sum_price_false])
    end

    [
      [
        { name: 'Good yen!',
          data: array_true },
        { name: 'あと一歩',
          data: array_false }
      ],
      price_year
    ]
  end

  def self.calc_month_average(price_month, price_year)
    array_true = []
    array_false = []
    count_month = 0

    price_month[0][:data].each do |data|
      array_true << data[1]
    end

    price_month[1][:data].each do |data|
      array_false << data[1]
    end

    array_true.zip(array_false) do |t, f|
      count_month += 1 unless t.zero? && f.zero?
    end

    count_max = [count_month, Date.today.month].max
    (price_year / count_max)
  end
end
