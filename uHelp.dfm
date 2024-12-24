object fmHelp: TfmHelp
  Left = 192
  Top = 114
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #46020#50880#47568
  ClientHeight = 325
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lb_File: TLabel
    Left = 0
    Top = 312
    Width = 496
    Height = 13
    Align = alBottom
    Caption = 'lb_File'
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 496
    Height = 249
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #46027#50880#52404
    Font.Style = []
    ImeName = 'Microsoft IME 2010'
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object chk_edit: TCheckBox
    Left = 8
    Top = 272
    Width = 297
    Height = 17
    Caption = #54200#51665
    TabOrder = 1
    OnClick = chk_editClick
  end
  object Button1: TButton
    Left = 160
    Top = 264
    Width = 153
    Height = 33
    Caption = #54869#51064
    TabOrder = 2
    OnClick = Button1Click
  end
end
