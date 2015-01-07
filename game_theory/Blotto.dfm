object FormBlotto: TFormBlotto
  Left = 0
  Top = 0
  Caption = 'FormBlotto'
  ClientHeight = 457
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    431
    457)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 176
    Top = 11
    Width = 109
    Height = 13
    Caption = #1055#1086#1083#1082#1086#1074' '#1091' '#1087#1088#1086#1090#1080#1074#1085#1080#1082#1072
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 85
    Height = 13
    Caption = #1055#1086#1083#1082#1086#1074' '#1091' '#1041#1083#1086#1090#1090#1086
  end
  object Label3: TLabel
    Left = 8
    Top = 204
    Width = 218
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1086#1087#1090#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1084#1077#1096#1072#1085#1085#1072#1103' '#1089#1090#1088#1072#1090#1077#1075#1080#1103' '#1041#1083#1086#1090#1090#1086
    ExplicitTop = 299
  end
  object Label4: TLabel
    Left = 8
    Top = 35
    Width = 126
    Height = 13
    Caption = #1052#1072#1090#1088#1080#1094#1072' '#1074#1099#1075#1086#1076#1099' '#1041#1083#1086#1090#1090#1086
  end
  object Label5: TLabel
    Left = 8
    Top = 388
    Width = 297
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = #1054#1087#1090#1080#1084#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1080#1075#1088#1099': '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 447
  end
  object Label6: TLabel
    Left = 8
    Top = 54
    Width = 266
    Height = 13
    Caption = 'x - '#1082'-'#1074#1086' '#1087#1086#1083#1082#1086#1074' '#1041#1083#1086#1090#1090#1086', '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093' '#1085#1072' 1'#1081' '#1092#1088#1086#1085#1090';'
  end
  object Label7: TLabel
    Left = 8
    Top = 73
    Width = 290
    Height = 13
    Caption = 'y - '#1082'-'#1074#1086' '#1087#1086#1083#1082#1086#1074' '#1087#1088#1086#1090#1080#1074#1085#1080#1082#1072', '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093' '#1085#1072' 1'#1081' '#1092#1088#1086#1085#1090'.'
  end
  object Label8: TLabel
    Left = 8
    Top = 300
    Width = 242
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1086#1087#1090#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1084#1077#1096#1072#1085#1085#1072#1103' '#1089#1090#1088#1072#1090#1077#1075#1080#1103' '#1087#1088#1086#1090#1080#1074#1085#1080#1082#1072
    ExplicitTop = 395
  end
  object SGProfitMatrix: TStringGrid
    Left = 8
    Top = 90
    Width = 415
    Height = 112
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clGrayText
    ColCount = 2
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
    TabOrder = 0
    ExplicitWidth = 431
    ExplicitHeight = 169
  end
  object EdBlottoNum: TEdit
    Left = 97
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '3'
    OnChange = EdBlottoNumChange
  end
  object UDBlottoNum: TUpDown
    Left = 145
    Top = 8
    Width = 16
    Height = 21
    Associate = EdBlottoNum
    Position = 3
    TabOrder = 2
  end
  object EdEnemyNum: TEdit
    Left = 291
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '3'
    OnChange = EdEnemyNumChange
  end
  object UDEnemyNum: TUpDown
    Left = 339
    Top = 8
    Width = 16
    Height = 21
    Associate = EdEnemyNum
    Position = 3
    TabOrder = 4
  end
  object SGMixedBlottoStrategy: TStringGrid
    Left = 8
    Top = 223
    Width = 415
    Height = 69
    Anchors = [akLeft, akRight, akBottom]
    Color = clGrayText
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
    TabOrder = 5
    ExplicitTop = 318
    ExplicitWidth = 431
    ColWidths = (
      64
      64
      66)
  end
  object BtSolve: TButton
    Left = 8
    Top = 426
    Width = 415
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1056#1077#1096#1080#1090#1100
    TabOrder = 6
    ExplicitTop = 485
    ExplicitWidth = 431
  end
  object SGMixedEnemyStrategy: TStringGrid
    Left = 8
    Top = 319
    Width = 415
    Height = 69
    Anchors = [akLeft, akRight, akBottom]
    Color = clGrayText
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    GradientStartColor = clGray
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
    TabOrder = 7
    ExplicitTop = 414
    ExplicitWidth = 431
    ColWidths = (
      64
      64
      66)
  end
end
