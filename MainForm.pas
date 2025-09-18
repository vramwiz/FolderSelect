unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,FolderSelect, Vcl.Menus;

type
  TFormMain = class(TForm)
    MenuPopFolder: TPopupMenu;
    MenuFolderMake: TMenuItem;
    MenuFolderDelete: TMenuItem;
    MenuFolderRename: TMenuItem;
    MenufolderRefresh: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuFolderMakeClick(Sender: TObject);
    procedure MenuFolderDeleteClick(Sender: TObject);
    procedure MenuFolderRenameClick(Sender: TObject);
    procedure MenufolderRefreshClick(Sender: TObject);
  private
    { Private êÈåæ }
    FFolderSelect : TFolderSelect;
    procedure OnFolderSelect(Sender: TObject);
  public
    { Public êÈåæ }
  end;

var
  FormMain: TFormMain;

implementation

uses System.IOUtils;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FFolderSelect := TFolderSelect.Create(Self);
  FFolderSelect.Parent := Self;
  FFolderSelect.Align := alClient;
  FFolderSelect.OnFolderSelect := OnFolderSelect;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FFolderSelect.Free;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin

  FFolderSelect.ShowFolder(TPath.GetDocumentsPath);
end;

procedure TFormMain.MenuFolderDeleteClick(Sender: TObject);
begin
  FFolderSelect.SelectFolderDelete;
end;

procedure TFormMain.MenuFolderMakeClick(Sender: TObject);
begin
  FFolderSelect.SelectFolderCreateNew();
end;

procedure TFormMain.MenufolderRefreshClick(Sender: TObject);
begin
  FFolderSelect.ShowFolder(FFolderSelect.SelectFolder);
end;

procedure TFormMain.MenuFolderRenameClick(Sender: TObject);
begin
  FFolderSelect.SelectFolderBeginEdit;
end;

procedure TFormMain.OnFolderSelect(Sender: TObject);
begin
  Caption := FFolderSelect.SelectFolder;
end;

end.
