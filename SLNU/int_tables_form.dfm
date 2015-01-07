object IntTableForm: TIntTableForm
  Left = 0
  Top = 150
  BorderStyle = bsToolWindow
  Caption = 'IntTableForm'
  ClientHeight = 175
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  GlassFrame.Left = 20
  GlassFrame.Top = 40
  GlassFrame.Right = 20
  GlassFrame.Bottom = 40
  GlassFrame.SheetOfGlass = True
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  DesignSize = (
    341
    175)
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 8
    Top = 5
    Width = 325
    Height = 129
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultColWidth = 100
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ScrollBars = ssNone
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
  end
  object BtAddIntl: TButton
    Left = 8
    Top = 142
    Width = 69
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Add Interval'
    TabOrder = 1
    OnClick = BtAddIntlClick
  end
  object BtOk: TButton
    Left = 146
    Top = 142
    Width = 69
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    TabOrder = 2
    OnClick = BtOkClick
  end
  object BtDelIntl: TButton
    Left = 77
    Top = 142
    Width = 69
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Delete Intl'
    TabOrder = 3
    OnClick = BtDelIntlClick
  end
end
