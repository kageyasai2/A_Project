# A_Project

# Getting started

1. Rubyをインストールする。

2. Bundlerをインストールする。

```
$ gem install bundler
```

3. 依存パッケージをインストールする

```
$ bundle install --path vendor/bundle
```

4. gitを設定する

```
$ bundle exec pre-commit install
$ git config pre-commit.ruby "bundle exec ruby"
$ git config pre-commit.checks "[rubocop]"
$ git config pre-commit.rubocop.flags ["-a"]
```

5. DBをセットアップする

```
# OSX / Linux
$ make migrate

# Windows
$ make win/migrate
```

6. サーバーを起動する

```
$ make run
```

サーバーに接続するには`localhost:9292`、または`localhost:任意のポート`にブラウザからアクセスする。
※稼働しているポート番号は`make run`した時、コマンドラインに表示されている。


# Architecture

基本の構造はRailsを参考にMVCパターンで設計されています。
このプロジェクトのMVCパターンやコーディングヘルプは`docs/README.md`に記載されていますので、確認してください。


# Test

テストを実行するには以下のコマンドを実行してください。

```
$ make test
```

このコマンドでは`#{プロジェクトroot}/spec/`以下の`*_spec.rb`を実行します。

テストについての詳細は`spec/README.md`に記載されていますので、テストを書く際に確認してください。
