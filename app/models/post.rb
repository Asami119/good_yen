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

  def self.calc_donut(posts)
    price_true = posts.where(select_yen: true).sum(:price)
    price_false = posts.where(select_yen: false).sum(:price)
    total_price = (price_true + price_false).to_f
    price_true_percent = (price_true / total_price * 100).floor(1)
    [{ 'good yen!': price_true, 'あと一歩': price_false }, price_true_percent]
  end

  def self.calc_column(posts)
    year = Date.today.year
    data_year = posts.where(date_of_post: "#{year}-01-01".."#{year}-12-31")
    price_year = data_year.sum(:price)

    # 1月
    month1 = data_year.where(date_of_post: "#{year}-01-01".."#{year}-01-31")
    price_month1_true = month1.where(select_yen: true).sum(:price)
    price_month1_false = month1.where(select_yen: false).sum(:price)

    # 2月
    first_day_month2 = Date.new(year, 2, 1)
    month2 = data_year.where(date_of_post: first_day_month2..first_day_month2.end_of_month)
    price_month2_true = month2.where(select_yen: true).sum(:price)
    price_month2_false = month2.where(select_yen: false).sum(:price)

    # 3月
    month3 = data_year.where(date_of_post: "#{year}-03-01".."#{year}-03-31")
    price_month3_true = month3.where(select_yen: true).sum(:price)
    price_month3_false = month3.where(select_yen: false).sum(:price)

    # 4月
    month4 = data_year.where(date_of_post: "#{year}-04-01".."#{year}-04-30")
    price_month4_true = month4.where(select_yen: true).sum(:price)
    price_month4_false = month4.where(select_yen: false).sum(:price)

    # 5月
    month5 = data_year.where(date_of_post: "#{year}-05-01".."#{year}-05-31")
    price_month5_true = month5.where(select_yen: true).sum(:price)
    price_month5_false = month5.where(select_yen: false).sum(:price)

    # 6月
    month6 = data_year.where(date_of_post: "#{year}-06-01".."#{year}-06-30")
    price_month6_true = month6.where(select_yen: true).sum(:price)
    price_month6_false = month6.where(select_yen: false).sum(:price)

    # 7月
    month7 = data_year.where(date_of_post: "#{year}-07-01".."#{year}-07-31")
    price_month7_true = month7.where(select_yen: true).sum(:price)
    price_month7_false = month7.where(select_yen: false).sum(:price)

    # 8月
    month8 = data_year.where(date_of_post: "#{year}-08-01".."#{year}-08-31")
    price_month8_true = month8.where(select_yen: true).sum(:price)
    price_month8_false = month8.where(select_yen: false).sum(:price)

    # 9月
    month9 = data_year.where(date_of_post: "#{year}-09-01".."#{year}-09-30")
    price_month9_true = month9.where(select_yen: true).sum(:price)
    price_month9_false = month9.where(select_yen: false).sum(:price)

    # 10月
    month10 = data_year.where(date_of_post: "#{year}-10-01".."#{year}-10-31")
    price_month10_true = month10.where(select_yen: true).sum(:price)
    price_month10_false = month10.where(select_yen: false).sum(:price)

    # 11月
    month11 = data_year.where(date_of_post: "#{year}-11-01".."#{year}-11-30")
    price_month11_true = month11.where(select_yen: true).sum(:price)
    price_month11_false = month11.where(select_yen: false).sum(:price)

    # 12月
    month12 = data_year.where(date_of_post: "#{year}-12-01".."#{year}-12-31")
    price_month12_true = month12.where(select_yen: true).sum(:price)
    price_month12_false = month12.where(select_yen: false).sum(:price)

    [
      [
        { name: 'Good yen!',
          data: [['1月', price_month1_true], ['2月', price_month2_true], ['3月', price_month3_true],
                 ['4月', price_month4_true], ['5月', price_month5_true], ['6月', price_month6_true],
                 ['7月', price_month7_true], ['8月', price_month8_true], ['9月', price_month9_true],
                 ['10月', price_month10_true], ['11月', price_month11_true], ['12月', price_month12_true]] },
        { name: 'あと一歩',
          data: [['1月', price_month1_false], ['2月', price_month2_false], ['3月', price_month3_false],
                 ['4月', price_month4_false], ['5月', price_month5_false], ['6月', price_month6_false],
                 ['7月', price_month7_false], ['8月', price_month8_false], ['9月', price_month9_false],
                 ['10月', price_month10_false], ['11月', price_month11_false], ['12月', price_month12_false]] }
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

    (price_year / count_month)
  end
end
