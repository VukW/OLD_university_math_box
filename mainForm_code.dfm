object Main_Form: TMain_Form
  Left = 0
  Top = 0
  Caption = 'Main_Form'
  ClientHeight = 286
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bt_CreateFormP3d: TButton
    Left = 336
    Top = 16
    Width = 75
    Height = 25
    Caption = #1047#1072#1085#1103#1090#1100#1089#1103' 3d'
    TabOrder = 0
    OnClick = Bt_CreateFormP3dClick
  end
  object Bt_Matrix: TButton
    Left = 336
    Top = 190
    Width = 75
    Height = 25
    Caption = #1052#1072#1090#1088#1080#1094#1099
    TabOrder = 1
    OnClick = Bt_MatrixClick
  end
  object Bt_SLAU: TButton
    Left = 336
    Top = 222
    Width = 75
    Height = 25
    Caption = #1057#1051#1040#1059
    TabOrder = 2
    OnClick = Bt_SLAUClick
  end
  object Bt_SNLU: TButton
    Left = 336
    Top = 253
    Width = 75
    Height = 25
    Caption = #1057#1051#1053#1059
    TabOrder = 3
    OnClick = Bt_SNLUClick
  end
  object Bt_2dGraph: TButton
    Left = 336
    Top = 47
    Width = 75
    Height = 25
    Caption = 'Bt_2dGraph'
    TabOrder = 4
    OnClick = Bt_2dGraphClick
  end
  object Bt_Integrals: TButton
    Left = 8
    Top = 253
    Width = 105
    Height = 25
    Caption = #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1085#1080#1077
    TabOrder = 5
    OnClick = Bt_IntegralsClick
  end
  object BtSaveAll: TButton
    Left = 8
    Top = 16
    Width = 105
    Height = 25
    Caption = 'BtSaveAll'
    TabOrder = 6
    OnClick = BtSaveAllClick
  end
  object Bt_Itpl: TButton
    Left = 8
    Top = 222
    Width = 105
    Height = 25
    Caption = #1048#1085#1090#1077#1088#1087#1086#1083#1080#1088#1086#1074#1072#1085#1080#1077
    TabOrder = 7
    OnClick = Bt_ItplClick
  end
  object BtCourseW: TButton
    Left = 8
    Top = 192
    Width = 105
    Height = 25
    Caption = #1050#1091#1088#1089#1072#1095
    TabOrder = 8
    OnClick = BtCourseWClick
  end
  object Bt_Diffur: TButton
    Left = 8
    Top = 161
    Width = 105
    Height = 25
    Caption = #1044#1059
    TabOrder = 9
    OnClick = Bt_DiffurClick
  end
  object Bt_DU3d: TButton
    Left = 8
    Top = 130
    Width = 105
    Height = 25
    Caption = #1044#1059' u(x,y)'
    TabOrder = 10
    OnClick = Bt_DU3dClick
  end
  object BtSoloviev: TButton
    Left = 8
    Top = 99
    Width = 105
    Height = 25
    Caption = #1051#1072#1073#1072'_1'
    TabOrder = 11
    OnClick = BtSolovievClick
  end
  object BtTests: TButton
    Left = 184
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Form Tests'
    TabOrder = 12
    OnClick = BtTestsClick
  end
  object BtSimplex: TButton
    Left = 336
    Top = 159
    Width = 75
    Height = 25
    Caption = #1057#1080#1084#1087#1083#1077#1082#1089
    TabOrder = 13
    OnClick = BtSimplexClick
  end
  object BtCargoship: TButton
    Left = 121
    Top = 222
    Width = 97
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1089#1091#1076#1085#1072
    TabOrder = 14
    OnClick = BtCargoshipClick
  end
  object BtConvexOptimization: TButton
    Left = 336
    Top = 130
    Width = 75
    Height = 25
    Caption = #1044#1080#1087#1083#1086#1084
    TabOrder = 15
    OnClick = BtConvexOptimizationClick
  end
  object BtOptim2d: TButton
    Left = 224
    Top = 222
    Width = 106
    Height = 25
    Caption = #1054#1087#1090#1080#1084#1080#1079#1072#1094#1080#1103' 2d'
    TabOrder = 16
    OnClick = BtOptim2dClick
  end
  object ButBlottoGame: TButton
    Left = 119
    Top = 192
    Width = 99
    Height = 25
    Caption = #1048#1075#1088#1072' '#1041#1083#1086#1090#1090#1086
    TabOrder = 17
    OnClick = ButBlottoGameClick
  end
  object BtOptimNd: TButton
    Left = 224
    Top = 253
    Width = 106
    Height = 25
    Caption = #1054#1087#1090#1080#1084#1080#1079#1072#1094#1080#1103' Nd'
    TabOrder = 18
    OnClick = BtOptimNdClick
  end
  object Bt_MonteKarlo: TButton
    Left = 119
    Top = 161
    Width = 99
    Height = 25
    Caption = #1052#1086#1085#1090#1077'-'#1050#1072#1088#1083#1086
    TabOrder = 19
    OnClick = Bt_MonteKarloClick
  end
  object Bt_Investitions: TButton
    Left = 121
    Top = 253
    Width = 97
    Height = 25
    Caption = #1048#1085#1074#1077#1089#1090#1080#1094#1080#1080
    TabOrder = 20
    OnClick = Bt_InvestitionsClick
  end
  object SaveDialog1: TSaveDialog
    Left = 120
  end
end
