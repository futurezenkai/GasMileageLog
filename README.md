# GasMileageLog
## ■サービス概要
- 車のodoメーターの値と給油したガソリンの量を入れたらその時の燃費がメールで送られてくるwebアプリ
- アカウント作成すると保有する車を登録できる
- アカウントのメールアドレスにメールが送られ、ログとして残すことが出来る

## ■ このサービスへの思い・作りたい理由
- 自分は車やバイクを合わせて3台くらい保有しているが、古い車だとトリップメーターがないものもある
- そういう車は燃費の計算を小さいノートに書き、スマホの電卓アプリを立ち上げ、計算するので面倒である
- なのでメールでログも残すことができ、webアプリに入りサクッとodoメーターの値と給油量を入れると燃費がわかるアプリがあれば少しは楽になるなあと思いアプリを作成しようと思った


## ■ ユーザー層について
トリップメーターがついていないような車を運転している人、というのが主なユーザーそうであるが、普段から燃費計算を行っている人も使ってくれる可能性があると思っている

## ■サービスの利用イメージ
- 燃費計算を電卓でやる必要がなくなる
- また、車のダッシュボード内にボールペンとノートを入れておく必要がなくなる
- 特に夏場はボールペンが熱で壊れてしまうリスクがあるのでそれが軽減できるだけでも大きい

## ■ ユーザーの獲得について
Xなどで告知してみるのがいいかと思っている

## ■ サービスの差別化ポイント・推しポイント
あくまでメールにログを残すことを主眼に置いているので登録後すぐにメールが飛んでくるのは他のサービスではあまりない機能かと思われる

## ■ 機能候補
- アカウント作成機能
- ログイン機能
- 保有自動車登録機能
- 保有自動車一覧表示機能
- 給油時のodoメーターの値と給油量を入力する機能
- 燃費計算機能
- メール通知機能

## ■ 機能の実装方針予定(MVPリリース時に実装)
### 燃費計算機能
概要：
ユーザーが入力したODOメーターの値と給油量から燃費（km/L）を計算する機能。

実装イメージ：
- 計算ロジック：
    - 必要データ: 前回のODOメーター値（DBに保存）、今回のODO値、給油量。
    - 燃費 = （今回のODO値 - 前回のODO値） ÷ 給油量。
- 実装方法：
    - railsで計算。
    - 計算後、データベースに保存（履歴として管理）。
- 使用技術：
    - DB: MySQLなど

### 燃費結果のメール送信
概要：
計算した燃費を登録されたメールアドレスに送信する機能。

実装イメージ：
- メール送信API：
    - 外部メール配信サービスを利用。
    - バックエンドで結果を整形（テンプレートを使用して見やすいレイアウトを作成）。
- メール内容：
    - 今回の燃費（km/L）、ODOメーター値、給油量、計算日時などを表示。
- 使用技術：
    - メールAPI: SendGridを使用予定

### ユーザー認証
概要：
アプリを安全に利用するためのユーザー認証やデータ保護機能。

実装イメージ：
- 認証方法：
    - メール・パスワード認証
- 使用技術：
    - gem Sorceryを使用


### ■機能拡張性確認の観点(本リリース時に実装)
- 燃費のグラフ化
    - 現在の詳細画面ではただのテーブル的なものを表示する予定なので、グラフになるとさらに見栄えが良くなりそうです 
- csv出力機能
    - 今までの記録をcsvにまとめて出力する機能があれば、ダウンロードして各自のスプシなどでデータを扱えそうです
- オイル交換記録や自動車保険の管理(保険証)機能
    - 給油だけでなく、オイル交換の記録や自動車保険の状況が詳細画面内で表示することが出来ればさらに便利になりそうです

### Figma
https://www.figma.com/design/mxnF6lSAHYgemsN6bUff8Y/GasMileageLog?node-id=0-1&p=f&t=18vqlX900Ay8WfJV-0
