# アプリケーション名
かんたん支出管理 yen!
<br><br>

# アプリケーション概要
yen!（エン）は、手軽に家計簿をつけたい方向けの、<b>かんたん支出管理</b>サービスです。
支出を前向きにとらえ、<b>豊かに実ったお金</b>にしていく仕組みが特徴です。<br><br>

# URL
https://good-yen.herokuapp.com/
<br><br>

# テスト用アカウント
- メールアドレス: test@yahoo.co.jp
- パスワード: etok01
<br><br>

# 利用方法
## 支出記録
1. トップページからユーザー新規登録を行う
2. ヘッダーの「記録する」ボタンから支出記録ページに遷移
3. 必要項目（日付・金額・Good yenか否か）を入力し、「記録する」ボタンを押す
<br><br>

## 支出検索
1. ヘッダーの「振り返る」ボタンから支出検索ページに遷移
2. 検索条件を入力し、「一覧」ボタンを押す

＊指定の絞り込み条件で、「グラフ表示」「CSV出力」も可能です。
<br><br>

# アプリケーションを作成した背景
「お金をもっと豊かに使いたい」という思いが出発点です。
<br><br>
従来の家計簿や家計簿アプリには、以下の点で違和感を覚えていました。
- 「収入」と「支出」がセットになっているため、「支出=マイナス」と捉えやすい。また、支出を把握したいと思うのは、固定収入がある人ばかりではない
- 支出の分類名（カテゴリの分け方）が複雑な場合、記録するハードルが一つ増えてしまう。支出を把握する上で、詳細な分類分けは必ずしも必要ではない
<br><br>

以上のことから自作のExcelシートを印刷し、手書きで支出を記録していましたが、その場合にも下記のような課題がありました。
- リアルタイムでの支出記録ができない
- 金額の手計算が負担。ミスも起こりやすい
<br><br>

そのような経緯に加え、「お金をもっと豊かに使いたい」という思いから、以下の特徴を備えた支出記録ツールの開発を思い立ちました。
- 「支出」のみを対象とする（収入については、取り扱わない）
- 分類名の入力は、任意かつ自由記述とする
- 「いいお金の使い方だったか？」という項目を設け、「お金を実り豊かに使えた」という満足感や、自分にとっての「いい支出」について考えるきっかけを作る
<br><br>

「家計簿が始められない、続かない」「お金の使い方を見直す機会が少ない」方の「面倒」や「ハードルが高い」といった課題を解消し、支出を「豊かに実ったお金」にしていく一助になればと考えています。
<br><br>

# ユーザーストーリー
[![Image from Gyazo](https://i.gyazo.com/2d0701ae033724a3b0b06dd8d518b9a2.jpg)](https://gyazo.com/2d0701ae033724a3b0b06dd8d518b9a2)
<br><br>

# 洗い出した要件
[要件を定義したシート](https://docs.google.com/spreadsheets/d/1HpywS1N54deJ9mjSwYvUwvIJbJZsYJq7xjoyW3L30zs/edit#gid=1785908763)
<br><br>

# 各機能のイメージ（トップページより抜粋）
[![Image from Gyazo](https://i.gyazo.com/96847db22421d25901f7c7c1a2258210.jpg)](https://gyazo.com/96847db22421d25901f7c7c1a2258210)

[![Image from Gyazo](https://i.gyazo.com/d489354bf1c05d70a15eccb25abdec2e.jpg)](https://gyazo.com/d489354bf1c05d70a15eccb25abdec2e)

[![Image from Gyazo](https://i.gyazo.com/f8a20f742dd81abe6fb6c95bf425a121.jpg)](https://gyazo.com/f8a20f742dd81abe6fb6c95bf425a121)
<br><br>

# 実装予定の機能
- 結合テスト
- （可能であれば）モデル・各メソッドのリファクタリング
<br><br>

# データベース設計
[![Image from Gyazo](https://i.gyazo.com/977891a2c20f6d13db719273978991ac.png)](https://gyazo.com/977891a2c20f6d13db719273978991ac)
<br><br>

# 画面遷移図
[![Image from Gyazo](https://i.gyazo.com/ebb88026c1ab4fe4255b3e778befafa6.jpg)](https://gyazo.com/ebb88026c1ab4fe4255b3e778befafa6)
＊ハイライトした主要2ページのみ、お子様のご利用を想定した「ひらがな表記」ページを設けております。
<br><br>

# 開発環境
フロントエンド
- HTML/CSS
- JavaScript
- chart.js

バックエンド
- Ruby（2.6.5）
- Ruby on Rails（6.0.0）

データベース
- MySQL2（0.4.4）

インフラ
- Heroku

テスト
- RSpec

テキストエディタ
- Visual Studio Code

タスク管理
- GitHub
<br><br>

# ローカルでの動作方法
以下のコマンドを順に実行してください。<br>
% git clone https://good-yen.herokuapp.com/<br>
% cd xxxxxx（＊任意のディレクトリ名をご指定ください）<br>
% bundle install<br>
% yarn install<br>
<br><br>

# 工夫したポイント
## 「ユーザー目線」
幅広い層にアピールできるシンプルな設計・デザインを念頭に、工数を極力減らした記録ページ、共有したくなるグラフ化機能や「思い出 Good yen!」ページなど、継続につながる仕組みを用意しました。
<br><br>

一方で、「Good yen?（いいお金の使い方だったか？）」という必須項目やデータのCSV出力など、より良い支出を考えるきっかけや、分析の材料を提供できるような機能も実装しました。

<br><br>

## 「考え抜く」
スキルや経験不足により実装できる機能が限られるなか、どのような要件定義・ページ遷移にすることが「ベストな課題解決策となるか」を一貫して考え抜きました。
<br><br>

結果として、「かんたん・シンプル」でありつつも発展的な分析が可能で、「豊かなお金」について内省するきっかけをも作ることができる、一つの提案ができたかと思います。
