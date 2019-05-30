# Kaomojic

各種 IME 用の顔文字辞書です。  
ATOK, Google IME に対応しています。


## Contribution

### 新しい顔文字を追加する

1. このリポジトリを Fork します。
2. `fixtures/kaomojic.csv` へ顔文字を追加します。
3. Fixture を整形します ; `./bin/runner.sh OrderFixture Kaomojic` を実行します。
4. 変更を commit し、 GitHub へ Push します。
5. Pull Request を送信します。


### 新しい IME に対応する

1. このリポジトリを Fork します。
2. `lib/Kaomojic/Tasks/Generators` 以下に `Atok.pm` のようなファイルを作成します。
   1. Interface: `function run(fixture: string, dist: string, aliased: string = 'かお'): void`
3. `./bin/runner.sh Generators::Atok Kaomojic ./dist/atok` を実行し、対応したい IME で実際に読み込みます。
4. `.circleci/config.yml` に Job を追加します。
5. 変更を commit し、 GitHub へ Push します。
6. Pull Request を送信します。


## LICENSE

リポジトリ全体は MIT ですが、 `fixtures` 以下に関しては Public Domain です。
