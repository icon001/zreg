object fmDeviceRegMessage: TfmDeviceRegMessage
  Left = 515
  Top = 385
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'fmDeviceRegMessage'
  ClientHeight = 113
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548#52404
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object btn_DisAlarmSet: TSpeedButton
    Left = 32
    Top = 64
    Width = 120
    Height = 33
    Caption = #44221#44228#54644#51228#54980#46321#47197
    OnClick = btn_DisAlarmSetClick
  end
  object btn_Set: TSpeedButton
    Left = 168
    Top = 64
    Width = 120
    Height = 33
    Caption = #54788#49345#53468#46321#47197
    OnClick = btn_SetClick
  end
  object btn_Cancel: TSpeedButton
    Left = 304
    Top = 64
    Width = 120
    Height = 33
    Caption = #52712#49548
    OnClick = btn_CancelClick
  end
  object StaticText1: TStaticText
    Left = 16
    Top = 8
    Width = 425
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = #44592#44592#51221#48372' '#46321#47197#48169#48277#51012' '#49440#53469#54616#49464#50836'.'
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #44404#47548#52404
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
end
