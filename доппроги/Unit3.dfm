object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
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
  object Label1: TLabel
    Left = 24
    Top = 56
    Width = 57
    Height = 13
    Caption = 'x=-0,4-siny'
  end
  object Label2: TLabel
    Left = 24
    Top = 75
    Width = 68
    Height = 13
    Caption = 'y=cos(x+1)/2'
  end
  object Label3: TLabel
    Left = 32
    Top = 101
    Width = 33
    Height = 13
    Caption = 'epsilon'
  end
  object Label4: TLabel
    Left = 32
    Top = 152
    Width = 25
    Height = 13
    Caption = 'kMax'
  end
  object Button1: TButton
    Left = 176
    Top = 232
    Width = 75
    Height = 25
    Caption = #1088#1077#1096#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 32
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0,000001'
  end
  object Edit2: TEdit
    Left = 32
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '100'
  end
  object Memo1: TMemo
    Left = 176
    Top = 8
    Width = 242
    Height = 218
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 112
    Top = 53
    Width = 41
    Height = 21
    TabOrder = 4
    Text = 'x0'
  end
  object Edit4: TEdit
    Left = 112
    Top = 72
    Width = 41
    Height = 21
    TabOrder = 5
    Text = 'y0'
  end
end
