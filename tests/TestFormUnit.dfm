object TestForm: TTestForm
  Left = 0
  Top = 0
  Caption = 'TestForm'
  ClientHeight = 621
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    514
    621)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 13
    Caption = 'OperAr'
  end
  object Label2: TLabel
    Left = 8
    Top = 173
    Width = 34
    Height = 13
    Caption = 'DataAr'
  end
  object Label3: TLabel
    Left = 8
    Top = 326
    Width = 105
    Height = 13
    Caption = 'Source function string'
  end
  object Label4: TLabel
    Left = 8
    Top = 370
    Width = 116
    Height = 13
    Caption = 'Restored function string'
  end
  object SGOperAr: TStringGrid
    Left = 8
    Top = 24
    Width = 498
    Height = 129
    Anchors = [akLeft, akTop, akRight]
    ColCount = 150
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
  end
  object SGDataAr: TStringGrid
    Left = 8
    Top = 192
    Width = 498
    Height = 128
    Anchors = [akLeft, akTop, akRight]
    ColCount = 150
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
  end
  object EdSourceFunct: TEdit
    Left = 8
    Top = 343
    Width = 498
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'EdSourceFunct'
  end
  object EdRestoredFunct: TEdit
    Left = 8
    Top = 389
    Width = 498
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'EdRestoredFunct'
  end
  object BtSourceAnalyze: TButton
    Left = 8
    Top = 423
    Width = 97
    Height = 25
    Caption = 'BtSourceAnalyze'
    TabOrder = 4
    OnClick = BtSourceAnalyzeClick
  end
  object BtRestoreString: TButton
    Left = 111
    Top = 423
    Width = 97
    Height = 25
    Caption = 'BtRestoreString'
    TabOrder = 5
    OnClick = BtRestoreStringClick
  end
  object BtOptimizeCurrent: TButton
    Left = 317
    Top = 423
    Width = 97
    Height = 25
    Caption = 'BtOptimizeCurrent'
    TabOrder = 6
  end
  object BtDerivateSource: TButton
    Left = 214
    Top = 423
    Width = 97
    Height = 25
    Caption = 'BtDerivateCurrent'
    TabOrder = 7
    OnClick = BtDerivateSourceClick
  end
  object BtGenRandom: TButton
    Left = 420
    Top = 423
    Width = 85
    Height = 25
    Caption = 'BtGenRandom'
    TabOrder = 8
    OnClick = BtGenRandomClick
  end
  object MmRandomFunctions: TMemo
    Left = 8
    Top = 480
    Width = 498
    Height = 133
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'MmRandomFunctions')
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object BtShowDerivsIn2D: TButton
    Left = 8
    Top = 449
    Width = 97
    Height = 25
    Caption = 'BtShowDerivsIn2D'
    TabOrder = 10
    OnClick = BtShowDerivsIn2DClick
  end
  object BtReplaceVar: TButton
    Left = 111
    Top = 449
    Width = 200
    Height = 25
    Caption = 'Source: Replace Var-value to restored str'
    TabOrder = 11
    OnClick = BtReplaceVarClick
  end
end
