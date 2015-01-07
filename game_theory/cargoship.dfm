object CargoShipForm: TCargoShipForm
  Left = 0
  Top = 0
  Caption = 'CargoShipForm'
  ClientHeight = 368
  ClientWidth = 701
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    701
    368)
  PixelsPerInch = 96
  TextHeight = 13
  object LbFOpt: TLabel
    Left = 8
    Top = 326
    Width = 175
    Height = 19
    Anchors = [akLeft, akBottom]
    Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 525
    Top = 69
    Width = 163
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1052#1072#1089#1089#1072' '#1079#1072#1075#1088#1091#1078#1072#1077#1084#1099#1093' '#1090#1086#1074#1072#1088#1086#1074', '#1090':'
  end
  object Label1: TLabel
    Left = 8
    Top = 69
    Width = 132
    Height = 13
    Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1090#1086#1074#1072#1088#1072', '#1088#1091#1073'/'#1090':'
  end
  object EdCapacity: TLabeledEdit
    Left = 206
    Top = 24
    Width = 163
    Height = 21
    EditLabel.Width = 114
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1084#1077#1089#1090#1080#1084#1086#1089#1090#1100' '#1089#1091#1076#1085#1072', '#1090':'
    TabOrder = 0
    Text = '100'
  end
  object SGGoodsWeight: TStringGrid
    Left = 8
    Top = 88
    Width = 417
    Height = 215
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 4
    DefaultColWidth = 95
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    RowHeights = (
      24)
  end
  object EdNumGoods: TLabeledEdit
    Left = 8
    Top = 24
    Width = 145
    Height = 21
    EditLabel.Width = 163
    EditLabel.Height = 13
    EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1072#1079#1083#1080#1095#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
    TabOrder = 2
    Text = '3'
    OnChange = EdNumGoodsChange
  end
  object UDNumGoods: TUpDown
    Left = 153
    Top = 24
    Width = 16
    Height = 21
    Associate = EdNumGoods
    Min = 1
    Position = 3
    TabOrder = 3
  end
  object SGDecision: TStringGrid
    Left = 525
    Top = 88
    Width = 163
    Height = 215
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 1
    DefaultColWidth = 110
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 4
    RowHeights = (
      24)
  end
  object BtSolve: TButton
    Left = 440
    Top = 152
    Width = 73
    Height = 41
    Caption = #1056#1077#1096#1080#1090#1100
    TabOrder = 5
    OnClick = BtSolveClick
  end
end
