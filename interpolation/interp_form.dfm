object Interpolation_form: TInterpolation_form
  Left = 0
  Top = 0
  Caption = 'Interpolation_form'
  ClientHeight = 514
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 233
    Top = 222
    Width = 128
    Height = 13
    Caption = #1050'-'#1074#1086' '#1094#1080#1092#1088' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1103#1090#1086#1081
  end
  object InterpBt: TButton
    Left = 8
    Top = 478
    Width = 114
    Height = 25
    Caption = #1048#1085#1090#1077#1088#1087#1086#1083#1080#1088#1086#1074#1072#1090#1100'!'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = InterpBtClick
  end
  object RG_ChooseMethod: TRadioGroup
    Left = 8
    Top = 17
    Width = 281
    Height = 64
    Caption = #1052#1077#1090#1086#1076' '#1080#1085#1090#1077#1088#1087#1086#1083#1080#1088#1086#1074#1072#1085#1080#1103
    ItemIndex = 0
    Items.Strings = (
      #1053#1100#1102#1090#1086#1085#1072
      #1057#1087#1083#1072#1081#1085
      #1051#1072#1075#1088#1072#1085#1078#1072)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = RG_ChooseMethodClick
  end
  object ResEd: TEdit
    Left = 128
    Top = 480
    Width = 161
    Height = 21
    TabOrder = 2
    Text = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  end
  object P_am_UD: TUpDown
    Left = 273
    Top = 195
    Width = 16
    Height = 21
    Associate = Points_am
    Min = 2
    Max = 200
    ParentShowHint = False
    Position = 4
    ShowHint = True
    TabOrder = 3
  end
  object PointsSG: TStringGrid
    Left = 8
    Top = 195
    Width = 209
    Height = 278
    Hint = #1084#1072#1090#1088#1080#1094#1072' '#1090#1086#1095#1077#1082
    Margins.Top = 2
    Margins.Bottom = 2
    ColCount = 2
    DefaultColWidth = 90
    DefaultRowHeight = 15
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor]
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 4
  end
  object PnlProps: TPanel
    Left = 8
    Top = 93
    Width = 281
    Height = 96
    Enabled = False
    TabOrder = 5
    VerticalAlignment = taAlignBottom
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 183
      Height = 13
      Caption = '2'#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103' '#1085#1072' '#1082#1086#1085#1094#1072#1093' '#1086#1090#1088#1077#1079#1082#1072':'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 65
      Height = 13
      Caption = #1083#1077#1074#1099#1081' '#1082#1086#1085#1077#1094
    end
    object Label3: TLabel
      Left = 194
      Top = 48
      Width = 71
      Height = 13
      Caption = #1087#1088#1072#1074#1099#1081' '#1082#1086#1085#1077#1094
    end
    object Ed2der_left: TEdit
      Left = 8
      Top = 27
      Width = 106
      Height = 21
      Hint = #1074#1090#1086#1088#1072#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103' '#1085#1072' '#1083#1077#1074#1086#1084' '#1082#1086#1085#1094#1077' '#1086#1090#1088#1077#1079#1082#1072
      TabOrder = 0
      Text = 'Ed2der_left'
    end
    object Ed2Der_right: TEdit
      Left = 144
      Top = 27
      Width = 121
      Height = 21
      Hint = #1074#1090#1086#1088#1072#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103' '#1085#1072' '#1087#1088#1072#1074#1086#1084' '#1082#1086#1085#1094#1077' '#1086#1090#1088#1077#1079#1082#1072
      TabOrder = 1
      Text = 'Ed2Der_right'
    end
  end
  object CbOpenBrts: TCheckBox
    Left = 16
    Top = 167
    Width = 106
    Height = 17
    Caption = #1056#1072#1089#1082#1088#1099#1090#1100' '#1089#1082#1086#1073#1082#1080
    TabOrder = 6
  end
  object SpnEdFloat: TSpinEdit
    Left = 233
    Top = 263
    Width = 56
    Height = 22
    MaxValue = 50
    MinValue = 0
    TabOrder = 7
    Value = 5
  end
  object Points_am: TEdit
    Left = 237
    Top = 195
    Width = 40
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Text = '4'
    OnChange = Points_amChange
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 272
    Top = 8
  end
end
