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

  def self.calc_for_donut_graph(posts)
    price_true = posts.where(select_yen: true).sum(:price)
    price_false = posts.where(select_yen: false).sum(:price)
    total_price = (price_true + price_false).to_f
    price_true_percent = (price_true / total_price * 100).floor(1)
    [{ 'good yen!': price_true, 'あと一歩': price_false }, price_true_percent]
  end

  def self.calc_for_column_graph(posts)
    year = Date.today.year
    data_year = posts.where(date_of_post: "#{year}-01-01".."#{year}-12-31")
    price_year = data_year.sum(:price)
    data_year_true = data_year.where(select_yen: true)
    data_year_falce = data_year.where(select_yen: false)

    # 1月
    data_Jan = data_year.where(date_of_post: "#{year}-01-01".."#{year}-01-31")
    price_Jan_true = data_Jan.where(select_yen: true).sum(:price)
    price_Jan_false = data_Jan.where(select_yen: false).sum(:price)

    # 2月
    first_Feb = Date.new(year, 2, 1)
    data_Feb = data_year.where(date_of_post: first_Feb..first_Feb.end_of_month)
    price_Feb_true = data_Feb.where(select_yen: true).sum(:price)
    price_Feb_false = data_Feb.where(select_yen: false).sum(:price)

    # 3月
    data_Mar = data_year.where(date_of_post: "#{year}-03-01".."#{year}-03-31")
    price_Mar_true = data_Mar.where(select_yen: true).sum(:price)
    price_Mar_false = data_Mar.where(select_yen: false).sum(:price)

    # 4月
    data_Apr = data_year.where(date_of_post: "#{year}-04-01".."#{year}-04-30")
    price_Apr_true = data_Apr.where(select_yen: true).sum(:price)
    price_Apr_false = data_Apr.where(select_yen: false).sum(:price)

    # 5月
    data_May = data_year.where(date_of_post: "#{year}-05-01".."#{year}-05-31")
    price_May_true = data_May.where(select_yen: true).sum(:price)
    price_May_false = data_May.where(select_yen: false).sum(:price)

    # 6月
    data_Jun = data_year.where(date_of_post: "#{year}-06-01".."#{year}-06-30")
    price_Jun_true = data_Jun.where(select_yen: true).sum(:price)
    price_Jun_false = data_Jun.where(select_yen: false).sum(:price)

    # 7月
    data_Jul = data_year.where(date_of_post: "#{year}-07-01".."#{year}-07-31")
    price_Jul_true = data_Jul.where(select_yen: true).sum(:price)
    price_Jul_false = data_Jul.where(select_yen: false).sum(:price)

    # 8月
    data_Aug = data_year.where(date_of_post: "#{year}-08-01".."#{year}-08-31")
    price_Aug_true = data_Aug.where(select_yen: true).sum(:price)
    price_Aug_false = data_Aug.where(select_yen: false).sum(:price)

    # 9月
    data_Sep = data_year.where(date_of_post: "#{year}-09-01".."#{year}-09-30")
    price_Sep_true = data_Sep.where(select_yen: true).sum(:price)
    price_Sep_false = data_Sep.where(select_yen: false).sum(:price)

    # 10月
    data_Oct = data_year.where(date_of_post: "#{year}-10-01".."#{year}-10-31")
    price_Oct_true = data_Oct.where(select_yen: true).sum(:price)
    price_Oct_false = data_Oct.where(select_yen: false).sum(:price)

    # 11月
    data_Nov = data_year.where(date_of_post: "#{year}-11-01".."#{year}-11-30")
    price_Nov_true = data_Nov.where(select_yen: true).sum(:price)
    price_Nov_false = data_Nov.where(select_yen: false).sum(:price)

    # 12月
    data_Dec = data_year.where(date_of_post: "#{year}-12-01".."#{year}-12-31")
    price_Dec_true = data_Dec.where(select_yen: true).sum(:price)
    price_Dec_false = data_Dec.where(select_yen: false).sum(:price)

    [
      [
        { name: 'Good yen!',
          data: [['1月', price_Jan_true], ['2月', price_Feb_true], ['3月', price_Mar_true], ['4月', price_Apr_true], ['5月', price_May_true],
                 ['6月', price_Jun_true], ['7月', price_Jul_true], ['8月', price_Aug_true], ['9月', price_Sep_true], ['10月', price_Oct_true], ['11月', price_Nov_true], ['12月', price_Dec_true]] },
        { name: 'あと一歩',
          data: [['1月', price_Jan_false], ['2月', price_Feb_false], ['3月', price_Mar_false], ['4月', price_Apr_false],
                 ['5月', price_May_false], ['6月', price_Jun_false], ['7月', price_Jul_false], ['8月', price_Aug_false], ['9月', price_Sep_false], ['10月', price_Oct_false], ['11月', price_Nov_false], ['12月', price_Dec_false]] }
      ],
      price_year
    ]
  end

  def self.calc_price_month_average(price_month, price_year)
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
      count_month += 1 unless t == 0 && f == 0
    end

    (price_year / count_month)
  end
end
