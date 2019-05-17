# Docs

## Architecture

基本的にプロジェクトの設計方針はMVC(Model View Controller)です。
動作の基本となるファイルが`config.ru`や`main.rb`です。

### Routing

基本となるルーティングも`main.rb`に記載されています。
`main.rb`に書かれているルーティングがURLのプレフィックスとして機能するので、各コントローラーに書かれているルーティングはURLプレフィックスを結合したものが使われます。

```
例:
main.rbに '/users' => UsersController と書かれ、
UsersControllerに get ':id' と書かれていた場合、
最終的なURLは '/users/:id' となります。
```

### Controller

コントローラは`controllers/`以下に配置されます。
基本的に`*_controller.rb`という名前でファイルを作ります。

扱うデータ(model)単位で`UsersController`や`FoodsController`などのコントローラを作るのが好ましいです。

### View

ビューは`views/`以下に配置されます。
基本的に`コントローラ単位/*.erb`(ERBという拡張子)という名前でファイルを作ります。

コントローラ単位とは`UsersController`を作ったなら`users`となります。
最終的に`views/users/`以下に`index.erb`といったファイルを作ることになります。

### Model

モデルは`models`以下に配置されます。
基本的に`DBのテーブル名(単数形).rb`という名前でファイルを作ります。

`users`テーブルがあるなら`user.rb`という具合です。

ここにはDBの値を取り出したり、格納したり、DB操作を定義するファイルです。

