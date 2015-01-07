object Optim2dForm: TOptim2dForm
  Left = 0
  Top = 0
  Caption = 'Optim2dForm'
  ClientHeight = 351
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    568
    351)
  PixelsPerInch = 96
  TextHeight = 13
  object ItN: TLabel
    Left = 272
    Top = 118
    Width = 3
    Height = 13
    ParentShowHint = False
    ShowHint = True
  end
  object Label1: TLabel
    Left = 278
    Top = 191
    Width = 30
    Height = 13
    Caption = 'KMax:'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label2: TLabel
    Left = 272
    Top = 221
    Width = 37
    Height = 13
    Caption = 'Epsilon:'
    ParentShowHint = False
    ShowHint = True
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 169
    Height = 67
    Hint = #1048#1089#1093#1086#1076#1085#1072#1103' '#1084#1072#1090#1088#1080#1094#1072' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074
    ColCount = 1
    DefaultColWidth = 169
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
    Enabled = False
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
    Left = 272
    Top = 137
    Width = 75
    Height = 25
    Caption = 'It+1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object SGDif: TStringGrid
    Left = 365
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
  object BtLoadtest: TButton
    Left = 353
    Top = 137
    Width = 68
    Height = 25
    Caption = #1076#1083#1103' '#1088#1072#1079#1083#1080#1095#1085#1099#1093' eps'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = BtLoadtestClick
  end
  object Dimension: TEdit
    Left = 365
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
    Left = 405
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
  object E_ItNMax: TEdit
    Left = 380
    Top = 191
    Width = 41
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Text = '10'
  end
  object E_Epsilon: TEdit
    Left = 332
    Top = 218
    Width = 89
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Text = '0,0001'
  end
  object RG_ChooseMethod: TRadioGroup
    Left = 8
    Top = 137
    Width = 241
    Height = 88
    Caption = #1074#1099#1073#1086#1088' '#1084#1077#1090#1086#1076#1072' '#1088#1077#1096#1077#1085#1080#1103
    ItemIndex = 0
    Items.Strings = (
      #1052#1077#1090#1086#1076' '#1076#1080#1093#1086#1090#1086#1084#1080#1080
      #1052#1077#1090#1086#1076' '#1060#1080#1073#1086#1085#1072#1095#1095#1080
      #1052#1077#1090#1086#1076' '#1089#1077#1082#1091#1097#1080#1093)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = RG_ChooseMethodClick
  end
  object ButToEnd: TButton
    Left = 272
    Top = 160
    Width = 75
    Height = 25
    Caption = #1044#1086' '#1082#1086#1085#1094#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = ButToEndClick
  end
  object Bt_beg: TButton
    Left = 353
    Top = 160
    Width = 68
    Height = 25
    Caption = #1085#1072#1095'. '#1088#1072#1089#1095#1077#1090#1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = Bt_begClick
  end
  object GraphCapt_panel: TPanel
    Left = 8
    Top = 240
    Width = 241
    Height = 90
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1075#1088#1072#1092#1080#1082#1086#1074
    TabOrder = 13
    VerticalAlignment = taAlignTop
    DesignSize = (
      241
      90)
    object Label3: TLabel
      Left = 41
      Top = 46
      Width = 63
      Height = 13
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'NumOfLinesX'
    end
    object EdLeftX: TEdit
      Left = 41
      Top = 19
      Width = 49
      Height = 21
      Hint = 'LeftX'
      Anchors = [akLeft, akTop, akRight, akBottom]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'leftX'
    end
    object EdRightX: TEdit
      Left = 157
      Top = 19
      Width = 57
      Height = 21
      Hint = 'RightX'
      Anchors = [akLeft, akTop, akRight, akBottom]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'RightX'
    end
    object EdNoLX: TEdit
      Left = 157
      Top = 46
      Width = 57
      Height = 21
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      Text = 'EdNoLX'
    end
  end
  object MmDecs: TMemo
    Left = 432
    Top = 8
    Width = 129
    Height = 332
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 14
  end
  object CBToMax: TCheckBox
    Left = 272
    Top = 115
    Width = 149
    Height = 17
    Caption = 'To Min'
    TabOrder = 15
    OnClick = CBToMaxClick
  end
  object TabAdditionalInfo: TPageControl
    Left = 272
    Top = 240
    Width = 149
    Height = 90
    ActivePage = TabSheet3
    TabOrder = 16
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      TabVisible = False
      DesignSize = (
        141
        80)
      object Ed1_alpha: TLabeledEdit
        Left = 3
        Top = 16
        Width = 135
        Height = 21
        Anchors = [akLeft, akTop, akRight, akBottom]
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'alpha'
        TabOrder = 0
        Text = '30'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      TabVisible = False
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      TabVisible = False
    end
  end
end
