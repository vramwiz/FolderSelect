program FolderSelectSample;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {FormMain},
  FolderSelect in 'FolderSelect.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
