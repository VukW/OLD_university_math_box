object Form_2d: TForm_2d
  Left = 0
  Top = 0
  Caption = 'Form_2d'
  ClientHeight = 636
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    784
    636)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 2
    Width = 768
    Height = 509
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object ListBxFunc: TCheckListBox
    Left = 8
    Top = 517
    Width = 601
    Height = 111
    OnClickCheck = ListBxFuncClickCheck
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    PopupMenu = LIstBxFuncPP
    TabOrder = 0
    OnContextPopup = ListBxFuncContextPopup
    OnDblClick = ListBxFuncDblClick
    OnKeyDown = ListBxFuncKeyDown
  end
  object BtSave2File: TButton
    Left = 625
    Top = 564
    Width = 151
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save set 2 file...'
    TabOrder = 1
  end
  object BtLoad4file: TButton
    Left = 625
    Top = 595
    Width = 151
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Load from file...'
    TabOrder = 2
    OnClick = BtLoad4fileClick
  end
  object BtSavePict: TButton
    Left = 625
    Top = 533
    Width = 151
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save Picture...'
    TabOrder = 3
    OnClick = BtSavePictClick
  end
  object LIstBxFuncPP: TPopupMenu
    Left = 8
    object PPCreate: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1092#1091#1085#1082#1094#1080#1102
      OnClick = PPCreateClick
    end
    object N1: TMenuItem
      Caption = '-'
      Enabled = False
    end
    object PPEdit: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100'..'
      OnClick = PPEditClick
    end
    object PPDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = PPDeleteClick
    end
    object PPDeleteAll: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1105
      OnClick = PPDeleteAllClick
    end
  end
  object timer_LbxRep: TTimer
    Interval = 100
    OnTimer = timer_LbxRepTimer
    Left = 48
  end
  object LoadFromSavedDlg: TOpenDialog
    Left = 88
  end
  object TGraphRepaint: TTimer
    Interval = 50
    OnTimer = TGraphRepaintTimer
    Left = 136
  end
  object SavePictureDlg: TSavePictureDialog
    Left = 176
  end
end
