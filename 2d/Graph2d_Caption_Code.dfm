object Graph_CaptForm: TGraph_CaptForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Graph_CaptForm'
  ClientHeight = 289
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 232
    Top = 17
    Width = 84
    Height = 13
    Caption = #1053#1077#1087#1088#1077#1088#1099#1074#1085#1086#1089#1090#1100':'
  end
  object Label4: TLabel
    Left = 232
    Top = 75
    Width = 103
    Height = 13
    Caption = #1054#1073#1083#1072#1089#1090#1100' '#1088#1080#1089#1086#1074#1072#1085#1080#1103':'
  end
  object Ch_Offsets: TCheckBox
    Left = 16
    Top = 16
    Width = 97
    Height = 17
    Caption = #1054#1089#1080
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = Ch_OffsetsClick
  end
  object PanelGrid: TPanel
    Left = 16
    Top = 48
    Width = 177
    Height = 237
    BevelWidth = 2
    Caption = 'PanelGrid'
    TabOrder = 1
    VerticalAlignment = taAlignTop
    object Label1: TLabel
      Left = 16
      Top = 100
      Width = 21
      Height = 13
      Caption = #1064#1072#1075
    end
    object Label2: TLabel
      Left = 16
      Top = 189
      Width = 21
      Height = 13
      Caption = #1064#1072#1075
    end
    object HorOfs_Color: TImage
      Left = 16
      Top = 53
      Width = 33
      Height = 33
      OnClick = HorOfs_ColorClick
    end
    object VerOfs_Color: TImage
      Left = 16
      Top = 150
      Width = 33
      Height = 33
      OnClick = VerOfs_ColorClick
    end
    object Ch_horOfs: TCheckBox
      Left = 16
      Top = 22
      Width = 153
      Height = 25
      Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1099#1077' '#1083#1080#1085#1080#1080
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = Ch_horOfsClick
    end
    object Ch_VerOfs: TCheckBox
      Left = 16
      Top = 127
      Width = 153
      Height = 17
      Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1099#1077' '#1083#1080#1085#1080#1080
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = Ch_VerOfsClick
    end
    object EdHorStep: TEdit
      Left = 112
      Top = 189
      Width = 57
      Height = 21
      TabOrder = 2
      Text = '1'
      OnChange = EdHorStepChange
    end
    object EdVerStep: TEdit
      Left = 112
      Top = 97
      Width = 57
      Height = 21
      TabOrder = 3
      Text = '1'
      OnChange = EdVerStepChange
    end
  end
  object Ed_Cont: TEdit
    Left = 232
    Top = 36
    Width = 153
    Height = 21
    TabOrder = 2
    Text = '0,01'
    OnChange = Ed_ContChange
  end
  object EdRightY: TEdit
    Left = 283
    Top = 94
    Width = 51
    Height = 21
    Hint = 'RightY'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = '10'
    OnChange = EdRightYChange
  end
  object EdLeftX: TEdit
    Left = 232
    Top = 121
    Width = 51
    Height = 21
    Hint = 'LeftX'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Text = '-10'
    OnChange = EdLeftXChange
  end
  object EdLeftY: TEdit
    Left = 283
    Top = 148
    Width = 51
    Height = 21
    Hint = 'LeftY'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = '-10'
    OnChange = EdLeftYChange
  end
  object EdRightX: TEdit
    Left = 334
    Top = 121
    Width = 51
    Height = 21
    Hint = 'RightX'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = '10'
    OnChange = EdRightXChange
  end
  object PanelLabel: TPanel
    Left = 212
    Top = 175
    Width = 185
    Height = 110
    Caption = 'PanelLabel'
    TabOrder = 7
    VerticalAlignment = taAlignTop
    object Label5: TLabel
      Left = 8
      Top = 47
      Width = 107
      Height = 13
      Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1099#1081' '#1096#1072#1075
    end
    object Label6: TLabel
      Left = 7
      Top = 80
      Width = 96
      Height = 13
      Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1099#1081' '#1096#1072#1075
    end
    object Ch_Labels: TCheckBox
      Left = 8
      Top = 24
      Width = 160
      Height = 17
      Alignment = taLeftJustify
      Caption = #1087#1088#1086#1088#1080#1089#1086#1074#1099#1074#1072#1090#1100' '#1083#1077#1081#1073#1083#1099
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = Ch_LabelsClick
    end
    object Ed_HorStepL: TEdit
      Left = 121
      Top = 47
      Width = 56
      Height = 21
      TabOrder = 1
      Text = '0,5'
      OnChange = Ed_HorStepLChange
    end
    object Ed_VerStepL: TEdit
      Left = 120
      Top = 80
      Width = 57
      Height = 21
      TabOrder = 2
      Text = '0,5'
      OnChange = Ed_VerStepLChange
    end
  end
  object ColorDialog1: TColorDialog
    Left = 136
    Top = 8
  end
end
