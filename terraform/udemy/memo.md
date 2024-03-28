## terraform で作成したリソースを確認する方法

```
terraform state list
```

## 指定されたリソースの詳細を確認する方法

```sh
terraform state show <ADDRESS>
例 terraform state show aws_instance.app
```

## リソースの名前の修正
ソースコードだけを変更すると、terraformとしては、削除→新規の流れを取ってしまう
名前のみを修正するには、tfstateも修正する必要がある。
(terraform上で識別する名称なので、AWS上のリソースには影響を及ぼさない)
### tfstateの修正方法
```
terraform state mv <SOURCE> <DESTINATION> 
// 名前の変更
```

## terraformへのリソースの取り込み
手動で追加したリソースをterraform管理下に取り込む方法  
ソースコードとtfstateの両方への変更が必要

稼働中のリソースからtfstateへインポートする方法
```
terraform import <ADDRESS> <ID>
<ADDRESS> 取り込み先のリソース名
<ID> 取り込みたい稼働中リソースID
```

## terraform管理下から除外する
ソースコードとtfstateの両方から削除する必要がある

tfstateから削除する方法
```
terraform state rm <ADDRESS>
<ADDRESS> 管理対象外にしたいリソース名
```

## terraform で作成したリソースを手動で変更した際、どうやってterraformに反映させるか
1. 下記のコマンドでAWS → tfstateに反映させる

```
terraform refresh
```
2. ソースコードを修正

## リソースの依存関係の確認方法
1. `terraform graph > {FILE_NAME}`でdotというファイル形式に変換
2. dotファイルをGraphvizというソフトで可視化、vscodeのプラグインとして導入できる

dotというファイル形式は画像を描画するためのファイル形式

## EC2内のセットアップで ./installするとき
内部でsourceコマンドを使用して環境変数を反映しているので、install.shを実行する際にはsourceコマンドを使用すること

```
sudo source ./install.sh
```

