object DUForm: TDUForm
  Left = 0
  Top = 0
  Caption = 'DUForm'
  ClientHeight = 454
  ClientWidth = 297
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
  object SolveBt: TButton
    Left = 8
    Top = 415
    Width = 114
    Height = 25
    Caption = #1056#1077#1096#1072#1090#1100' '#1044#1059
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = SolveBtClick
  end
  object RG_ChooseMethod: TRadioGroup
    Left = 8
    Top = 17
    Width = 281
    Height = 102
    Caption = #1052#1077#1090#1086#1076' '#1088#1077#1096#1077#1085#1080#1103' '#1044#1059
    ItemIndex = 0
    Items.Strings = (
      #1069#1081#1083#1077#1088#1072
      #1056#1091#1085#1075#1077'-'#1050#1091#1090#1090#1072
      #1040#1076#1072#1084#1089#1072
      #1050#1086#1085#1077#1095#1085#1086'-'#1088#1072#1079#1085#1086#1089#1090#1085#1099#1081' '#1084#1077#1090#1086#1076)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = RG_ChooseMethodClick
  end
  object PnlProps0_2: TPanel
    Left = 8
    Top = 224
    Width = 281
    Height = 185
    TabOrder = 2
    VerticalAlignment = taAlignBottom
    object Edit1: TEdit
      Left = 8
      Top = 48
      Width = 33
      Height = 24
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'y'#39'='
    end
    object EdInputF: TEdit
      Left = 47
      Top = 48
      Width = 218
      Height = 21
      TabOrder = 1
      Text = '(x^2-3*x)*y'
    end
    object LEdy0: TLabeledEdit
      Left = 8
      Top = 21
      Width = 106
      Height = 21
      EditLabel.Width = 96
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1095'. '#1091#1089#1083#1086#1074#1080#1077' y(x0)'
      TabOrder = 2
      Text = '1'
    end
  end
  object PnlPropsProg: TPanel
    Left = 8
    Top = 224
    Width = 281
    Height = 185
    TabOrder = 3
    Visible = False
    object StringGrid1: TStringGrid
      Left = 8
      Top = 5
      Width = 265
      Height = 81
      ColCount = 4
      RowCount = 3
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
    end
    object EdPx: TLabeledEdit
      Left = 48
      Top = 92
      Width = 225
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'p(x)='
      LabelPosition = lpLeft
      TabOrder = 1
      Text = '1-2*x'
    end
    object EdQx: TLabeledEdit
      Left = 48
      Top = 121
      Width = 225
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'q(x)='
      LabelPosition = lpLeft
      TabOrder = 2
      Text = 'x'
    end
    object EdFx: TLabeledEdit
      Left = 48
      Top = 152
      Width = 225
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'f(x)='
      LabelPosition = lpLeft
      TabOrder = 3
      Text = 'x+1'
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 125
    Width = 281
    Height = 97
    TabOrder = 4
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 92
      Height = 13
      Caption = #1043#1088#1072#1085#1080#1094#1099' '#1086#1090#1088#1077#1079#1082#1072':'
    end
    object EdLeftX: TEdit
      Left = 8
      Top = 27
      Width = 106
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object EdRightX: TEdit
      Left = 144
      Top = 27
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '1'
    end
    object LEdH: TLabeledEdit
      Left = 8
      Top = 68
      Width = 121
      Height = 21
      EditLabel.Width = 21
      EditLabel.Height = 13
      EditLabel.Caption = #1064#1072#1075
      TabOrder = 2
      Text = '0,1'
    end
  end
end
