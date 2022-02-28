# テーブル設計

## users テーブル

| Column             | Type    | Options                   |
| ------------------ | ------- | ------------------------- |
| nickname           | string  | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |

### Association

- has_many :posts

## posts テーブル

| Column             | Type        | Options                        |
| ------------------ | ----------- | ------------------------------ |
| date_of_post       | date        | null: false                    |
| select_yen         | boolean     | null: false                    |
| price              | integer     | null: false                    |
| memo_1             | string      | null: true                     |
| memo_2             | string      | null: true                     |
| user               | references  | null: false, foreign_key: true |

### Association

- belongs_to :user
