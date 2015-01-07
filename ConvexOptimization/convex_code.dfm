object ConvexForm: TConvexForm
  Left = 0
  Top = 0
  Caption = 'ConvexForm'
  ClientHeight = 700
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  DesignSize = (
    424
    700)
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
    Top = 464
    Width = 91
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1062#1077#1083#1077#1074#1072#1103' '#1092#1091#1085#1082#1094#1080#1103
    ExplicitTop = 264
  end
  object Label4: TLabel
    Left = 8
    Top = 541
    Width = 44
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1056#1077#1096#1077#1085#1080#1077
    ExplicitTop = 341
  end
  object LbFunctValue: TLabel
    Left = 8
    Top = 650
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
    ExplicitTop = 414
  end
  object Label5: TLabel
    Left = 8
    Top = 35
    Width = 67
    Height = 13
    Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103
  end
  object Label6: TLabel
    Left = 344
    Top = 486
    Width = 36
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '-> MAX'
    ExplicitTop = 250
  end
  object Label7: TLabel
    Left = 8
    Top = 363
    Width = 88
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1090#1086#1095#1082#1072
    ExplicitTop = 163
  end
  object Label8: TLabel
    Left = 336
    Top = 363
    Width = 34
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Sigma0'
  end
  object SGRestrMatrix: TStringGrid
    Left = 8
    Top = 54
    Width = 322
    Height = 303
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clGrayText
    ColCount = 1
    DefaultColWidth = 300
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
    Position = 2
    TabOrder = 1
  end
  object UpDown2: TUpDown
    Left = 264
    Top = 8
    Width = 16
    Height = 21
    Associate = EdNumRestrs
    Position = 2
    TabOrder = 2
  end
  object EdNumVars: TEdit
    Left = 73
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '2'
    OnChange = EdNumVarsChange
  end
  object EdNumRestrs: TEdit
    Left = 216
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 4
    Text = '2'
    OnChange = EdNumRestrsChange
  end
  object SGSolution: TStringGrid
    Left = 8
    Top = 562
    Width = 408
    Height = 74
    Anchors = [akLeft, akRight, akBottom]
    Color = clGrayText
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    GradientStartColor = clGray
    TabOrder = 5
    ColWidths = (
      64
      64
      66)
  end
  object BtSolve: TButton
    Left = 8
    Top = 510
    Width = 408
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1056#1077#1096#1080#1090#1100
    TabOrder = 6
    OnClick = BtSolveClick
  end
  object SGRestrMore0: TStringGrid
    Left = 336
    Top = 54
    Width = 80
    Height = 303
    Anchors = [akTop, akRight, akBottom]
    Color = clGrayText
    ColCount = 1
    DefaultColWidth = 50
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
    TabOrder = 7
  end
  object EdCelev: TEdit
    Left = 8
    Top = 483
    Width = 322
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 8
    Text = 'ln(x1+x2+7)-(x2+3*x1)^2+x2'
  end
  object SGx0: TStringGrid
    Left = 8
    Top = 384
    Width = 322
    Height = 74
    Anchors = [akLeft, akRight, akBottom]
    Color = clGrayText
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 9
    ColWidths = (
      64
      64
      66)
  end
  object EdSigma0: TEdit
    Left = 336
    Top = 384
    Width = 80
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 10
    Text = '0,3'
  end
end
