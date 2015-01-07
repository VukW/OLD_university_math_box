object FuncFeaturesW: TFuncFeaturesW
  Left = 781
  Top = 55
  BorderStyle = bsToolWindow
  Caption = 'FuncFeaturesW'
  ClientHeight = 482
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 27
    Top = 144
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
  object Label1: TLabel
    Left = 121
    Top = 91
    Width = 51
    Height = 23
    Caption = 'Color'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Image1: TImage
    Left = 249
    Top = 94
    Width = 32
    Height = 23
    OnClick = Image1Click
  end
  object Label4: TLabel
    Left = 121
    Top = 48
    Width = 99
    Height = 23
    Caption = 'Width(px)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 176
    Width = 289
    Height = 168
    TabOrder = 2
    object Label2: TLabel
      Left = 32
      Top = 131
      Width = 63
      Height = 13
      Caption = 'NumOfLinesX'
    end
    object Label5: TLabel
      Left = 58
      Top = 8
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
    object Label3: TLabel
      Left = 58
      Top = 48
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
    object EdLeftX: TEdit
      Left = 35
      Top = 91
      Width = 49
      Height = 21
      Hint = 'LeftX'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = 'leftX'
    end
    object EdRightX: TEdit
      Left = 109
      Top = 91
      Width = 57
      Height = 21
      Hint = 'RightX'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = 'RightX'
    end
    object EdNoLX: TEdit
      Left = 109
      Top = 131
      Width = 57
      Height = 21
      TabOrder = 4
      Text = 'EdNoLX'
    end
    object IndVar1Input: TEdit
      Left = 19
      Top = 7
      Width = 33
      Height = 26
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = 'x'
    end
    object InputFormulaX: TEdit
      Left = 80
      Top = 8
      Width = 193
      Height = 21
      TabOrder = 0
    end
    object IndVar2Input: TEdit
      Left = 19
      Top = 47
      Width = 33
      Height = 26
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = 'y'
    end
    object InputFormulaY: TEdit
      Left = 80
      Top = 48
      Width = 193
      Height = 21
      TabOrder = 1
    end
  end
  object RGObjType: TRadioGroup
    Left = 8
    Top = 8
    Width = 92
    Height = 85
    BiDiMode = bdLeftToRight
    Caption = 'RGObjType'
    ItemIndex = 0
    Items.Strings = (
      'YoX'
      'XoY'
      'Polar'
      'Param'
      'AoP')
    ParentBiDiMode = False
    TabOrder = 0
    OnClick = RGObjTypeClick
  end
  object ButSave: TButton
    Left = 8
    Top = 355
    Width = 75
    Height = 25
    Caption = 'Save It!'
    TabOrder = 6
    OnClick = ButSaveClick
  end
  object ButCanc: TButton
    Left = 8
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = ButCancClick
  end
  object EdName: TEdit
    Left = 88
    Top = 149
    Width = 193
    Height = 21
    TabOrder = 1
    Text = 'New Function'
  end
  object EdColor: TEdit
    Left = 178
    Top = 96
    Width = 65
    Height = 21
    TabOrder = 4
    Text = 'clBlack'
  end
  object CB_ToPaint: TCheckBox
    Left = 18
    Top = 99
    Width = 74
    Height = 17
    Caption = 'Paint it!'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object Panel2: TPanel
    Left = 8
    Top = 176
    Width = 289
    Height = 169
    TabOrder = 3
    Visible = False
    object Points_am: TEdit
      Left = 225
      Top = 8
      Width = 40
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '4'
      OnChange = Points_amChange
    end
    object P_am_UD: TUpDown
      Left = 265
      Top = 8
      Width = 21
      Height = 21
      Associate = Points_am
      Min = 2
      Max = 50000
      ParentShowHint = False
      Position = 4
      ShowHint = True
      TabOrder = 1
    end
    object PointsSG: TStringGrid
      Left = 0
      Top = -1
      Width = 219
      Height = 170
      Hint = #1084#1072#1090#1088#1080#1094#1072' '#1090#1086#1095#1077#1082
      Margins.Top = 2
      Margins.Bottom = 2
      ColCount = 2
      DefaultColWidth = 90
      DefaultRowHeight = 15
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor]
      ParentShowHint = False
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 2
    end
  end
  object WdthEd: TEdit
    Left = 233
    Top = 48
    Width = 40
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = '1'
  end
  object WdthUD: TUpDown
    Left = 273
    Top = 48
    Width = 16
    Height = 21
    Associate = WdthEd
    Min = 1
    Max = 20
    ParentShowHint = False
    Position = 1
    ShowHint = True
    TabOrder = 9
  end
  object BtIntgr: TButton
    Left = 8
    Top = 417
    Width = 75
    Height = 25
    Caption = 'Integrate!'
    TabOrder = 10
    OnClick = BtIntgrClick
  end
  object BtInterp: TButton
    Left = 8
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Interpolate!'
    TabOrder = 11
    OnClick = BtInterpClick
  end
  object PnlCompute: TPanel
    Left = 89
    Top = 351
    Width = 208
    Height = 123
    BevelInner = bvLowered
    BevelKind = bkSoft
    BevelOuter = bvSpace
    BorderWidth = 2
    BorderStyle = bsSingle
    Caption = #1074#1099#1095#1080#1089#1083#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1092#1091#1085#1082#1094#1080#1080
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 12
    VerticalAlignment = taAlignTop
    object Label7: TLabel
      Left = 16
      Top = 42
      Width = 50
      Height = 13
      Caption = #1042' '#1090#1086#1095#1082#1077' ='
    end
    object EdComputeX: TEdit
      Left = 78
      Top = 37
      Width = 107
      Height = 21
      TabOrder = 0
    end
    object EdComputeRes: TEdit
      Left = 64
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'EdComputeRes'
    end
    object BtCompute: TButton
      Left = 16
      Top = 80
      Width = 42
      Height = 25
      Caption = 'f='
      TabOrder = 2
      OnClick = BtComputeClick
    end
  end
  object Panel3: TPanel
    Left = 303
    Top = 351
    Width = 208
    Height = 123
    BevelInner = bvLowered
    BevelKind = bkSoft
    BevelOuter = bvSpace
    BorderWidth = 2
    BorderStyle = bsSingle
    Caption = #1074#1099#1095#1080#1089#1083#1080#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1091#1102' '#1092#1091#1085#1082#1094#1080#1080
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 13
    VerticalAlignment = taAlignTop
    object Label8: TLabel
      Left = 16
      Top = 42
      Width = 50
      Height = 13
      Caption = #1042' '#1090#1086#1095#1082#1077' ='
    end
    object Edit1: TEdit
      Left = 78
      Top = 37
      Width = 107
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 64
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'EdComputeRes'
    end
    object Button1: TButton
      Left = 16
      Top = 80
      Width = 42
      Height = 25
      Caption = 'f'#39'='
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 272
    Top = 8
  end
end
