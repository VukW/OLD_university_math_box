object DrunkWalkmanResults: TDrunkWalkmanResults
  Left = 0
  Top = 0
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
  ClientHeight = 581
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    660
    581)
  PixelsPerInch = 96
  TextHeight = 13
  object Lb_Ple2: TLabel
    Left = 8
    Top = 519
    Width = 156
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'P(dist <=2) ='
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -21
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lb_Pe0: TLabel
    Left = 8
    Top = 549
    Width = 156
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'P(dist = 0) ='
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -21
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lb_Mdist: TLabel
    Left = 8
    Top = 489
    Width = 96
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'M[dist]='
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -21
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 270
    Height = 13
    Caption = #1101#1084#1087#1080#1088#1080#1095#1077#1089#1082#1072#1103' '#1074#1077#1088#1086#1103#1090#1085#1086#1089#1090#1100', '#1095#1090#1086' '#1076#1083#1080#1085#1072' '#1084#1072#1088#1096#1088#1091#1090#1072' = i:'
  end
  object Label2: TLabel
    Left = 334
    Top = 8
    Width = 203
    Height = 13
    Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1093#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080'  - '#1089#1088#1072#1074#1085#1077#1085#1080#1077
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 32
    Width = 320
    Height = 451
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
  end
  object StringGrid2: TStringGrid
    Left = 334
    Top = 32
    Width = 320
    Height = 451
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 1
    OnSelectCell = StringGrid1SelectCell
  end
  object Memo1: TMemo
    Left = 334
    Top = 489
    Width = 318
    Height = 84
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Visible = False
  end
end
