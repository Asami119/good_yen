require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end

  describe '支出記録機能' do
    context '支出が記録（保存）できるとき' do
      it '値がすべて存在すれば保存できる' do
        expect(@post).to be_valid
      end

      it 'Good yen?の選択がデフォルト以外（true）でも保存できる' do
        @post.select_yen = 1
        expect(@post).to be_valid
      end

      it 'メモ①が空でも保存できる' do
        @post.memo1 = ''
        expect(@post).to be_valid
      end

      it 'メモ②が空でも保存できる' do
        @post.memo2 = ''
        expect(@post).to be_valid
      end
    end

    context '支出が記録（保存）できないとき' do
      it '日付が空では保存できない' do
        @post.date_of_post = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Date of post can't be blank")
      end

      it '支出金額が空では保存できない' do
        @post.price = ''
        @post.valid?
        expect(@post.errors.full_messages).to include("Price can't be blank")
      end

      it '支出金額が0では保存できない' do
        @post.price = 0
        @post.valid?
        expect(@post.errors.full_messages).to include('Price は1以上の半角数字のみ入力できます')
      end

      it '支出金額が全角数字では保存できない' do
        @post.price = '１０００'
        @post.valid?
        expect(@post.errors.full_messages).to include('Price は1以上の半角数字のみ入力できます')
      end

      it '支出金額に記号が含まれていると保存できない' do
        @post.price = '1,000'
        @post.valid?
        expect(@post.errors.full_messages).to include('Price は1以上の半角数字のみ入力できます')
      end

      it 'Good yen?の選択がnilでは保存できない' do
        @post.select_yen = nil
        expect(@post).not_to be_valid
      end

      it 'user（記録者）が紐付いていなければ保存できない' do
        @post.user = nil
        @post.valid?
        expect(@post.errors.full_messages).to include('User must exist')
      end
    end
  end
end
