# Secrets

[dotenvx](https://dotenvx.com/) を使用して暗号化された環境変数を管理しています。

## 使い方

### 新しいシークレットを追加

```bash
cd ~/dotfiles/secrets
dotenvx set KEY_NAME "value" -f .env.secrets
```

### 暗号化

```bash
dotenvx encrypt -f .env.secrets
```

### 復号化して実行

```bash
dotenvx run -f .env.secrets -- your-command
```

### シェルに環境変数を読み込む

```bash
eval $(dotenvx get -f .env.secrets --format shell)
```

## ファイル構成

| ファイル | 説明 | Git |
|----------|------|-----|
| `.env.secrets` | 暗号化済みシークレット | ✅ コミット可 |
| `.env.keys` | 秘密鍵 | ❌ コミット禁止 |

## 秘密鍵の管理

`.env.keys` は絶対にGitにコミットしないでください。

推奨される保管場所:
- 1Password / Bitwarden などのパスワードマネージャー
- システムのキーチェーン
