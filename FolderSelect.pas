{
  �T�v:
    TFolderSelect �́AWindows�G�N�X�v���[���[���̃t�H���_�I���R���|�[�l���g�ł��B
    �t�H���_�\���� TreeView �`���ŕ\�����A�I���E�V�K�쐬�E���O�ύX�E�폜�Ƃ�����
    ��ʂ�̃t�H���_����ɑΉ����Ă��܂��B

  ��ȋ@�\:
    - ���݂̑I���t�H���_�̎擾�E�w��iSelectFolder �v���p�e�B�j
    - �I���t�H���_�ɐV�����t�H���_���쐬�iSelectFolderCreateNew�j
    - �I���t�H���_�̖��O��ύX�iSelectFolderBeginEdit�j
    - �I���t�H���_�����ݔ��ɍ폜�iSelectFolderDelete�j
    - �O���C�x���g���΁iOnFolderSelect�j

  ����:
    - �G�N�X�v���[���[�ɋ߂����R�ȑ��슴
    - �t���[���ł͂Ȃ� TCustomControl �h���Ōy��
    - �E�N���b�N�����I����Ԃ𐳂����X�V
    - �t�H���_�̓W�J�E�I�����̃C�x���g�딭�΂�}��

  �Ή��o�[�W����:
    Delphi 10 �ȍ~�iTPath �����g�p�j�^�Â��o�[�W�����ɂ��ꕔ�Ή��\

  ���:VRAM�̖��p�t
  ���C�Z���X:MIT
}

unit FolderSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,Vcl.ExtCtrls,
  ShellApi,ShlObj,CommCtrl,System.Win.ComObj,Types,IOUtils,Winapi.ActiveX;

type
  TFolderSelectItem = class(TPersistent)
  private
    { Private �錾 }
    FName        : string;
    FIndexIcon   : Integer;
    FIndexSelect : Integer;
    FIsChild     : Boolean;
    FPIDListFull : PItemIDList;
  public
    { Public �錾 }
    procedure Assign(Source : TPersistent);override;

    function GetFileInfo(pList,pListEx : PItemIDList) : Boolean;
    function GetImageIndex(p : PWideChar;Flags : Cardinal) : Integer;
    function GetImageIcon(pList: PItemIDList) : THandle;

    property Name : string read FName;
    property IndexIcon : Integer   read FIndexIcon;
    property IndexSelect : Integer read FIndexSelect;
    property PIDListFull : PItemIDList read FPIDListFull;
    property IsChild : Boolean read FIsChild;
  end;

//--------------------------------------------------------------------------//
//  �t�H���_��񃊃X�g���Ǘ�����N���X                                      //
//--------------------------------------------------------------------------//
type
	TFolderSelectItems = class(TList)
	private
		{ Private �錾 }
    function GetItems(Index: Integer): TFolderSelectItem;
	public
		{ Public �錾 }
    function Add() : TFolderSelectItem;
    destructor Destroy;override;
    procedure Delete(i : Integer);
    procedure Clear();override;

    function GetFolder(Handle : THandle ; pList   : PItemIDList;FFlags : Cardinal) : Boolean;

		property Items[Index: Integer] : TFolderSelectItem read GetItems ;default;

	end;

type
  TFolderSelect = class(TCustomControl)
  private
    { Private �錾 }
    FFlags            : Cardinal;
    FTreeDir          : TTreeView;                 // �t�H���_�\��TreeView
    FHWDIamge         : THandle;                   // TreeView�Ɏg�p����摜�C���[�W�n���h��
    FClickDisabled    : Boolean;                   // True:�c���[�W�J�^���钆�̓N���b�N�𖳌�
    FFolder           : string;                    // �J�[�\�������킹��t�H���_
    FClickByLeft      : Boolean;                   // ���N���b�N����t���O
    FLastSelectedNode : TTreeNode;                 // �Ō�ɑI�����ꂽ�m�[�h
    FOnFolderSelect   : TNotifyEvent;

    function GetFolderDesktop() : PItemIDList;

    function NodeExpand(Node : TTreeNode) : Boolean;
    //�����̎q�m�[�h�����݂��邩�m�F
    function HasChildNodeByName(Parent: TTreeNode; const Name: string): Boolean;

    function IndexOfFolderName(tns : TTreeNodes;const aFolderName : string) : Integer;
    function TreeNodetoPath(tn : TTreeNode) : string;

    procedure NodeSet(aNode : TTreeNode;d : TFolderSelectItem);
    // �w�肵���t�H���_���S�~���ɑ���
    function ShellDeleteToRecycleBin(const FolderPath: string): Boolean;

    procedure OnTreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure OnTreeDeletion(Sender: TObject; Node: TTreeNode);
    procedure OnTreeClick(Sender: TObject);
    procedure OnTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnTreeEdited(Sender: TObject; Node: TTreeNode; var S: string);

    function GetSelectFolder: string;
    // �w�肵���t�H���_�p�X�ɊY������c���[��W�J���đI����Ԃɂ���
    procedure SetSelectFolder(const Value: string);
    // �t�H���_�����̍ċA�@����
    procedure SetFolderSub(const aPath : string;tnn : TTreeNode;sd : TStringDynArray;aLevel : Integer);
  protected
    procedure DoFolderSelect();
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    // �w�肵���t�H���_��I����Ԃɂ��ăc���[�\��
    procedure ShowFolder(const Folder : string);

    // �I�𒆂̃t�H���_�ɐV�����t�H���_���쐬
    function SelectFolderCreateNew(const BaseName: string = '�V�����t�H���_'): string;
    // �I�𒆂̃t�H���_����ҏW
    procedure SelectFolderBeginEdit;
    // �I�𒆂̃t�H���_���폜
    procedure SelectFolderDelete;
    // �t�H���_��I���A�܂��I������Ă���t�H���_���擾
    property SelectFolder : string read GetSelectFolder write SetSelectFolder;

    // �t�H���_�N���b�N�C�x���g
    property OnFolderSelect  : TNotifyEvent  read FOnFolderSelect write FOnFolderSelect;
  end;

implementation

uses System.StrUtils,System.UITypes;

{ TFolderSelect }

constructor TFolderSelect.Create(AOwner: TComponent);
begin
  inherited;
  FFlags :=  SHCONTF_INCLUDEHIDDEN or SHCONTF_FOLDERS;
  FLastSelectedNode := nil;

  FTreeDir := TTreeView.Create(Self);
  FTreeDir.Parent := Self;
  FTreeDir.Align := alClient;
  FTreeDir.HideSelection := False;
  FTreeDir.OnExpanding := OnTreeExpanding;
  FTreeDir.OnDeletion := OnTreeDeletion;
  FTreeDir.OnClick := OnTreeClick;
  FTreeDir.OnMouseDown := OnTreeMouseDown;
  FTreeDir.OnEdited := OnTreeEdited;

end;

destructor TFolderSelect.Destroy;
begin
  FTreeDir.Free;

  inherited;
end;

// �w�肵���t�H���_��I����Ԃɂ��ăc���[�\��
procedure TFolderSelect.ShowFolder(const Folder: string);
var
  pList    : PItemIDList;
  d : TFolderSelectItem;
  i: Integer;
  n : TTreeNode;
  h : THandle;
  aFolders : TFolderSelectItems;
begin
  FFolder := Folder;

  FTreeDir.Items.BeginUpdate;
  FTreeDir.Items.Clear;
  //FTreeDir.Perform(TVM_SETITEMHEIGHT, 50, 0);
  SendMessage(FTreeDir.Handle,TV_FIRST+27,22,0); // ���X�g�s�̍������w��
  pList := GetFolderDesktop();
  d := TFolderSelectItem.Create;
  try
    FHWDIamge := d.GetImageIcon(pList);
    h := FTreeDir.Handle;
    TreeView_SetImageList(h, FHWDIamge, TVSIL_NORMAL);

    d.GetFileInfo(pList,nil);
  finally
    d.Free;
  end;

  aFolders := TFolderSelectItems.Create;
  try
    aFolders.GetFolder(Handle,nil,FFlags);                    // �f�X�N�g�b�v���̃t�H���_���擾

    for i := 0 to aFolders.Count-1 do begin               // �擾�����t�H���_�����[�v
      d := aFolders[i];                                   // �t�H���_�f�[�^���Q��
      n := FTreeDir.Items.AddChildObject(nil,d.FName,nil); // �f�X�N�g�b�v���Ƀc���[��ǉ�
      NodeSet(n,d);
    end;
    FTreeDir.Items[0].Expand(False);
  finally
    aFolders.Free;
  end;
  FTreeDir.Items.EndUpdate;
  FClickDisabled := False;

  SetSelectFolder(Folder);
end;

// �I�𒆂̃t�H���_�ɐV�����t�H���_���쐬
function TFolderSelect.SelectFolderCreateNew(
  const BaseName: string): string;
var
  ParentNode    : TTreeNode;
  ParentPath    : string;
  NewFolderPath : string;
  i             : Integer;
  d             : TFolderSelectItem;
  NewNode       : TTreeNode;
  PIDL          : PItemIDList;
  Attrs         : ULONG;
begin
  Result := '';

  ParentNode := FTreeDir.Selected;
  if not Assigned(ParentNode) then Exit;

  ParentPath := TreeNodetoPath(ParentNode);  // �� �����֐��őI�𒆃m�[�h�̃t���p�X���擾

  //ParentPath := Folder;

  // �d�����Ȃ��t�H���_���𐶐��i"�V�����t�H���_", "�V�����t�H���_ (2)", ...�j
  i := 0;
  repeat
    if i = 0 then
      NewFolderPath := IncludeTrailingPathDelimiter(ParentPath) + BaseName
    else
      NewFolderPath := IncludeTrailingPathDelimiter(ParentPath) + BaseName + ' (' + IntToStr(i) + ')';
    Inc(i);
  until not DirectoryExists(NewFolderPath);

  // ���ۂɍ쐬
  if not CreateDir(NewFolderPath) then
  begin
    ShowMessage('�t�H���_���쐬�ł��܂���ł����B');
    Exit;
  end;


  PIDL := nil;
  Attrs := 0;
  // PIDL�擾
  if SHParseDisplayName(PChar(NewFolderPath), nil, PIDL, 0, Attrs) <> S_OK then
  begin
    ShowMessage('PIDL���擾�ł��܂���ł����B');
    Exit;
  end;


  // �t�H���_���쐬
  d := TFolderSelectItem.Create;
  d.GetFileInfo(PIDL, nil); // �� PIDL�̂ݎw���OK
  d.FIsChild := False;


  // �m�[�h�ǉ�
  NewNode := FTreeDir.Items.AddChildObject(ParentNode, d.Name, PIDL);
  NodeSet(NewNode, d);  // �� �A�C�R���Ǝq�m�[�h�����Z�b�g

  // �I����ԂɁ��\���X�V
  ParentNode.Expand(False);
  FTreeDir.Selected := NewNode;
  FTreeDir.TopItem := NewNode;

  SelectFolderBeginEdit;

  //SetFolder(NewFolderPath);

  Result := NewFolderPath;
end;

// �I�𒆂̃t�H���_���폜
procedure TFolderSelect.SelectFolderDelete;
var
  Node: TTreeNode;
  FolderPath: string;
begin
  Node := FTreeDir.Selected;
  if not Assigned(Node) then Exit;

  if Node.Level = 0 then
    raise Exception.Create('���[�g�t�H���_�͍폜�ł��܂���B');

  FolderPath := TreeNodetoPath(Node);
  if not DirectoryExists(FolderPath) then
    raise Exception.CreateFmt('�t�H���_�����݂��܂���: %s', [FolderPath]);

  if MessageDlg(Format('"%s" ���폜���܂����H', [FolderPath]),
                mtWarning, [mbYes, mbNo], 0) <> mrYes then
    Exit;

if not ShellDeleteToRecycleBin(FolderPath) then
  raise Exception.Create('�t�H���_�����ݔ��ɑ���܂���ł����B');
  // PIDL ���
  //if Assigned(Node.Data) then
  //  CoTaskMemFree(PItemIDList(Node.Data));

  // �m�[�h�폜 & �e��I��
  if Assigned(Node.Parent) then
    FTreeDir.Selected := Node.Parent;

  FTreeDir.Items.Delete(Node);
end;

// �I�𒆂̃t�H���_����ҏW
procedure TFolderSelect.SelectFolderBeginEdit;
var
  Node: TTreeNode;
begin
  Node := FTreeDir.Selected;
  if Assigned(Node) then
    Node.EditText;
end;

function TFolderSelect.ShellDeleteToRecycleBin(
  const FolderPath: string): Boolean;
var
  OpStruct: TSHFileOpStructW;
  WidePath: array[0..MAX_PATH + 1] of WideChar;
  CleanPath: string;
  PathLen: Integer;
begin
  Result := False;

  // ���S�ȃp�X���`�i������ \ �������j
  CleanPath := ExcludeTrailingPathDelimiter(FolderPath);
  if not DirectoryExists(CleanPath) then
    Exit;

  // �_�u��NULL�I�[�ɂ���
  FillChar(WidePath, SizeOf(WidePath), 0);
  PathLen := Length(CleanPath);
  StringToWideChar(CleanPath, @WidePath[0], MAX_PATH);

  // �����I�� #0#0 ��ǉ��i�K�{�j
  WidePath[PathLen] := #0;
  WidePath[PathLen + 1] := #0;

  ZeroMemory(@OpStruct, SizeOf(OpStruct));
  with OpStruct do
  begin
    Wnd := FTreeDir.Handle; // �L���ȃE�B���h�E�n���h��
    wFunc := FO_DELETE;
    pFrom := @WidePath;
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;

  Result := (SHFileOperationW(OpStruct) = 0) and not OpStruct.fAnyOperationsAborted;
end;


function TFolderSelect.GetSelectFolder: string;
var
  s : string;
  n : TTreeNode;
  pList    : PItemIDList;
  FolderPath: array[0..MAX_PATH] of Char;
begin
  n := FTreeDir.Selected;
  pList := PItemIDList(n.Data);
  SHGetPathFromIDList(pList, FolderPath);
  s := FolderPath;
  result := IncludeTrailingPathDelimiter(s);
end;

function TFolderSelect.GetFolderDesktop: PItemIDList;
begin
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, result);
end;

function TFolderSelect.HasChildNodeByName(Parent: TTreeNode;
  const Name: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not Assigned(Parent) then Exit;

  for i := 0 to Parent.Count - 1 do
  begin
    if CompareText(Parent.Item[i].Text, Name) = 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TFolderSelect.IndexOfFolderName(tns: TTreeNodes;
  const aFolderName: string): Integer;
var
  i: Integer;
  tn : TTreeNode;
  aPath : string;
begin
  result := -1;
  for i := 0 to tns.Count-1 do begin
    tn := tns[i];
    aPath := TreeNodetoPath(tn);

    if CompareText(aPath,aFolderName) = 0 then begin
    //if aPath = aFolderName then begin
      result := i;
      exit;
    end;
  end;
end;

function TFolderSelect.NodeExpand(Node: TTreeNode): Boolean;
var
  p : PItemIDList;
  i : Integer;
  n2 : TTreeNode;
  d : TFolderSelectItem;
  aFolders : TFolderSelectItems;
begin
  aFolders := TFolderSelectItems.Create;
  FTreeDir.Items.BeginUpdate();
  try
    p := PItemIDList(Node.Data);
    aFolders.GetFolder(Handle,p,FFlags);

    for i := 0 to aFolders.Count-1 do begin                      // �擾�����t�H���_�����[�v
      d := aFolders[i];                                          // �t�H���_�f�[�^���Q��
      if HasChildNodeByName(Node, d.Name) then Continue;
      n2 := FTreeDir.Items.AddChildObject(Node,d.FName,nil);     // �f�X�N�g�b�v���Ƀc���[��ǉ�
      NodeSet(n2,d);
      if i mod 10 = 0 then begin                                  // �\���A�C�R�����Z�b�g
        Application.ProcessMessages;
      end;
    end;
    result := True;
  finally
    FTreeDir.Items.EndUpdate();
    aFolders.Free;
  end;
end;

procedure TFolderSelect.NodeSet(aNode: TTreeNode;d : TFolderSelectItem);
begin
  aNode.ImageIndex    := d.FIndexIcon;
  aNode.SelectedIndex := d.FIndexSelect;
  aNode.HasChildren   := d.FIsChild;
  aNode.Data          := d.FPIDListFull;
end;

procedure TFolderSelect.OnTreeClick(Sender: TObject);
var
  CurrentNode: TTreeNode;
begin
  if not FClickByLeft then Exit;                // ���N���b�N�ȊO�͖���

  if FClickDisabled then
  begin
    FClickDisabled := False;                    // 1�N���b�N�������}��
    Exit;
  end;
  FClickByLeft := False;                        // ��x�g�����烊�Z�b�g

  CurrentNode := FTreeDir.Selected;
  if CurrentNode = FLastSelectedNode then Exit; // �I�����ς���ĂȂ���Ζ���

  FLastSelectedNode := CurrentNode;
  DoFolderSelect();                                    // �����ŊO���ʒm
end;

// �c���[��������̃C�x���g
procedure TFolderSelect.OnTreeDeletion(Sender: TObject; Node: TTreeNode);
begin
  FClickDisabled := True;
  if Node <> nil then CoTaskMemFree(Node.Data);
  Node.Data := nil;
end;

// �c���[��W�J�������̃C�x���g
procedure TFolderSelect.OnTreeExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  FClickDisabled := True;
  //if Node.Level = 0 then exit;                          // ���[�g�t�H���_�͏������Ȃ�
  NodeExpand(Node);
end;

procedure TFolderSelect.OnTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  if Button = mbRight then
  begin
    Node := FTreeDir.GetNodeAt(X, Y);
    if Assigned(Node) then
      FTreeDir.Selected := Node;  // �E�N���b�N�Ώۂ�I���ɂ���
  end;
  FClickByLeft := (Button = mbLeft);
end;

procedure TFolderSelect.OnTreeEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  OldPath, NewPath: string;
  PIDL: PItemIDList;
  Attrs: ULONG;
begin
  // ���݂̃p�X���擾
  OldPath := TreeNodetoPath(Node);
  if OldPath = '' then Exit;

  // �V�����p�X���\�z
  NewPath := IncludeTrailingPathDelimiter(ExtractFilePath(ExcludeTrailingPathDelimiter(OldPath))) + S;

  // �ύX���Ȃ� or ���ɑ��݂���Ȃ�L�����Z��
  if SameText(OldPath, NewPath) or DirectoryExists(NewPath) then
  begin
    ShowMessage('���̖��O�͖����܂��͊��ɑ��݂��܂��B');
    Node.Text := ExtractFileName(OldPath); // ���x���߂�
    Exit;
  end;

  // �t�H���_���ύX
  if not RenameFile(OldPath, NewPath) then
  begin
    ShowMessage('�t�H���_����ύX�ł��܂���ł����B');
    Node.Text := ExtractFileName(OldPath); // ���x���߂�
    Exit;
  end;

  // PIDL�̍X�V
  PIDL := nil;
  Attrs := 0;
  if SHParseDisplayName(PChar(NewPath), nil, PIDL, 0, Attrs) = S_OK then
  begin
    CoTaskMemFree(PItemIDList(Node.Data));
    Node.Data := PIDL;
  end
  else
  begin
    ShowMessage('PIDL���X�V�ł��܂���ł����B');
  end;
end;

procedure TFolderSelect.SetSelectFolder(const Value: string);
var
  sd : TStringDynArray;
  i : Integer;
  sf : string;
  tns : TTreeNodes;
  tn : TTreeNode;
begin
  FTreeDir.Items.BeginUpdate;
  try
    sf := IncludeTrailingPathDelimiter(Value);      // �����Ɂu\�v���Ȃ���Βǉ�

    sd := SplitString(sf,'\');                      // �u\�v�ŕ���
    //cnt := High(sd) + 1;                            // �w��p�X�����K�w���擾
    //s := '';
    tns := FTreeDir.Items;                          // �eTreeNodes���Q��
    i := IndexOfFolderName(tns,sd[0]+'\');          // �eTreeNodes�̉��ԂɈ�v����h���C�u�������邩
    if i = -1 then exit;                            // �Ȃ���Ώ������Ȃ�
    tn := tns[i];                                   // �Y��Node���Q��
    SetFolderSub(Value,tn,sd,1);                    // �ċA�@��Node���̊K�w��T��

    tn := FTreeDir.Selected;
    if tn<>nil then begin
      FTreeDir.TopItem := tn;
    end;

    //FTreeDir.SetFocus;                              // �t�H�[�J�X���~�������Ȃ��������Ȃ�

  finally
    FTreeDir.Items.EndUpdate;
  end;
end;

procedure TFolderSelect.SetFolderSub(const aPath: string; tnn: TTreeNode;
  sd: TStringDynArray; aLevel: Integer);
var
  j : Integer;
  tn : TTreeNode;
  s,sPath : string;
begin
  Application.ProcessMessages;
  if aLevel > High(sd) then begin            // �����K�w���w��t�H���_�K�w�𒴂���Ƃ�
    FTreeDir.Selected := tnn;                // ��������Node��I����Ԃ�
    exit;                                    // �����I��
  end;

  sPath := '';                               // ����Path��������
  for j := 0 to aLevel do begin              // ���݂̊K�w���ɊY������Path���쐬
    if sd[j]= '' then begin                  // ����ȏ�Path�������ꍇ
      FTreeDir.Selected := tnn;              // ��������Node��I����Ԃ�
      exit;                                  // �����I��
    end;
    sPath := sPath + sd[j] + '\';            // ����Path�ɒǉ�
  end;

  tnn.Expand(False);                             // ��������Node��W�J���Ă���
  for j := 0 to tnn.Count-1 do begin             // �q�m�[�h�������[�v
    tn := tnn[j];                                // �q�m�[�h�Q��
    s := TreeNodetoPath(tn);                     // �m�[�h����Path���擾
    if CompareText(s,sPath) <> 0 then continue;  // ��v���Ȃ��ꍇ�͎��̃��[�v��
    SetFolderSub(aPath,tn,sd,aLevel+1);          // ���̃m�[�h�̎q�m�[�h����������
    break;                                       // ��x�K�w�ɓ����ďo�Ă��������͏I��������
  end;
end;
function TFolderSelect.TreeNodetoPath(tn: TTreeNode): string;
var
  p : PItemIDList;
  sTbl: array[0..MAX_PATH] of WideChar;
  str : string;
begin
  p := PItemIDList(tn.Data);
  SHGetPathFromIDList(p,sTbl);
  str := sTbl;
  result := IncludeTrailingPathDelimiter(str);
end;



procedure TFolderSelect.DoFolderSelect;
begin
  if Assigned(FOnFolderSelect) then FOnFolderSelect(Self);
end;


{ TFolderSelectItem }

function TFolderSelectItems.Add: TFolderSelectItem;
var
  d : TFolderSelectItem;
begin
  d := TFolderSelectItem.Create;
  inherited Add(d);
  result := d;
end;

procedure TFolderSelectItems.Clear;
var
  i : Integer;
begin
  for i := 0 to Count-1 do begin
    Items[i].Free;
  end;

  inherited;
end;

procedure TFolderSelectItems.Delete(i: Integer);
begin
  Items[i].Free;
  inherited Delete(i);
end;

destructor TFolderSelectItems.Destroy;
begin
  Clear();
  inherited;
end;

function TFolderSelectItems.GetFolder(Handle: THandle;
  pList: PItemIDList; FFlags: Cardinal): Boolean;
var
  pList2,pListC    : PItemIDList;
  Fetched      : Cardinal;
  d : TFolderSelectItem;
  sf  : IShellFolder;
  sf2 : IShellFolder2;
  eList  : IEnumIDList;
  f : Cardinal;
begin
  result := False;

  SHGetDesktopFolder(sf);                        // �f�X�N�g�b�v�̃��[�g�t�H���_���擾
  if pList = nil then begin                      // �f�X�N�g�b�v�̃t�H���_���̏ꍇ
    sf2 := IShellFolder2(sf);                    // �f�X�N�g�b�v�t�H���_���𔽉f
    pListC := nil;                               // ���[�g�t�H���_���� nil
  end
  else begin                                     // �f�X�N�g�b�v�ȊO�̃t�H���_���̏ꍇ
    pListC := ILClone(pList);                    // ���[�g�t�H���_�Ƃ��ăR�s�[
    if sf.BindToObject(pListC, nil,
                      IShellFolder,Pointer(sf2)) <> S_OK then begin // �擾���s�̏ꍇ
      if sf2 <> nil then sf2 := nil;                                // �m�ۂ��������������
      if pListC   <> nil then CoTaskMemFree(pListC);
      exit;
    end;
  end;

  Clear;
  if (sf2.EnumObjects(Handle,FFlags, eList)) <> S_OK then exit;

  while (eList.Next(1, pList2, Fetched) = S_OK) do begin
    d := Add();
    d.GetFileInfo(pList2,pListC);
    f := SFGAO_HASSUBFOLDER;
    sf2.GetAttributesOf(1, pList2, f);                    // �t�H���_�̑������擾
    if (SFGAO_HASSUBFOLDER and f) <> 0 then begin         // ���̉��Ƀt�H���_������ꍇ
      d.FIsChild := True;                                 // �t�H���_���݃t���O���Z�b�g
    end;

  end;
  result := True;
end;

function TFolderSelectItems.GetItems(
  Index: Integer): TFolderSelectItem;
begin
  result := inherited Items[Index];
end;

{ TFolderSelectItem }

procedure TFolderSelectItem.Assign(Source: TPersistent);
var
  a : TFolderSelectItem;
begin
  if Source is TFolderSelectItem then begin
    a := TFolderSelectItem(Source);
    FName    :=  a.FName;
    //FPath    :=  a.FPath;

    FIndexIcon   := a.FIndexIcon;
    FIndexSelect := a.FIndexSelect;
    FIsChild     := a.FIsChild;
    FPIDListFull := a.FPIDListFull;        // FPIDListFull�͉������Ȃ��̂Ń��X�g�������Ă�OK
  end
  else begin
    inherited;
  end;
end;

function TFolderSelectItem.GetFileInfo(pList,
  pListEx: PItemIDList): Boolean;
  // �n���t�@�C�����̓t�@�C������ID���X�g�Ȃ̂� PIDL���w��
const
  FLAG_DISPLAYNAME = SHGFI_DISPLAYNAME or SHGFI_PIDL;
  FLAG_ICON = SHGFI_PIDL or SHGFI_SYSICONINDEX;
  FLAG_ICON_SELECT = SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_OPENICON;
var
  pList2 : PItemIDList;
  aInfo   : TSHFileInfo;
  p : PWideChar;
begin
  pList2 := ILCombine(pListEx, pList);
  FPIDListFull := pList2;

  p := Pointer(pList2);
  FillChar(aInfo, SizeOf(SHFileInfo), #0);
  SHGetFileInfo(p,0, aInfo,SizeOf(aInfo), FLAG_DISPLAYNAME);
  FName := aInfo.szDisplayName;
  FIndexIcon := GetImageIndex(p, FLAG_ICON);
  FIndexSelect := GetImageIndex(p, FLAG_ICON_SELECT);
  result := True;
end;

function TFolderSelectItem.GetImageIcon(pList: PItemIDList): THandle;
const
  FLAG = SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_SMALLICON;
var
  aInfo   : TSHFileInfo;
  p : PWideChar;
begin
  FillChar(aInfo, SizeOf(aInfo), #0);
  p := Pointer(pList);
  result := SHGetFileInfo(p,0,aInfo,SizeOf(aInfo),FLAG);
end;

function TFolderSelectItem.GetImageIndex(p: PWideChar;
  Flags: Cardinal): Integer;
var
  aInfo   : TSHFileInfo;
begin
  FillChar(aInfo, SizeOf(SHFileInfo), #0);
  SHGetFileInfo(p,0,aInfo,SizeOf(aInfo),Flags);
  result := aInfo.iIcon;
end;

end.
