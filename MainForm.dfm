object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #12501#12457#12523#12480#36984#25246
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = MenuPopFolder
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MenuPopFolder: TPopupMenu
    Left = 172
    Top = 163
    object MenuFolderMake: TMenuItem
      Caption = #12501#12457#12523#12480#20316#25104
      OnClick = MenuFolderMakeClick
    end
    object MenuFolderDelete: TMenuItem
      Caption = #12501#12457#12523#12480#21066#38500
      ShortCut = 46
      OnClick = MenuFolderDeleteClick
    end
    object MenuFolderRename: TMenuItem
      Caption = #12501#12457#12523#12480#21517#22793#26356
      ShortCut = 113
      OnClick = MenuFolderRenameClick
    end
    object MenufolderRefresh: TMenuItem
      Caption = #34920#31034#26356#26032
      ShortCut = 116
      OnClick = MenufolderRefreshClick
    end
  end
end
