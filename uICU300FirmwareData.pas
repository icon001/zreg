unit uICU300FirmwareData;

interface

uses
  SysUtils, Classes;

type
  TSendPacketEvent = procedure(Sender: TObject; aSendHexData,aViewHexData: string) of object;
  TMainRequestProcess = procedure(Sender: TObject; aEcuID,aNo,aDeviceType: string;aMaxSize,aCurPosition:integer) of object;

  TICU300FirmwareProcess = class(TComponent)
  private
    FMaxSize: integer;
    FCurrentPosition: integer;
    FNO: string;
    FECUID: string;
    FDeviceType: string;
    FOnMainRequestProcess: TMainRequestProcess;
    procedure SetCurrentPosition(const Value: integer);
  public
    property ECUID : string read FECUID write FECUID;
    property NO : string read FNO write FNO;
    property DeviceType : string read FDeviceType write FDeviceType;
    property MaxSize : integer read FMaxSize write FMaxSize;
    property CurrentPosition : integer read FCurrentPosition write SetCurrentPosition;
  public
    property OnMainRequestProcess : TMainRequestProcess read FOnMainRequestProcess write FOnMainRequestProcess;
  end;

  TdmICU300FirmwareData = class(TDataModule)
  private
    ICU300FWData : PChar;
    FDeviceID: string;
    FPacketSize: integer;
    FFirmwareFileName: string;
    FCurrentIndex: Integer;
    FSendMsgNo: integer;
    FFileSize: integer;
    FOnSendPacketEvent: TSendPacketEvent;
    FDeviceType: string;
    procedure SetFirmwareFileName(const Value: string);
    { Private declarations }
  public
    procedure SendICU300FirmWarePacket(aCmd,aData,aVer:string);
  public
    { Public declarations }
    property DeviceID : string read FDeviceID write FDeviceID;
    property DeviceType : string read FDeviceType write FDeviceType;
    property PacketSize : integer read FPacketSize write FPacketSize;
    property SendMsgNo : integer read FSendMsgNo write FSendMsgNo;
    property FirmwareFileName : string read FFirmwareFileName write SetFirmwareFileName;
    property FileSize : integer read FFileSize write FFileSize;
    property CurrentIndex : Integer read FCurrentIndex write FCurrentIndex;
  public
    property OnSendPacketEvent :TSendPacketEvent read FOnSendPacketEvent write FOnSendPacketEvent;
  end;

var
  dmICU300FirmwareData: TdmICU300FirmwareData;

implementation

{$R *.dfm}
uses
  uCommon,
  uLomosUtil;

{ TdmICU300FirmwareData }

procedure TdmICU300FirmwareData.SendICU300FirmWarePacket(aCmd, aData,
  aVer: string);
var
  cKey : char;
  stHexData : string;
  stHexFirmWareData : string;
  nDataLength : integer;
  nSendFirmwarePacketSize : integer;
  i : integer;
begin
  if CurrentIndex * PacketSize + 1 > FileSize then Exit;
  stHexFirmWareData := '';
  nSendFirmwarePacketSize := PacketSize;
  for i := (CurrentIndex * PacketSize) to (CurrentIndex * PacketSize + (PacketSize-1)) do
  begin
    if i > FileSize - 1 then
    begin
      nSendFirmwarePacketSize := i - (CurrentIndex * PacketSize);
      Break;
    end;
    stHexFirmWareData := stHexFirmWareData + Dec2Hex(Ord(ICU300FWData[i]),2) + ' ';
  end;

  cKey := #$20;
  nDataLength:= (G_nIDLength + 14) + Length(aData) + nSendFirmwarePacketSize;
  stHexData:= Ascii2Hex(STX +FillZeroNumber(nDataLength,3)+ cKey + aVer + DeviceID+ aCmd+InttoStr(SendMsgNo) + aData);
  stHexData := stHexData + stringReplace(stHexFirmWareData,' ','',[rfReplaceAll]);
  stHexData:= stHexData+ MakeHexCSData(stHexData+'03',G_nProgramType) + '03';

  if Assigned(FOnSendPacketEvent) then
  begin
    OnSendPacketEvent(self,stHexData,stHexFirmWareData);
  end;

  //aKey:= Ord(ACkStr[5]);
  //ACkStr2:= Copy(ACKStr,1,5)+EncodeData(aKey,Copy(ACkStr,6,Length(ACkStr)-6))+ETX;
  //if aMsgNo >= 9 then  Send_MsgNo:= 0
  //else                 Send_MsgNo:= aMsgNo + 1;
end;

procedure TdmICU300FirmwareData.SetFirmwareFileName(const Value: string);
var
  iBytesRead: Integer;
  iFileHandle: Integer;
begin
  //if FFirmwareFileName = Value then Exit;
  FFirmwareFileName := Value;
  if Not FileExists(Value) then Exit;
  //���⼭ ������ �о� ������
  iFileHandle := FileOpen(Value, fmOpenRead);
  FileSize := FileSeek(iFileHandle,0,2);
  FileSeek(iFileHandle,0,0);

  ICU300FWData := nil;
  ICU300FWData := PChar(AllocMem(FileSize + 1));
  iBytesRead := FileRead(iFileHandle, ICU300FWData^, FileSize);
  FileClose(iFileHandle);
end;

{ TICU300FirmwareProcess }

procedure TICU300FirmwareProcess.SetCurrentPosition(const Value: integer);
begin
  FCurrentPosition := Value;
  if Assigned(FOnMainRequestProcess) then
  begin
    OnMainRequestProcess(self,EcuID,No,DeviceType,MaxSize,Value);
  end;
end;

end.
