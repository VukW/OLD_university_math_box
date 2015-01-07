object InvestitionsForm: TInvestitionsForm
  Left = 0
  Top = 0
  Caption = 'InvestitionsForm'
  ClientHeight = 535
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    348
    535)
  PixelsPerInch = 96
  TextHeight = 13
  object Le_FirmNum: TLabeledEdit
    Left = 200
    Top = 8
    Width = 121
    Height = 21
    EditLabel.Width = 93
    EditLabel.Height = 13
    EditLabel.Caption = #1050'-'#1074#1086' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1081
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 0
    Text = '4'
  end
  object Le_investSum: TLabeledEdit
    Left = 200
    Top = 35
    Width = 121
    Height = 21
    EditLabel.Width = 93
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1091#1084#1084#1072' '#1080#1085#1074#1077#1089#1090#1080#1094#1080#1081
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 1
  end
  object Le_intervalsNum: TLabeledEdit
    Left = 200
    Top = 62
    Width = 121
    Height = 21
    EditLabel.Width = 193
    EditLabel.Height = 13
    EditLabel.Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1085#1072' '#1082'-'#1074#1086' '#1080#1085#1090#1077#1088#1074#1072#1083#1086#1074':'
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 2
    Text = '10'
  end
  object UD_FirmNum: TUpDown
    Left = 321
    Top = 8
    Width = 16
    Height = 21
    Associate = Le_FirmNum
    Min = 2
    Position = 4
    TabOrder = 3
  end
  object UD_IntervalsNum: TUpDown
    Left = 321
    Top = 62
    Width = 16
    Height = 21
    Associate = Le_intervalsNum
    Min = 3
    Position = 10
    TabOrder = 4
  end
  object Bt_PrepairRerevenueGrid: TButton
    Left = 8
    Top = 96
    Width = 329
    Height = 25
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1080#1090#1100' '#1089#1077#1090#1082#1091' '#1076#1086#1093#1086#1076#1085#1086#1089#1090#1080
    TabOrder = 5
    OnClick = Bt_PrepairRerevenueGridClick
  end
  object SG_Revenue: TStringGrid
    Left = 8
    Top = 127
    Width = 332
    Height = 369
    Anchors = [akLeft, akTop, akRight, akBottom]
    Enabled = False
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 6
  end
  object Bt_Solve: TButton
    Left = 8
    Top = 502
    Width = 332
    Height = 25
    Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1087#1090#1080#1084#1072#1083#1100#1085#1086#1077' '#1074#1083#1086#1078#1077#1085#1080#1077' '#1089#1088#1077#1076#1089#1090#1074
    Enabled = False
    TabOrder = 7
    OnClick = Bt_SolveClick
  end
end
