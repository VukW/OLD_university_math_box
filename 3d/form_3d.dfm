object Form_Paint3d: TForm_Paint3d
  Left = 0
  Top = 0
  Caption = 'Form_Paint3d'
  ClientHeight = 742
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  DesignSize = (
    729
    742)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 540
    Height = 744
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object Label1: TLabel
    Left = 570
    Top = 341
    Width = 65
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Stretch Koefs'
  end
  object Label2: TLabel
    Left = 570
    Top = 441
    Width = 22
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Time'
  end
  object EdZumKoef: TEdit
    Left = 618
    Top = 96
    Width = 65
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 0
    Text = 'EdZumKoef'
  end
  object ButRepnt: TButton
    Left = 584
    Top = 56
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Repaint objects'
    TabOrder = 1
    OnClick = ButRepntClick
  end
  object ListBxFunc: TCheckListBox
    Left = 570
    Top = 138
    Width = 151
    Height = 111
    OnClickCheck = ListBxFuncClickCheck
    Anchors = [akTop, akRight]
    ItemHeight = 13
    PopupMenu = LIstBxFuncPP
    TabOrder = 2
    OnContextPopup = ListBxFuncContextPopup
    OnKeyDown = ListBxFuncKeyDown
  end
  object OffsetsCheck: TCheckBox
    Left = 590
    Top = 18
    Width = 139
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Offsets'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = FormResize
  end
  object BtSave2File: TButton
    Left = 570
    Top = 255
    Width = 151
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Save set 2 file...'
    TabOrder = 4
    OnClick = BtSave2FileClick
  end
  object BtLoad4file: TButton
    Left = 570
    Top = 286
    Width = 151
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Load from file...'
    TabOrder = 5
    OnClick = BtLoad4fileClick
  end
  object EdMx: TEdit
    Left = 570
    Top = 360
    Width = 151
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 6
    Text = '1'
  end
  object EdMy: TEdit
    Left = 570
    Top = 387
    Width = 151
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 7
    Text = '1'
  end
  object EdMz: TEdit
    Left = 570
    Top = 414
    Width = 151
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 8
    Text = '1'
  end
  object ScrollTIme: TScrollBar
    Left = 570
    Top = 487
    Width = 151
    Height = 17
    Anchors = [akTop, akRight]
    PageSize = 0
    TabOrder = 9
    OnChange = ScrollTImeChange
  end
  object EdTime: TEdit
    Left = 570
    Top = 460
    Width = 151
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 10
    Text = '0'
  end
  object EdVelocity: TLabeledEdit
    Left = 570
    Top = 536
    Width = 151
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 106
    EditLabel.Height = 13
    EditLabel.Caption = 'Velocity (time per sec)'
    TabOrder = 11
    OnChange = EdVelocityChange
  end
  object BtStartTimer: TButton
    Left = 570
    Top = 563
    Width = 79
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Animate!'
    TabOrder = 12
    OnClick = BtStartTimerClick
  end
  object Button1: TButton
    Left = 570
    Top = 608
    Width = 151
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Button1'
    TabOrder = 13
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 20
    OnTimer = Timer1Timer
    Left = 8
    Top = 32
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
  end
  object timer_LbxRep: TTimer
    Interval = 100
    OnTimer = timer_LbxRepTimer
    Left = 48
  end
  object LoadFromSavedDlg: TOpenDialog
    Left = 88
  end
  object Timer_animate: TTimer
    Interval = 20
    OnTimer = Timer_animateTimer
    Left = 8
    Top = 88
  end
end
