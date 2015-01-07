object Matrix_form: TMatrix_form
  Left = 0
  Top = 0
  Caption = #1052#1072#1090#1088#1080#1094#1099
  ClientHeight = 203
  ClientWidth = 386
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
  object SG: TStringGrid
    AlignWithMargins = True
    Left = 8
    Top = 88
    Width = 169
    Height = 67
    Hint = #1084#1072#1090#1088#1080#1094#1072' '#1040#1083#1100#1092#1072
    ColCount = 4
    DefaultColWidth = 40
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = True
    TabOrder = 1
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
    TabOrder = 2
  end
  object BetaSG: TStringGrid
    Left = 199
    Top = 88
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
    TabOrder = 3
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
    TabOrder = 4
  end
  object ButFromBeg: TButton
    Left = 277
    Top = 130
    Width = 87
    Height = 25
    Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072#1095#1072#1083#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = ButFromBegClick
  end
  object Dimension: TEdit
    Left = 277
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
    Left = 317
    Top = 88
    Width = 16
    Height = 21
    Associate = Dimension
    Min = 1
    ParentShowHint = False
    Position = 4
    ShowHint = True
    TabOrder = 7
    OnClick = DimUDClick
  end
  object e_cons: TEdit
    Left = 277
    Top = 115
    Width = 87
    Height = 21
    TabOrder = 8
    Text = 'e_cons'
  end
  object E_Eps: TEdit
    Left = 278
    Top = 161
    Width = 86
    Height = 21
    TabOrder = 9
    Text = '0,00001'
  end
end
