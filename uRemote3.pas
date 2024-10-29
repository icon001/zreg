unit uRemote3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzButton, StdCtrls, Grids, AdvObj, BaseGrid, AdvGrid;


type
  TCurrentDeviceState = Class(TComponent)
  constructor Create(AOwner:TComponent);override;
  private
    FECUID: string;
    FDeviceVersion: string;
    CardReaderList : TStringList;
    FDeviceCode: string;
    FConnected: Boolean;
    { Private declarations }
    procedure CardReaderAdd(aReaderNo:string);
    procedure CardReaderConnected(aReaderNo:string;aConnected:Boolean);
    procedure CardReaderRemove(aReaderNo:string);
  public
    { Public declarations }
    Property ECUID : string read FECUID write FECUID;
    Property DeviceVersion : string read FDeviceVersion write FDeviceVersion;
    Property DeviceCode : string read FDeviceCode write FDeviceCode;
    Property Connected : Boolean read FConnected write FConnected;
  end;

type
  TfmRemote3 = class(TForm)
    Panel31: TPanel;
    lbl_Remote3State: TLabel;
    btn_deviceAllversion: TRzBitBtn;
    Panel1: TPanel;
    pan_DeviceVersion: TPanel;
    Splitter1: TSplitter;
    pan_Reader: TPanel;
    sg_Remote3Device: TAdvStringGrid;
    sg_Reader: TAdvStringGrid;
    procedure btn_deviceAllversionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    DeviceList : TStringList;
    function CardReaderBLECheck:Boolean; //카드리더 BLE 조회
    procedure CardReaderConnected(aEcuId,aCardReaderNo,aConnected:string);
    procedure CardReaderRemove(aEcuID,aCardReaderNo:string);
    function  CardReaderUsedCheck:Boolean; //카드리더 사용유무 체크
    function  CardReaderVersionCheck:Boolean; //카드리더 버젼 조회
    function  DeviceBLECheck:Boolean; //전체 기기 BLE버젼 조회
    function  DeviceCodeCheck:Boolean; //컨트롤러 코드 체크
    procedure DeviceConnected(aEcuID,aConnected:string);
    procedure DeviceRemove(aEcuID:string);
    function  DeviceVersionCheck:Boolean; //전체 기기 버젼 조회
    function  EcuStateCheck:Boolean;     //확장기 통신상태 체크






  public
    { Public declarations }
    procedure RcvCardReaderBLEVersion(aEcuID,aReaderNo,aBLEVer:string);
    procedure RcvCardReaderVersion(aEcuID,aReaderNo,aReaderVer:string);
    procedure DeviceCodeAdd(aEcuID,aDeviceCode:string);
    procedure DeviceVersionAdd(aEcuID,aDeviceVer:string);
    procedure RcvEcuState(aEcuId,aVer,aRealData:string); //ECU 통신상태 응답
    procedure RcvCardReaderStateCheck(aEcuId,aVer,aRealData:string); //카드리더 상태 응답
    procedure RcvICUBLEVersion(aEcuID,aBLEver:string); //ICU BLE 버전
  end;

var
  fmRemote3: TfmRemote3;

implementation

uses
  uMain,
  uGlobalVariable,
  uFunction,
  uLomosUtil;

{$R *.dfm}

procedure TfmRemote3.btn_deviceAllversionClick(Sender: TObject);
begin
  try
    btn_deviceAllversion.Enabled :=False;

    GridInit(sg_Remote3Device,5);
    GridInit(sg_Reader,5);

    sg_Remote3Device.ColWidths[1] := 0;
    sg_Reader.ColWidths[2] := 0;


    EcuStateCheck;      //컨트롤러 통신상태 확인
    CardReaderUsedCheck; //카드리더 사용유무 조회
    DeviceCodeCheck; //전체 기기 코드 조회

    DeviceVersionCheck; //전체 기기 버젼 조회
    DeviceBLECheck; //전체 기기 BLE버젼 조회
    CardReaderVersionCheck; //카드리더 버젼 조회
    CardReaderBLECheck; //카드리더 BLE 조회

    lbl_Remote3State.Caption := '조회 완료.';

  Finally
    btn_deviceAllversion.Enabled :=True;
  End;
end;


function TfmRemote3.CardReaderBLECheck: Boolean;
var
  i : integer;
  stDeviceID : string;
begin
  lbl_Remote3State.Caption := '카드리더 BLE 체크 중...';
  stDeviceID:= MainForm.Edit_CurrentID.Text;
  try
    with sg_Reader do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[2,i] = '1' then   //해당 기기가 연결 되어 있다면
        begin
          G_bDeviceResponse[conBLEVer] := False;
          lbl_Remote3State.Caption := Cells[0,i] +'컨트롤러' + Cells[1,i] + '번 리더 BLE  체크 중...';
          MainForm.SendPacket(stDeviceID+Cells[0,i],'R','B079C'+Cells[1,i],Sent_Ver);
          result := ResponseCheck(conBLEVer,G_nDelayTime);
        end;
      end;
    end;
  Except
    Exit;
  End;
end;


procedure TfmRemote3.CardReaderConnected(aEcuId, aCardReaderNo,aConnected: string);
var
  i : integer;
begin
  try
    with sg_Reader do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if (Cells[0,i] = aEcuID) and (Cells[1,i] = aCardReaderNo) then
        begin
          Cells[2,i] := aConnected;
          Exit;
        end;
      end;
      if Cells[0,1] = '' then
      begin
        Cells[0,1] := aEcuID;
        Cells[1,1] := aCardReaderNo;
        Cells[2,1] := aConnected;
      end else
      begin
        AddRow;
        Cells[0,RowCount - 1] := aEcuID;
        Cells[1,RowCount - 1] := aCardReaderNo;
        Cells[2,RowCount - 1] := aConnected;
      end;
    end;
  Except
    Exit;
  End;
end;

procedure TfmRemote3.CardReaderRemove(aEcuID, aCardReaderNo: string);
begin

end;

function TfmRemote3.CardReaderUsedCheck: Boolean;
var
  i : integer;
  stDeviceID : string;
begin
  stDeviceID:= MainForm.Edit_CurrentID.Text;

  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[1,i] = '1' then   //해당 기기가 연결 되어 있다면
        begin
          G_bDeviceResponse[conCARDREADERSTATE] := False;
          MainForm.SendPacket(stDeviceID+Cells[0,i],'R','cs01',Sent_Ver);
          result := ResponseCheck(conCARDREADERSTATE,G_nDelayTime);
        end;
      end;
    end;
  Except
    Exit;
  End;

end;

function TfmRemote3.CardReaderVersionCheck: Boolean;
var
  i : integer;
  stDeviceID : string;
begin
  lbl_Remote3State.Caption := '카드리더 버젼 체크 중...';
  stDeviceID:= MainForm.Edit_CurrentID.Text;
  try
    with sg_Reader do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[2,i] = '1' then   //해당 기기가 연결 되어 있다면
        begin
          G_bDeviceResponse[conCARDREADERVERSION] := False;
          lbl_Remote3State.Caption := Cells[0,i] +'컨트롤러' + Cells[1,i] + '번 리더 버젼  체크 중...';
          MainForm.SendPacket(stDeviceID+Cells[0,i],'R','CV0'+Cells[1,i],Sent_Ver);
          result := ResponseCheck(conCARDREADERVERSION,G_nDelayTime);
        end;
      end;
    end;
  Except
    Exit;
  End;
end;

function TfmRemote3.DeviceBLECheck: Boolean;
var
  i : integer;
  stDeviceID : string;
begin
  lbl_Remote3State.Caption := '컨트롤러 BLE 체크 중...';
  stDeviceID:= MainForm.Edit_CurrentID.Text;
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if (Cells[1,i] = '1') and (copy(Cells[2,i],1,3) = 'ICU') then   //해당 기기가 연결 되어 있고 ICU 이면
        begin
          G_bDeviceResponse[conBLEVer] := False;
          lbl_Remote3State.Caption := Cells[0,i] + ' 컨트롤러 BLE 체크 중...';
          MainForm.SendPacket(stDeviceID+Cells[0,i],'R','B079C** ',Sent_Ver);
          result := ResponseCheck(conBLEVer,G_nDelayTime);
        end;
      end;
    end;
  Except
    Exit;
  End;

end;

procedure TfmRemote3.DeviceCodeAdd(aEcuID, aDeviceCode: string);
var
  i : integer;
  stTemp : string;
begin
  G_bDeviceResponse[conDEVICECODECHECK] := True;
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[0,i] = aEcuID then   //해당 기기라면
        begin
          Cells[2,i]:= aDeviceCode;
          Exit;
        end;
      end;
    end;
  Except
    Exit;
  End;

end;

function TfmRemote3.DeviceCodeCheck: Boolean;
var
  i : integer;
  stDeviceID : string;
begin
  lbl_Remote3State.Caption := '컨트롤러 기기코드 체크 중...';
  stDeviceID:= MainForm.Edit_CurrentID.Text;
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[1,i] = '1' then   //해당 기기가 연결 되어 있다면
        begin
          G_bDeviceResponse[conDEVICECODECHECK] := False;
          lbl_Remote3State.Caption := Cells[0,i] + ' 컨트롤러 기기코드 체크 중...';
          MainForm.SendPacket(stDeviceID+Cells[0,i],'R','VR01',Sent_Ver);
          result := ResponseCheck(conDEVICECODECHECK,G_nDelayTime);
        end;
      end;
    end;
  Except
    Exit;
  End;

end;

procedure TfmRemote3.DeviceConnected(aEcuID, aConnected: string);
var
  i : integer;
  stTemp : String;
begin
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[0,i] = aEcuID then
        begin
          Cells[1,i] := aConnected;
          Exit;
        end;
      end;
      if Cells[0,1] = '' then
      begin
        Cells[0,1] := aEcuID;
        Cells[1,1] := aConnected;
      end else
      begin
        AddRow;
        Cells[0,RowCount - 1] := aEcuID;
        Cells[1,RowCount - 1] := aConnected;
      end;
      stTemp := sg_Remote3Device.Cells[0,RowCount - 1];
    end;
  Except
    Exit;
  End;
end;


procedure TfmRemote3.DeviceRemove(aEcuID: string);
begin

end;

procedure TfmRemote3.DeviceVersionAdd(aEcuID, aDeviceVer: string);
var
  i : integer;
begin
  G_bDeviceResponse[conDEVICEVERSIONCHECK] := True;
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[0,i] = aEcuID then   //해당 기기라면
        begin
          Cells[3,i]:= aDeviceVer;
          Exit;
        end;
      end;
    end;
  Except
    Exit;
  End;
end;

function TfmRemote3.DeviceVersionCheck: Boolean;
var
  i : integer;
  stDeviceID : string;
begin
  lbl_Remote3State.Caption := '컨트롤러 버젼 체크 중...';
  stDeviceID:= MainForm.Edit_CurrentID.Text;
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[1,i] = '1' then   //해당 기기가 연결 되어 있다면
        begin
          G_bDeviceResponse[conDEVICEVERSIONCHECK] := False;
          lbl_Remote3State.Caption := Cells[0,i] + ' 컨트롤러 버젼  체크 중...';
          MainForm.SendPacket(stDeviceID+Cells[0,i],'R','VR00',Sent_Ver);
          result := ResponseCheck(conDEVICEVERSIONCHECK,G_nDelayTime);
        end;
      end;
    end;
  Except
    Exit;
  End;

end;

function TfmRemote3.EcuStateCheck: Boolean;
var
  stData : string;
  stDeviceID : string;
begin
  Result := false;
  stData := 'cs00';

  G_bDeviceResponse[conECUSTATE] := False;

  stDeviceID := MainForm.Edit_CurrentID.Text + '00';
  MainForm.SendPacket(stDeviceID,'R',stData,Sent_Ver);
  result := ResponseCheck(conECUSTATE,G_nDelayTime);
end;

procedure TfmRemote3.FormCreate(Sender: TObject);
begin
  DeviceList := TStringList.Create;
end;

procedure TfmRemote3.RcvCardReaderStateCheck(aEcuId, aVer,
  aRealData: string);
var
  i : integer;
begin
  G_bDeviceResponse[conCARDREADERSTATE] := True;
  Delete(aRealData,1,5);  //cs01x1uuuuu
  for i:= 1 to Length(aRealData) do
  begin
    if aRealData[i] = '1' then
    begin
      CardReaderConnected(aEcuId,inttostr(i),'1');
    end else if aRealData[i] = '0' then
    begin
      CardReaderConnected(aEcuId,inttostr(i),'0');
    end else
    begin
      CardReaderRemove(aEcuId,inttostr(i));
    end;
  end;
end;

procedure TfmRemote3.RcvCardReaderBLEVersion(aEcuID, aReaderNo,
  aBLEVer: string);
var
  i : integer;
  stTemp : string;
begin
  G_bDeviceResponse[conCARDREADERVERSION] := True;
  try
    with sg_Reader do
    begin
      for i := 1 to RowCount - 1 do
      begin
        stTemp := aReaderNo[1];
        if (Cells[0,i] = aEcuID) and (Cells[1,i] = aReaderNo[1])  then   //해당 기기라면
        begin
          Cells[4,i]:= aBLEVer;
          Exit;
        end;
      end;
    end;
  Except
    Exit;
  End;
end;


procedure TfmRemote3.RcvCardReaderVersion(aEcuID, aReaderNo,
  aReaderVer: string);
var
  i : integer;
  stTemp : string;
begin
  G_bDeviceResponse[conCARDREADERVERSION] := True;
  try
    with sg_Reader do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if (Cells[0,i] = aEcuID) and (Cells[1,i] = copy(aReaderNo,2,1))  then   //해당 기기라면
        begin
          Cells[3,i]:= aReaderVer;
          Exit;
        end;
      end;
    end;
  Except
    Exit;
  End;
end;


procedure TfmRemote3.RcvICUBLEVersion(aEcuID, aBLEver: string);
var
  i : integer;
begin
  G_bDeviceResponse[conBLEVer] := True;
  try
    with sg_Remote3Device do
    begin
      for i := 1 to RowCount - 1 do
      begin
        if Cells[0,i] = aEcuID then   //해당 기기라면
        begin
          Cells[4,i]:= aBLEver;
          Exit;
        end;
      end;
    end;
  Except
    Exit;
  End;
end;


procedure TfmRemote3.RcvEcuState(aEcuId, aVer, aRealData: string);
var
  i : integer;
begin

  Try
    G_bDeviceResponse[conECUSTATE] := True;
    Delete(aRealData,1,4);
    for i:= 1 to Length(aRealData) do
    begin
      //lbl_Remote3State.Caption := inttostr(i);
      if aRealData[i] = '1' then
      begin
        DeviceConnected(FillZeroNumber(i-1,2),'1');
      end else if aRealData[i] = '0' then
      begin
        DeviceConnected(FillZeroNumber(i-1,2),'0');
      end else
      begin
        DeviceRemove(FillZeroNumber(i-1,2));
      end;
    end;
  Except
    Exit;
  End;


end;




{ TCurrentDeviceState }

procedure TCurrentDeviceState.CardReaderAdd(aReaderNo: string);
begin

end;

procedure TCurrentDeviceState.CardReaderConnected(aReaderNo: string;
  aConnected: Boolean);
begin

end;

procedure TCurrentDeviceState.CardReaderRemove(aReaderNo: string);
begin

end;

constructor TCurrentDeviceState.Create(AOwner: TComponent);
begin
  inherited;

end;



end.
