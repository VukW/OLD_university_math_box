object FormulaCharactW: TFormulaCharactW
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'FormulaCharactW'
  ClientHeight = 360
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 355
    Top = 98
    Width = 63
    Height = 13
    Caption = 'NumOfLinesX'
  end
  object Label3: TLabel
    Left = 355
    Top = 125
    Width = 63
    Height = 13
    Caption = 'NumOfLinesY'
  end
  object Label6: TLabel
    Left = 27
    Top = 131
    Width = 55
    Height = 23
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object RGDefDomainType: TRadioGroup
    Left = 158
    Top = 20
    Width = 144
    Height = 58
    Caption = 'DefDomain type'
    ItemIndex = 0
    Items.Strings = (
      'YoX'
      'XoY')
    TabOrder = 1
  end
  object RGObjType: TRadioGroup
    Left = 27
    Top = 20
    Width = 114
    Height = 105
    BiDiMode = bdLeftToRight
    Caption = 'RGObjType'
    ItemIndex = 0
    Items.Strings = (
      'Surf_ZoXY'
      'Surf_YoXZ'
      'Surf_XoYZ'
      'Surf_Param'
      'Curve_Param')
    ParentBiDiMode = False
    TabOrder = 0
    OnClick = RGObjTypeClick
  end
  object CheckLinesHomo: TCheckBox
    Left = 158
    Top = 84
    Width = 97
    Height = 17
    Caption = 'CheckLinesHomo'
    TabOrder = 2
  end
  object EdRightY: TEdit
    Left = 410
    Top = 20
    Width = 49
    Height = 21
    Hint = 'RightY'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = 'RightY'
  end
  object EdLeftX: TEdit
    Left = 355
    Top = 47
    Width = 49
    Height = 21
    Hint = 'LeftX'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = 'leftX'
  end
  object EdLeftY: TEdit
    Left = 410
    Top = 68
    Width = 49
    Height = 21
    Hint = 'LeftY'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Text = 'LeftY'
  end
  object EdRightX: TEdit
    Left = 465
    Top = 47
    Width = 57
    Height = 21
    Hint = 'RightX'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = 'RightX'
  end
  object EdNoLX: TEdit
    Left = 455
    Top = 95
    Width = 57
    Height = 21
    TabOrder = 7
    Text = 'EdNoLX'
  end
  object EdNolY: TEdit
    Left = 455
    Top = 122
    Width = 57
    Height = 21
    TabOrder = 8
    Text = 'EdNoLY'
  end
  object ButSave: TButton
    Left = 27
    Top = 303
    Width = 75
    Height = 25
    Caption = 'Save It!'
    TabOrder = 10
    OnClick = ButSaveClick
  end
  object ButCanc: TButton
    Left = 108
    Top = 303
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 11
    OnClick = ButCancClick
  end
  object CB_ToPaint: TCheckBox
    Left = 189
    Top = 307
    Width = 66
    Height = 17
    Caption = 'Paint it!'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object EdName: TEdit
    Left = 88
    Top = 133
    Width = 249
    Height = 21
    TabOrder = 12
    Text = 'New Function'
  end
  object Panel1: TPanel
    Left = 27
    Top = 160
    Width = 495
    Height = 128
    Caption = 'Panel1'
    TabOrder = 13
    object Label1: TLabel
      Left = 47
      Top = 13
      Width = 16
      Height = 23
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 47
      Top = 53
      Width = 16
      Height = 23
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 47
      Top = 90
      Width = 16
      Height = 23
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object InputFormulaZ: TEdit
      Left = 69
      Top = 90
      Width = 412
      Height = 21
      TabOrder = 0
    end
    object IndVar1Input: TEdit
      Left = 8
      Top = 10
      Width = 33
      Height = 26
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = 'x'
    end
    object IndVar2Input: TEdit
      Left = 8
      Top = 50
      Width = 33
      Height = 26
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = 'y'
    end
    object IndVar3Input: TEdit
      Left = 8
      Top = 90
      Width = 33
      Height = 26
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = 'z'
    end
    object InputFormulaY: TEdit
      Left = 69
      Top = 54
      Width = 412
      Height = 21
      TabOrder = 4
    end
    object InputFormulaX: TEdit
      Left = 69
      Top = 15
      Width = 412
      Height = 21
      TabOrder = 5
    end
  end
  object CB_Dynamic: TCheckBox
    Left = 261
    Top = 307
    Width = 101
    Height = 17
    Caption = 'Depends on time'
    TabOrder = 14
    OnClick = CB_DynamicClick
  end
  object PnlTime: TPanel
    Left = 375
    Top = 294
    Width = 147
    Height = 58
    Caption = 'Time'
    Enabled = False
    TabOrder = 15
    VerticalAlignment = taAlignTop
    object EdMaxT: TEdit
      Left = 47
      Top = 16
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = 'EdMaxT'
    end
    object EdMinT: TEdit
      Left = 3
      Top = 16
      Width = 38
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = 'EdMinT'
    end
    object EdNoLT: TEdit
      Left = 94
      Top = 16
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = 'EdNoLT'
    end
  end
end
