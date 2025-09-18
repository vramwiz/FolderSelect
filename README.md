# TFolderSelect

`TFolderSelect` は、Windows エクスプローラー風の **フォルダ選択コンポーネント** です。  
TreeView を使用し、選択・新規作成・名前変更・削除などの基本操作をサポートしつつ、  
Delphi 標準の TreeView では制御が難しい **UXの最適化** を実現しています。

---

## 🔧 主な機能

- `SelectFolder`: 選択中のフォルダパスを取得・設定
- `SelectFolderCreateNew`: サブフォルダ作成 ＋ 自動リネームモード
- `SelectFolderBeginEdit`: フォルダ名の編集開始
- `SelectFolderDelete`: ごみ箱にフォルダを削除（SHFileOperation対応）
- `OnFolderSelect`: ユーザーによる明示的な左クリック時のみ発火するイベント

---

## 🚀 使い方

### インストール

1. `FolderSelect.pas` をプロジェクトに追加してください。
2. フォームに配置する場合は以下のようにコードで生成：

```pascal
procedure TFormMain.FormCreate(Sender: TObject);
begin
  FFolderSelect := TFolderSelect.Create(Self);
  FFolderSelect.Parent := Self;
  FFolderSelect.Align := alClient;
  FFolderSelect.OnFolderSelect := OnFolderSelect;
end;

procedure TFormMain.OnFolderSelect(Sender: TObject);
begin
  Caption := FFolderSelect.SelectFolder;
end;
```

---

## 🧪 サンプル：初期表示フォルダを指定する

```pascal
uses System.IOUtils;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FFolderSelect.ShowFolder(TPath.GetDocumentsPath);
end;
```

---

## 📘 API 一覧

| プロパティ / メソッド名      | 説明 |
|-----------------------------|------|
| `SelectFolder: string`      | 現在選択中のフォルダのパスを取得・設定 |
| `SelectFolderCreateNew()`   | サブフォルダを作成し、自動でリネームモードに入る |
| `SelectFolderBeginEdit()`   | 選択中のフォルダの名前編集を開始 |
| `SelectFolderDelete()`      | 選択中のフォルダをごみ箱に送る |
| `ShowFolder(Path: string)`  | 指定フォルダをツリー上で展開・選択状態にする |
| `OnFolderSelect`            | 明示的なユーザー操作で選択されたときに発火 |

---

## 💡 特徴

- Windowsエクスプローラーに近い自然な操作感
- ユーザーの左クリック選択のみをイベントトリガーにできる設計
- ごみ箱送信は `SHFileOperationW` に対応
- `TCustomControl` 派生で柔軟な拡張が可能
- コンテキストメニューとの連携にも対応しやすい構造

---

## ⚙️ 対応環境

- Delphi 10 以降推奨（TPath使用）
- 古いバージョン（Delphi 7～XE）でも代替APIで対応可能

---

## 📄 ライセンス

MIT ライセンス または パブリックドメイン

---

## 👤 作者

VRAMの魔術師

---

## 💬 ご意見・プルリク歓迎！

- バグ報告・機能提案・拡張アイデアなど歓迎します
- GitHub Issues または Discussions にてお気軽にどうぞ
