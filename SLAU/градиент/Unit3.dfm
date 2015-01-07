object Form3: TForm3
  Left = 0
  Top = 0
  Caption = #1088#1077#1096#1077#1085#1080#1077' '#1057#1051#1059' '#1084#1077#1090#1086#1076#1086#1084' '#1047#1077#1081#1076#1077#1083#1103
  ClientHeight = 250
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ItN: TLabel
    Left = 277
    Top = 128
    Width = 3
    Height = 13
    ParentShowHint = False
    ShowHint = True
  end
  object Label1: TLabel
    Left = 277
    Top = 181
    Width = 30
    Height = 13
    Caption = 'KMax:'
  end
  object Label2: TLabel
    Left = 277
    Top = 216
    Width = 37
    Height = 13
    Caption = 'Epsilon:'
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 169
    Height = 67
    Hint = #1048#1089#1093#1086#1076#1085#1072#1103' '#1084#1072#1090#1088#1080#1094#1072' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074
    ColCount = 4
    DefaultColWidth = 40
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 0
  end
  object BSG: TStringGrid
    Left = 199
    Top = 8
    Width = 50
    Height = 67
    ColCount = 1
    DefaultColWidth = 45
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 1
  end
  object XSG: TStringGrid
    Left = 277
    Top = 8
    Width = 50
    Height = 67
    ColCount = 1
    DefaultColWidth = 45
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 2
  end
  object ItNext: TButton
    Left = 277
    Top = 150
    Width = 75
    Height = 25
    Caption = 'It+1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = ItNextClick
  end
  object SGDif: TStringGrid
    Left = 384
    Top = 8
    Width = 61
    Height = 67
    ColCount = 1
    DefaultColWidth = 61
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 4
  end
  object ButFromBeg: TButton
    Left = 358
    Top = 150
    Width = 87
    Height = 25
    Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072#1095#1072#1083#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = ButFromBegClick
  end
  object Dimension: TEdit
    Left = 384
    Top = 88
    Width = 40
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = '4'
    OnChange = DimensionChange
    OnKeyPress = DimensionKeyPress
  end
  object DimUD: TUpDown
    Left = 424
    Top = 88
    Width = 15
    Height = 21
    Associate = Dimension
    Min = 1
    ParentShowHint = False
    Position = 4
    ShowHint = True
    TabOrder = 7
    OnClick = DimUDClick
  end
  object E_ItNMax: TEdit
    Left = 404
    Top = 181
    Width = 41
    Height = 21
    TabOrder = 8
    Text = '10'
  end
  object E_Epsilon: TEdit
    Left = 356
    Top = 213
    Width = 89
    Height = 21
    TabOrder = 9
    Text = '0,0001'
  end
end
