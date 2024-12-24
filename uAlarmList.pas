unit uAlarmList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, BaseGrid, AdvGrid, uSubForm,
  CommandArray;

type
  TfmAlarmList = class(TfmASubForm)
    Panel1: TPanel;
    cmb_EcuID: TComboBox;
    Label1: TLabel;
    btn_Search: TSpeedButton;
    btn_AlaramDelete: TSpeedButton;
    btn_Close: TSpeedButton;
    sg_Alarm: TAdvStringGrid;
    btn_AllDelete: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure cmb_EcuIDChange(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SearchClick(Sender: TObject);
    procedure btn_AlaramDeleteClick(Sender: TObject);
    procedure btn_AllDeleteClick(Sender: TObject);
  private
    FOnEcuID: string;
    procedure SetEcuID(const Value: string);
    { Private declarations }
    procedure LoadEcuID;
    procedure AlarmSearch(aEcuID:string);
  public
    { Public declarations }
    property SelectEcuID : string read FOnEcuID write SetEcuID;
  end;

var
  fmAlarmList: TfmAlarmList;

implementation
uses
  uLomosUtil,
  uCommon;
{$R *.dfm}

{ TfmAlarmList }

procedure TfmAlarmList.SetEcuID(const Value: string);
var
  nIndex : integer;
begin
  FOnEcuID := Value;
  if cmb_EcuID.Items.Count > 0 then
  begin
    nIndex := cmb_EcuID.Items.IndexOf(Value);
    if nIndex > -1 then cmb_EcuID.ItemIndex := nIndex;
  end;
  AlarmSearch(Value);
end;

procedure TfmAlarmList.FormCreate(Sender: TObject);
begin
  LoadEcuID;
end;

procedure TfmAlarmList.LoadEcuID;
var
  i : integer;
begin
  cmb_EcuID.Items.Clear;
  for i := 0 to 63 do
  begin
    cmb_EcuID.Items.Add(FillZeroNumber(i,2));
  end;
end;

procedure TfmAlarmList.cmb_EcuIDChange(Sender: TObject);
begin
  if SelectEcuID = cmb_EcuID.Text then Exit;
  SelectEcuID := cmb_EcuID.Text;
end;

procedure TfmAlarmList.AlarmSearch(aEcuID: string);
var
  nRow : integer;
  nIndex : integer;
  stTemp : string;
  stAlarmTime : string;
begin
  GridInitialize(sg_Alarm);
  nIndex := DeviceAlarmList.IndexOf(aEcuID);
  if nIndex < 0 then Exit;
  if TAlarmList(DeviceAlarmList.Objects[nIndex]).AlarmList.Count < 1 then Exit;
  sg_Alarm.RowCount := TAlarmList(DeviceAlarmList.Objects[nIndex]).AlarmList.Count + 1;
  for nRow := 0 to TAlarmList(DeviceAlarmList.Objects[nIndex]).AlarmList.Count - 1 do
  begin
    stTemp := TAlarmList(DeviceAlarmList.Objects[nIndex]).AlarmList.Strings[nRow];
    stAlarmTime := copy(stTemp,8 + G_nIDLength + 5,14);
    sg_Alarm.Cells[0,nRow + 1] := MakeDatetimeStr(stAlarmTime);
    sg_Alarm.Cells[1,nRow + 1] := stTemp;
  end;
end;

procedure TfmAlarmList.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmAlarmList.btn_SearchClick(Sender: TObject);
begin
  AlarmSearch(SelectEcuID);
end;

procedure TfmAlarmList.btn_AlaramDeleteClick(Sender: TObject);
var
  nIndex : integer;
begin
  nIndex := DeviceAlarmList.IndexOf(SelectEcuID);
  if nIndex < 0 then Exit;
  TAlarmList(DeviceAlarmList.Objects[nIndex]).AlarmList.Clear;
  AlarmSearch(SelectEcuID);
end;

procedure TfmAlarmList.btn_AllDeleteClick(Sender: TObject);
var
  nIndex : integer;
begin
  //nIndex := DeviceAlarmList.IndexOf(SelectEcuID);
  //if nIndex < 0 then Exit;
  for nIndex := 0 to DeviceAlarmList.Count - 1 do
  begin
    TAlarmList(DeviceAlarmList.Objects[nIndex]).AlarmList.Clear;
  end;
  AlarmSearch(SelectEcuID);

end;

end.
