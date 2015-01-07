object SimplexForm: TSimplexForm
  Left = 0
  Top = 0
  Caption = 'SimplexForm'
  ClientHeight = 465
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    424
    465)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1099#1093
  end
  object Label2: TLabel
    Left = 152
    Top = 11
    Width = 55
    Height = 13
    Caption = #1059#1088#1072#1074#1085#1077#1085#1080#1081
  end
  object Label3: TLabel
    Left = 8
    Top = 183
    Width = 91
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1062#1077#1083#1077#1074#1072#1103' '#1092#1091#1085#1082#1094#1080#1103
  end
  object Label4: TLabel
    Left = 8
    Top = 300
    Width = 44
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1056#1077#1096#1077#1085#1080#1077
  end
  object LbFunctValue: TLabel
    Left = 8
    Top = 416
    Width = 408
    Height = 41
    Alignment = taCenter
    Anchors = [akRight, akBottom]
    AutoSize = False
    Caption = #1054#1090#1074#1077#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 35
    Width = 67
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103
  end
  object SGRestrMatrix: TStringGrid
    Left = 8
    Top = 54
    Width = 408
    Height = 123
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clGrayText
    ColCount = 2
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
    TabOrder = 0
  end
  object UpDown1: TUpDown
    Left = 121
    Top = 8
    Width = 16
    Height = 21
    Associate = EdNumVars
    Position = 3
    TabOrder = 1
  end
  object UpDown2: TUpDown
    Left = 264
    Top = 8
    Width = 16
    Height = 21
    Associate = EdNumRestrs
    Position = 3
    TabOrder = 2
  end
  object EdNumVars: TEdit
    Left = 73
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '3'
    OnChange = EdNumVarsChange
  end
  object EdNumRestrs: TEdit
    Left = 216
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 4
    Text = '3'
    OnChange = EdNumRestrsChange
  end
  object SGGoalFunct: TStringGrid
    Left = 8
    Top = 202
    Width = 313
    Height = 69
    Anchors = [akLeft, akRight, akBottom]
    Color = clGrayText
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
    TabOrder = 5
    ColWidths = (
      64
      64
      66)
  end
  object RGToMax: TRadioGroup
    Left = 327
    Top = 202
    Width = 89
    Height = 69
    Anchors = [akRight, akBottom]
    ItemIndex = 0
    Items.Strings = (
      'MAX'
      'min')
    TabOrder = 6
  end
  object SGSolution: TStringGrid
    Left = 8
    Top = 319
    Width = 408
    Height = 74
    Anchors = [akLeft, akRight, akBottom]
    Color = clGrayText
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    GradientStartColor = clGray
    TabOrder = 7
    ColWidths = (
      64
      64
      66)
  end
  object BtSolve: TButton
    Left = 8
    Top = 277
    Width = 408
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1056#1077#1096#1080#1090#1100
    TabOrder = 8
    OnClick = BtSolveClick
  end
  object CBPrimal: TCheckBox
    Left = 304
    Top = 8
    Width = 112
    Height = 17
    Caption = #1055#1088#1103#1084#1072#1103' '#1079#1072#1076#1072#1095#1072
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object CheckBox1: TCheckBox
    Left = 304
    Top = 31
    Width = 112
    Height = 17
    Caption = 'ClearFake'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
end
