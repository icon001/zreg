inherited fmAlarmList: TfmAlarmList
  Left = 1384
  Top = 136
  Width = 971
  Height = 611
  Caption = #50508#46988#48156#49373#47532#49828#53944
  Font.Charset = HANGEUL_CHARSET
  Font.Height = -12
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 963
    Height = 57
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 48
      Height = 12
      Caption = #44592#44592#48264#54840
    end
    object btn_Search: TSpeedButton
      Left = 416
      Top = 16
      Width = 73
      Height = 25
      Caption = #51312#54924
      OnClick = btn_SearchClick
    end
    object btn_AlaramDelete: TSpeedButton
      Left = 520
      Top = 16
      Width = 73
      Height = 25
      Caption = #50508#46988#49325#51228
      OnClick = btn_AlaramDeleteClick
    end
    object btn_Close: TSpeedButton
      Left = 728
      Top = 16
      Width = 73
      Height = 25
      Caption = #45803#44592
      OnClick = btn_CloseClick
    end
    object btn_AllDelete: TSpeedButton
      Left = 624
      Top = 16
      Width = 73
      Height = 25
      Caption = #51204#52404#50508#46988#49325#51228
      OnClick = btn_AllDeleteClick
    end
    object cmb_EcuID: TComboBox
      Left = 72
      Top = 16
      Width = 129
      Height = 20
      Style = csDropDownList
      ImeName = 'Microsoft IME 2003'
      ItemHeight = 12
      TabOrder = 0
      OnChange = cmb_EcuIDChange
    end
  end
  object sg_Alarm: TAdvStringGrid [1]
    Left = 0
    Top = 57
    Width = 963
    Height = 520
    Cursor = crDefault
    Align = alClient
    ColCount = 2
    DefaultColWidth = 600
    DefaultRowHeight = 21
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing, goRowMoving, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 1
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    SearchFooter.FindNextCaption = 'Find next'
    SearchFooter.FindPrevCaption = 'Find previous'
    SearchFooter.HighLightCaption = 'Highlight'
    SearchFooter.HintClose = 'Close'
    SearchFooter.HintFindNext = 'Find next occurence'
    SearchFooter.HintFindPrev = 'Find previous occurence'
    SearchFooter.HintHighlight = 'Highlight occurences'
    SearchFooter.MatchCaseCaption = 'Match case'
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'MS Sans Serif'
    PrintSettings.Font.Style = []
    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
    PrintSettings.FixedFont.Color = clWindowText
    PrintSettings.FixedFont.Height = -11
    PrintSettings.FixedFont.Name = 'MS Sans Serif'
    PrintSettings.FixedFont.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'MS Sans Serif'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'MS Sans Serif'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    FixedColWidth = 151
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    ColumnHeaders.Strings = (
      #49884#44036
      #54056#53431)
    Filter = <>
    Version = '3.3.0.1'
    ColWidths = (
      151
      784)
  end
end
