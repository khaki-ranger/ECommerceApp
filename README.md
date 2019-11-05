# ECommerceApp
単一オーナー型（非モール型）のネットショップアプリ

## 特徴

1. 1つのプロジェクト内に一般利用者向けと、ショップオーナー向けの2つのアプリを内包しています。
2. データ永続化やユーザー認証等のサーバー側の処理にはFirebaseを使用しています。
3. UI作成には、主に Interface Builder（ストーリーボード）を利用しました。また、UITableViewCell等一部のViewでXIBを使用しています。

## 機能一覧

#### 共通
- ユーザー認証 - Firebase Authentication
- 匿名ユーザー - Firebase Authentication
- パスワード再設定 - Firebase Authentication
- Oauth認証（Facebook認証）
- カテゴリ一覧表示 - UICollectionView
- 商品一覧表示 - UITableView

#### カスタマーサイド
- 複数画像表示 - UICollectionView
- 可変コンテンツ表示 - UIScrollView
- お気に入り商品 - Firebase Firestore
- ショッピングカート、決済 - StripeAPI

#### オーナーサイド
- カテゴリ作成、編集 - Firebase Firestore
- 商品作成、編集 - Firebase Firestore

## 利用イメージ

#### カスタマーサイド

#### オーナーサイド

## 開発環境・使用言語

- Xcode10.3 / Swift5.0.1

## 対応OS（デプロイターゲット）

- iOS10.0

## 使用技術一覧

- サーバー - Firebase
- データベース、永続化 - Firebase Firestore
- 画像ストレージ - Firebase Firestorage
- ユーザー、セッション管理 - Firebase Authentication
- 外部API通信 - Firebase CloudFunctions
- カート、決済 - StripeAPI
- 画像キャッシュ - Kingfisher

## 設計・デザインパターン

- MVC

## UI作成方法

- Interface Builder（ストーリーボード）

## 使用したライブラリ

#### Firebase関連
- Firebase/Core 6.1.0
- Firebase/Auth 6.1.0
- Firebase/Firestore 6.1.0
- Firebase/Storage 6.1.0
- Firebase/Functions 6.1.0

#### その他

- [Stripe 15.0.1](https://github.com/stripe/stripe-ios)
- [IQKeyboardManagerSwift 6.3.0](https://github.com/hackiftekhar/IQKeyboardManager)
- [Kingfisher 4.0](https://github.com/onevcat/Kingfisher)

## 使用API

- [StripeAPI](https://stripe.com/docs/api)

## 自動テスト
