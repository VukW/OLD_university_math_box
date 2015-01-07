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
    Height = 453
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object ListBxFunc: TCheckListBox
    Left = 8
    Top = 463
    Width = 601
    Height = 85
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
    Top = 492
    Width = 151
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save set 2 file...'
    TabOrder = 1
  end
  object BtLoad4file: TButton
    Left = 625
    Top = 523
    Width = 151
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Load from file...'
    TabOrder = 2
    OnClick = BtLoad4fileClick
  end
  object BtSavePict: TButton
    Left = 625
    Top = 461
    Width = 151
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save Picture...'
    TabOrder = 3
    OnClick = BtSavePictClick
  end
  object Ed_y: TLabeledEdit
    Left = 24
    Top = 568
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 6
    EditLabel.Height = 13
    EditLabel.Caption = 'y'
    TabOrder = 4
    Text = '1'
  end
  object Ed_k2: TLabeledEdit
    Left = 118
    Top = 568
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 11
    EditLabel.Height = 13
    EditLabel.Caption = 'k2'
    TabOrder = 5
    Text = '1'
  end
  object Ed_P01_N: TLabeledEdit
    Left = 248
    Top = 568
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 121
    EditLabel.Height = 13
    EditLabel.Caption = #1050'-'#1074#1086' '#1088#1072#1079#1073#1080#1077#1085#1080#1081' '#1087#1086' P_01'
    TabOrder = 6
    Text = '10'
  end
  object Ed_d: TLabeledEdit
    Left = 24
    Top = 608
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 6
    EditLabel.Height = 13
    EditLabel.Caption = 'd'
    TabOrder = 7
    Text = '1'
  end
  object Ed_b_max: TLabeledEdit
    Left = 248
    Top = 607
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 65
    EditLabel.Height = 13
    EditLabel.Caption = '0<beta<L, L:'
    TabOrder = 8
    Text = '10'
  end
  object Ed_k3: TLabeledEdit
    Left = 118
    Top = 607
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 11
    EditLabel.Height = 13
    EditLabel.Caption = 'k3'
    TabOrder = 9
    Text = '1'
  end
  object Bt_p1_p2_p3: TButton
    Left = 375
    Top = 549
    Width = 234
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1043#1088#1072#1092#1080#1082#1080' p1, p2, p3(b) '#1087#1088#1080' '#1088#1072#1079#1083#1080#1095#1085#1099#1093' P_01'
    TabOrder = 10
    OnClick = Bt_p1_p2_p3Click
  end
  object Bt_D: TButton
    Left = 375
    Top = 576
    Width = 234
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1043#1088#1072#1092#1080#1082' D(b) '#1087#1088#1080' '#1088#1072#1079#1083#1080#1095#1085#1099#1093' P_01'
    TabOrder = 11
    OnClick = Bt_DClick
  end
  object Bt_delta: TButton
    Left = 375
    Top = 603
    Width = 234
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1043#1088#1072#1092#1080#1082' delta(d) '#1087#1088#1080' b=1'
    TabOrder = 12
    OnClick = Bt_deltaClick
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
