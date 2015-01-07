object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 339
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
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
  object ButFromBeg: TButton
    Left = 8
    Top = 287
    Width = 98
    Height = 25
    Caption = #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100'!'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = ButFromBegClick
  end
  object RG_ChooseMethod: TRadioGroup
    Left = 8
    Top = 65
    Width = 241
    Height = 88
    Caption = #1052#1077#1090#1086#1076' '#1080#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1085#1080#1103
    ItemIndex = 0
    Items.Strings = (
      #1052#1077#1090#1086#1076' '#1083#1077#1074#1099#1093' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082#1086#1074
      #1052#1077#1090#1086#1076' '#1087#1088#1072#1074#1099#1093' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082#1086#1074
      #1052#1077#1090#1086#1076' '#1089#1088#1077#1076#1085#1080#1093' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082#1086#1074
      #1052#1077#1090#1086#1076' '#1090#1088#1072#1087#1077#1094#1080#1081
      #1052#1077#1090#1086#1076' '#1057#1080#1084#1087#1089#1086#1085#1072)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object GraphCapt_panel: TPanel
    Left = 8
    Top = 175
    Width = 241
    Height = 90
    Caption = 'C'#1074#1086#1081#1089#1090#1074#1072' '#1080#1085#1090#1077#1075#1088#1088#1086#1074#1072#1085#1080#1103
    TabOrder = 2
    VerticalAlignment = taAlignTop
    DesignSize = (
      241
      90)
    object Label3: TLabel
      Left = 41
      Top = 46
      Width = 57
      Height = 13
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = #1050'-'#1074#1086' '#1096#1072#1075#1086#1074
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
  object InputFormulaInt: TEdit
    Left = 16
    Top = 24
    Width = 233
    Height = 21
    TabOrder = 3
    Text = 'InputFormulaInt'
  end
  object ResEd: TEdit
    Left = 128
    Top = 289
    Width = 121
    Height = 21
    TabOrder = 4
    Text = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  end
end
