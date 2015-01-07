object OptimNdForm: TOptimNdForm
  Left = 0
  Top = 0
  Caption = 'Optim2dForm'
  ClientHeight = 260
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    560
    260)
  PixelsPerInch = 96
  TextHeight = 13
  object ItN: TLabel
    Left = 272
    Top = 38
    Width = 3
    Height = 13
    Anchors = [akTop, akRight]
    ParentShowHint = False
    ShowHint = True
  end
  object Label1: TLabel
    Left = 278
    Top = 111
    Width = 30
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'KMax:'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label2: TLabel
    Left = 272
    Top = 141
    Width = 37
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Epsilon:'
    ParentShowHint = False
    ShowHint = True
  end
  object XSG: TStringGrid
    Left = 494
    Top = 8
    Width = 58
    Height = 242
    Anchors = [akTop, akRight, akBottom]
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
    TabOrder = 0
  end
  object ItNext: TButton
    Left = 272
    Top = 57
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'It+1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object X0SG: TStringGrid
    Left = 427
    Top = 8
    Width = 61
    Height = 242
    Anchors = [akTop, akRight, akBottom]
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
    TabOrder = 2
  end
  object BtLoadtest: TButton
    Left = 353
    Top = 57
    Width = 68
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1076#1083#1103' '#1088#1072#1079#1083#1080#1095#1085#1099#1093' eps'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object Dimension: TEdit
    Left = 365
    Top = 8
    Width = 40
    Height = 21
    Anchors = [akTop, akRight]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Text = '2'
    OnChange = DimensionChange
    OnKeyPress = DimensionKeyPress
  end
  object DimUD: TUpDown
    Left = 405
    Top = 8
    Width = 16
    Height = 21
    Anchors = [akTop, akRight]
    Associate = Dimension
    Min = 1
    ParentShowHint = False
    Position = 2
    ShowHint = True
    TabOrder = 5
    OnClick = DimUDClick
  end
  object E_ItNMax: TEdit
    Left = 380
    Top = 111
    Width = 41
    Height = 21
    Anchors = [akTop, akRight]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = '10'
  end
  object E_Epsilon: TEdit
    Left = 332
    Top = 138
    Width = 89
    Height = 21
    Anchors = [akTop, akRight]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = '0,0001'
  end
  object RG_ChooseMethod: TRadioGroup
    Left = 8
    Top = 35
    Width = 241
    Height = 211
    Anchors = [akLeft, akTop, akRight]
    Caption = #1074#1099#1073#1086#1088' '#1084#1077#1090#1086#1076#1072' '#1088#1077#1096#1077#1085#1080#1103
    ItemIndex = 0
    Items.Strings = (
      #1042#1088#1072#1097#1072#1102#1097#1080#1093#1089#1103' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1081
      #1041#1088#1086#1081#1076#1077#1085#1072'-'#1060#1083#1077#1090#1095#1077#1088#1072'-'#1064#1077#1085#1085#1086
      #1053#1100#1102#1090#1086#1085#1072
      #1057#1083#1091#1095#1072#1081#1085#1086#1075#1086' '#1087#1086#1080#1089#1082#1072)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = RG_ChooseMethodClick
  end
  object ButToEnd: TButton
    Left = 272
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1044#1086' '#1082#1086#1085#1094#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = ButToEndClick
  end
  object Bt_beg: TButton
    Left = 353
    Top = 80
    Width = 68
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1085#1072#1095'. '#1088#1072#1089#1095#1077#1090#1099
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
  end
  object CBToMax: TCheckBox
    Left = 272
    Top = 35
    Width = 149
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'To Min'
    TabOrder = 11
    OnClick = CBToMaxClick
  end
  object TabAdditionalInfo: TPageControl
    Left = 272
    Top = 160
    Width = 149
    Height = 90
    ActivePage = TabSheet4
    Anchors = [akTop, akRight]
    TabOrder = 12
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
      OnContextPopup = TabSheet3ContextPopup
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      TabVisible = False
      ExplicitTop = 24
      ExplicitHeight = 62
      object Ed4_RandDirectionsNum: TLabeledEdit
        Left = 3
        Top = 24
        Width = 121
        Height = 21
        EditLabel.Width = 128
        EditLabel.Height = 13
        EditLabel.Caption = #1089#1083#1091#1095#1072#1081#1085#1099#1093' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1081':'
        TabOrder = 0
        Text = '4'
      end
    end
  end
  object EdF: TEdit
    Left = 8
    Top = 8
    Width = 351
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 13
    Text = '20-exp(-((x1-1)^2/9-2/9*(x1-1)*(x2-2)+(x2-2)^2/9)/9)'
  end
end
