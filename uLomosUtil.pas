{*******************************************************}
{                                                       }
{         ȭ�ϸ�: uLomosUtil.pas                        }
{         ��  ��: ��ƿ��Ƽ                              }
{         �ۼ���:                                       }
{         �ۼ���: ������                                }
{         Copyright                                     }
{                                                       }
{*******************************************************}
//OpenPictureDialog1.InitialDir:= ExtractFileDir(Application.ExeName);
unit uLomosUtil;

interface
uses
  shellapi,
  ComCtrls,
  winsock,
  Windows,
  SysUtils,
  Controls, Classes, Graphics, Forms, DB,DBGrids,
  SyncObjs,
  Messages,
  DateUtils,
  uCommon;

const
  SOH = #$1;
  STX = #$2;
  ETX = #$3;
  EOH = #$4;
  ENQ = #$5;
  ACK = #$6;
  NAK = #$15;
  EOT = #$04;
  TAB = #$09;
  HexString : String = '0123456789ABCDEF';

type CString = string[100];

  function HexToBinary(Hexadecimal: string): string;
  function BinaryToHex(Binary:string):string;
  procedure Hex2BinFile(aFilName,aHeader,aHexData:string);
  function posCount(SubStr,S:string):integer;
  function PosIndex(SubStr,S:string;nIndex:integer):integer;
  function Dec2Hex(N: LongInt; A: Byte): string;
  function Dec2Hex64(N: int64; A: Byte): string;
  procedure SetBitB(var b:byte; BittoSet: integer);
  procedure ClearBitB(var b:byte; BitToClear: integer);
  function IsBitSetB(const b:byte; BitToCheck:integer):Boolean;
  Function MakeCSData(aData: string;nCSType:integer=0):String;
  Function MakeCSDataHexCheckSum(aData: string;aHexChecSum:string='00'):String;
  Function MakeHexCSData(aHexData: string;nCSType:integer=0):String;
  Function MakeHexCSDataHexCheckSum(aData: string;aHexChecSum:string='00'):String;
  function MakeSum(st:string;nCSType:integer=0):Char;
  function MakeSumHexCheckSum(aData:string;aHexChecSum:string='00'):Char;
  function MakeHexSum(aHex:string;nCSType:integer=0):Char;
  function MakeHexSumHexCheck(aData:string;aHexChecSum:string='00'):Char;
  Function DataConvert1(aMakeValue:Byte;aData:String):String;
  Function DataConvert2(aMakeValue:Byte;aData:String):String;
  function EncodeData(aKey:Byte; aData: String): String;
  function ExtractNumbers(const Text: string): string;
  function ToHexStr(st:string;aSpace:Boolean=True):String;
  function ToHexStrNoSpace(st:string):String;
  function Hex2Ascii(St: String): String;
  Function Hex2DecStr(S:String):String;
  function Hex2Dec(const S: string): Longint;
  function Hex2Dec64(const S: string): int64;
  function Isdigit(st: string):Boolean;
  function BinToInt(Value : String) : Integer;
  function Setlength(st : String; aLength : Integer): String;
  function FillZeroStrNum(aNo:String; aLength:Integer;bFront:Boolean = True): string;
  function FillZeroNumber(aNo:LongInt; aLength:Integer): string;
  function FillZeroNumber2(aNo:Int64; aLength:Integer): string;
  function IntToBin(Value: Longint; Digits:Integer): string;
  Function FindCharCopy(SourceStr : String; Index : integer; aChar:Char) : String;
  procedure ErrorLogSave(aError:String;ast:string);
  Function MakeDatetimeStr(aTime: String):String;
  function IncTime(ATime: TDateTime; Hours, Minutes, Seconds,
    MSecs: Integer): TDateTime;
  function DecTime(ATime: TDateTime; Hours, Minutes, Seconds,
    MSecs: Integer): TDateTime;
  procedure SaveFileNew(aFileName,ast:string);
  procedure LogSave(aFileName,ast:string);
  procedure FileAdd(aFileName,ast:string);
  Function DeleteChar(st : String; DelChar : Char) : String;
  procedure Delay(Milliseconds: DWORD);
  procedure MyDelay(Milliseconds: DWORD);
  procedure GridtoFile(adbGrid: TDBGrid; aFileName: string);
  function DelChars(const S: string; Chr: Char): string;
  function ActivateScreenSaver( Activate : Boolean ) : Boolean;
  function DecodeCardNo(aCardNo: string;aLength:integer = 8;bHex :Boolean = False): String;
  function EncodeHEXCardNo(aCardNo: string): String;
  function EncodeCardNo(aCardNo: string): String;
  function Get_Local_IPAddr : string;
  function GetNodeByText(ATree : TTreeView; AValue:String; AVisible: Boolean): TTreeNode;
  procedure Snooze(ms: Cardinal);
  Procedure ShellExecute_AndWait(FileName:String;Params:String);
  function HexToIP(aHex:string):string;
  function MacFormat(aMac:string):string;
  function IPtoHex(aIP:string):string;
  function CheckIPType(aIP:string;aZeroType:Boolean):Boolean;
  function PortToHex(aPort:string):string;
  function FillSpace(aData:string;aLen:integer):string;
  procedure My_RunDosCommand(Command : string;  nShow : Boolean = False; bWait:Boolean = True);
  function MyF_UsingWinNT: Boolean;
  procedure MyProcessMessage;
  function Ascii2Hex(aData:string;bReverse:Boolean = False;bSpace:Boolean=False):string;
  procedure FileAppend(aFileName,ast:string);
  function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
  function GetBuildDateTime: TDateTime;

  var
  CheckSumAdd2: String;

Implementation

function Ascii2Hex(aData:string; bReverse:Boolean = False; bSpace:Boolean=False):string;
var
  i : integer;
  stHex : string;
  nLen : integer;
begin
  stHex := '';
  nLen := Length(aData);
  for i:= 1 to nLen do
  begin
    if Not bReverse then stHex := stHex + Dec2Hex(Ord(aData[i]),2)
    else stHex := Dec2Hex(Ord(aData[i]),2) + stHex;
    if bSpace then stHex := stHex + ' ';
  end;
  result := stHex;
end;

procedure Hex2BinFile(aFilName,aHeader,aHexData:string);
 var
 Texta, Buffer : PChar;
 CHKready:Tfilestream;
 before:String;
 i: integer;
begin
  CHKReady:=Tfilestream.Create(aFilName,fmCreate ,fmShareDenyWrite );
  try
    CHKReady.Write(aHeader[1], Length(aHeader));
    before:=aHexData;
    Texta := PChar(before);
    GetMem(Buffer, 2);
    for i:= 0 to length(aHexData) div 2 - 1 do begin
      FillChar(Buffer^, 2, #0);
      HexToBin(Pchar(before) +(i*2), Buffer, 2);
      //Delete(before,1,2);
      //before := before + 2;
      Application.ProcessMessages;
      CHKReady.WriteBuffer(buffer^,sizeof(buffer^));
    end;
  finally
    FreeMem(Buffer, 2);
    chkready.Free;
  end;
end;

function HexToBinary(Hexadecimal: string): string;
const 
  BCD: array [0..15] of string = 
    ('0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', 
    '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'); 
var 
  i: integer; 
begin 
  for i := Length(Hexadecimal) downto 1 do 
    Result := BCD[StrToInt('$' + Hexadecimal[i])] + Result; 
end;

function BinaryToHex(Binary:string):string;
function Bit2Dec(aBit:string):integer;
begin
  result := 0;
  if Length(aBit) <> 4 then Exit;
  result := strtoint(aBit[1]) * 8 +
            strtoint(aBit[2]) * 4 +
            strtoint(aBit[3]) * 2 +
            strtoint(aBit[4]) * 1;
end;
var
  nReminder : integer;
  i : integer;
  nDiv : integer;
  nDec : integer;
begin
  result := '';
  nReminder := length(Binary) mod 4;
  if nReminder <> 0 then
  begin
    for i := nReminder to 3 do
    begin
      Binary := '0' + Binary;
    end;
  end;
  nDiv := length(Binary) div 4;
  if length(Binary) = 0 then Exit;
  for i := 1 to nDiv do
  begin
    nDec := Bit2Dec(copy(Binary,(i - 1) * 4 + 1,4));
    result := result + Dec2Hex(nDec,1);
  end;
end;

function posCount(SubStr,S:string):integer;
var
  nCount : integer;
  stTemp : string;
  nPosition : integer;
begin
  nCount := 0;
  stTemp := S;
  nPosition := pos(substr,stTemp);
  while Not(nPosition = 0) do
  begin
    inc(nCount);
    stTemp := copy(stTemp,nPosition + 1 ,Length(stTemp) - nPosition);
    nPosition := pos(substr,stTemp);
  end;
  result := nCount;
end;
function PosIndex(SubStr,S:string;nIndex:integer):integer;
var
  nPosition : integer;
  stTemp : string;
  i : integer;
  nTemp : integer;
begin
  nPosition := 0;
  stTemp := S;
  nTemp := pos(substr,stTemp);
  for i := 1 to nIndex do
  begin
    nPosition := nPosition + nTemp;
    stTemp := copy(stTemp,nTemp + 1 ,Length(stTemp) - nTemp);
    nTemp := pos(substr,stTemp);
  end;
  result := nPosition;
end;
Procedure ShellExecute_AndWait(FileName:String;Params:String);
var
  exInfo : TShellExecuteInfo;
  Ph     : DWORD;
  errmsg  : String;
begin
 FillChar( exInfo, Sizeof(exInfo), 0 );
 with exInfo do
 begin
   cbSize:= Sizeof( exInfo );
   fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
   Wnd := GetActiveWindow();
   ExInfo.lpVerb := 'open';
   ExInfo.lpParameters := PChar(Params);
   lpFile:= PChar(FileName);
   nShow := SW_SHOWNORMAL;
 end;
 if ShellExecuteEx(@exInfo) then
 begin
   Ph := exInfo.HProcess;
 end
 else
 begin
   errmsg:= SysErrorMessage(GetLastError);
   Application.MessageBox (PChar(errmsg),PChar('error'),MB_ICONSTOP or MB_OK);
   exit;
 end;

 while WaitForSingleObject(ExInfo.hProcess, 50) <> WAIT_OBJECT_0 do
 Application.ProcessMessages;
 CloseHandle(Ph);
end;

procedure Snooze(ms: Cardinal);
var
  Stop: Cardinal;
begin
  SetTimer(Application.Handle, 1235, ms, nil);
  Stop := GetTickCount + ms;
  repeat
    Application.HandleMessage;
  until Application.Terminated or (Integer(GetTickCount - Stop) >= 0);
  KillTimer(Application.Handle, 1235);
end;

function GetNodeByText(ATree : TTreeView; AValue:String; AVisible: Boolean): TTreeNode;
var
    Node: TTreeNode;
begin

  Result := nil;
  if ATree.Items.Count = 0 then Exit;
  Node := ATree.Items[0];
  while Node <> nil do
  begin
    if UpperCase(Node.Text) = UpperCase(AValue) then
    begin
      Result := Node;
      if AVisible then
        Result.MakeVisible;
      Break;
    end;
    Node := Node.GetNext;
  end;
end;

function DecodeCardNo(aCardNo: string;aLength:integer = 8;bHex :Boolean = False): String;
var
  I: Integer;
  st: string;
  bCardNo: int64;
begin

  for I := 1 to aLength do
  begin

    if (I mod 2) <> 0 then
    begin
      aCardNo[I] := Char((Ord(aCardNo[I]) shl 4));
    end else
    begin
      aCardNo[I] := Char(Ord(aCardNo[I]) - $30); //�����Ϻ��� 0���� �����.
      //st:= st + char(ord(aCardNo[I-1]) +ord(aCardNo[I]));
      st:= st + char(ord(aCardNo[I-1]) + ord(aCardNo[I]))
    end;
    //aCardNo[I] := Char(Ord(aCardNo[I]) - $30);
    //st := st + aCardNo[I];
  end;
  st:= tohexstrNospace(st);
  bCardNo:= Hex2Dec64(st);
  st:= FillZeroNumber2(bCardNo,10);
  //SHowMessage(st);
  Result:= st;

end;

function EncodeHEXCardNo(aCardNo: string): String;
begin
  Result:= Dec2Hex64(StrtoInt64(aCardNo),8);
end;

function EncodeCardNo(aCardNo: string): String;
var
  I: Integer;
  xCardNo: String;
  st: String;
begin
  aCardNo:= Dec2Hex64(StrtoInt64(aCardNo),8);
  xCardNo:= Hex2Ascii(aCardNo);
  for I:= 1 to 4 do
  begin
    st := st + Char((Ord(xCardNo[I]) shr 4) + $30) + Char((Ord(xCardNo[I]) and $F) + $30);
  end;
  Result:= st;
end;

function ActivateScreenSaver( Activate : Boolean ) : Boolean;
var
  IntActive : Byte;
begin
  if Activate then
     IntActive := 1
  else
     IntActive := 0;

  Result := SystemParametersInfo( SPI_SETSCREENSAVEACTIVE, IntActive, nil, 0 );
end;


function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do begin
    if Result[I] = Chr then Delete(Result, I, 1);
  end;
end;

{DBGrid�� CSVȭ�Ϸ� ����}
procedure GridtoFile(adbGrid: TDBGrid; aFileName: string);
var
//  I: Integer;
  st: string;
  st2:string;
  CurMark: TBookmark;
  CurColumn: Integer;
  aStringList: Tstringlist;
begin

  aStringList := TStringList.Create;
  aStringList.Clear;
  //�׸��� ���� ����

  with aDBGrid.Columns do
  begin
    for CurColumn := 0 to Count - 1 do
    begin
      if (CurColumn > 0) then st := st + ', ';
      st := st + aDBGrid.Columns.Items[CurColumn].Title.Caption;
    end;
    aStringList.Add(st);
  end;
  //Title ����
  with aDBGrid.DataSource.Dataset do
  begin
    DisableControls;
    CurMark := GetBookmark; {���� ���ڵ� ������ ����}
    First;
    while not eof do
    begin
      st := '';
      for CurColumn := 0 to aDBGrid.Columns.Count - 1 do
      begin
        if (CurColumn > 0) then st := st + ', ';
        st2:=aDBGrid.Columns[CurColumn].Field.Text;
        st2:= DelChars(st2,',');
        st := st +st2 ; {�ʵ尪}
      end;
      aStringList.Add(st);
      Next;
    end;
    GotoBookmark(CurMark);
    EnableControls;
  end;

  aStringList.SaveToFile(aFileName);
  aStringList.Free;

end;
{
procedure Delay(MSecs: Longint;TSC : TCriticalSection = nil);
var
  FirstTickCount, Now: Longint;
begin
  FirstTickCount := GetTickCount;
  repeat
    if Application.Terminated then Break;

    if TSC <> nil then TSC.Enter;
    sleep(1);
    //Application.ProcessMessages; // ProcessMessages ���� �浹 �߻����� sleep �� �ٲ�
    if TSC <> nil then TSC.Leave;
    { allowing access to other controls, etc. }
{    Now := GetTickCount;
  until (Now - FirstTickCount >= MSecs) or (Now < FirstTickCount);
end; }

procedure Delay(Milliseconds: DWORD);
{by Hagen Reddmann}
var
  Tick: DWORD;
  NowTick: DWORD;
  Event: THandle;
begin
  Event := CreateEvent(nil, False, False, nil);
  try
    //WaitForSingleObject(Event,Milliseconds);

    Tick := GetTickCount + DWORD(Milliseconds);
    while (Milliseconds > 0) and
      (MsgWaitForMultipleObjects(1, Event, False, Milliseconds,
      QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      sleep(1);
      //MyProcessMessage;
      Application.ProcessMessages;
      Try
        NowTick := GetTickCount;
        if Tick > NowTick then
          Milliseconds := Tick - NowTick
        else Milliseconds := 0 ;
      Except
        Exit;
      End;
    end;
  finally
    CloseHandle(Event);
  end;
end;

procedure MyDelay(Milliseconds: DWORD);
{by Hagen Reddmann}
var
  Tick: DWORD;
  NowTick: DWORD;
  Event: THandle;
begin
  Event := CreateEvent(nil, False, False, nil);
  try
    //WaitForSingleObject(Event,Milliseconds);

    Tick := GetTickCount + DWORD(Milliseconds);
    while (Milliseconds > 0) and
      (MsgWaitForMultipleObjects(1, Event, False, Milliseconds,
      QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      sleep(1);
      MyProcessMessage;
      //Application.ProcessMessages;
      Try
        NowTick := GetTickCount;
        if Tick > NowTick then
          Milliseconds := Tick - NowTick
        else Milliseconds := 0 ;
      Except
        Exit;
      End;
    end;
  finally
    CloseHandle(Event);
  end;
end;

Function DeleteChar(st : String; DelChar : Char) : String;
begin
  While POS(DelChar,st) <> 0 do
    st := Copy(st,1,POS(DelChar,st)-1) + Copy(st,POS(DelChar,st)+1,255);
  Result := st;
end;

procedure SaveFileNew(aFileName,ast:string);
Var
  f: TextFile;
  st: string;
begin
  {$I-}
  AssignFile(f, aFileName);
  Rewrite(f);
  WriteLn(f,st);
  System.Close(f);
  {$I+}
end;


procedure LogSave(aFileName,ast:string);
Var
  f: TextFile;
  st: string;
begin
  {$I-}
  AssignFile(f, aFileName);
  Append(f);
  if IOResult <> 0 then Rewrite(f);
  st := FormatDateTIme('yyyy-mm-dd hh:nn:ss:zzz">"',Now) + ' ' + ast;
  WriteLn(f,st);
  System.Close(f);
  {$I+}
end;

procedure FileAdd(aFileName,ast:string);
Var
  f: TextFile;
//  st: string;
begin
  {$I-}
  AssignFile(f, aFileName);
  Append(f);
  if IOResult <> 0 then Rewrite(f);
  WriteLn(f,ast);
  System.Close(f);
  {$I+}
end;

Function MakeDatetimeStr(aTime: String):String;
begin
  MakeDatetimeStr:= Copy(aTime,1,4)+'-'+Copy(aTime,5,2)+'-'+Copy(aTime,7,2) +' '+
                    Copy(aTime,9,2)+':'+Copy(aTime,11,2)+':'+Copy(aTime,13,2);
end;

procedure ErrorLogSave(aError:String;ast:string);
Var
  f: TextFile;
  st: string;
  aFileName: String;
begin
  {$I-}
  aFileName:= 'c:\ktams\log\log'+ FormatDateTIme('yyyymmdd',Now)+'.log';
  AssignFile(f, aFileName);
  Append(f);
  if IOResult <> 0 then Rewrite(f);
  st := FormatDateTIme('hh:nn:ss:zzz">"',Now) + '['+aError+']' + ast;
  WriteLn(f,st);
  System.Close(f);
  {$I+}
end;


Function FindCharCopy(SourceStr : String; Index : integer; aChar:Char) : String;
Var
  a, b : Integer;
  st   : String;
begin
  a := 0;
//  b := 1;
  st := '';
  if (Length(SourceStr) < 1) then begin result:= ''; exit;  end;
  for b:=1 to Length(SourceStr) do
  begin
    if a = index then break;
    if SourceStr[b] = aChar then Inc(a);
  end;
  if (a = Index) then
  begin
    while (b <= Length(SourceStr)) and (SourceStr[b] <> aChar) do
    begin
      st := st + SourceStr[b];
      Inc(b);
    end;
  end;
  Result := st;
end;

function IntToBin(Value: Longint; Digits:Integer): string;
begin
  Result := '';
  if Digits > 32 then Digits := 32;
  while Digits > 0 do begin
    Dec(Digits);
    Result := Result + IntToStr((Value shr Digits) and 1);
  end;
end;

function FillZeroStrNum(aNo:String; aLength:Integer;bFront:Boolean = True): string;
var
  I       : Integer;
  st      : string;
  strNo   : String;
  StrCount: Integer;
begin
  Strno:= aNo;
  StrCount:= Length(Strno);
  St:= '';
  StrCount:=  aLength - StrCount;
  if StrCount > 0 then
  begin
    st:='';
    for I:=1 to StrCount do St:=st+'0';
    if bFront then St:= St + StrNo
    else St:= StrNo + St;
    FillZeroStrNum:= st;
  end else FillZeroStrNum:= copy(Strno,1,aLength);
end;

function FillZeroNumber(aNo:LongInt; aLength:Integer): string;
var
  I       : Integer;
  st      : string;
  strNo   : String;
  StrCount: Integer;
begin
  Strno:= InttoStr(aNo);
  StrCount:= Length(Strno);
  St:= '';
  StrCount:=  aLength - StrCount;
  if StrCount > 0 then
  begin
    st:='';
    for I:=1 to StrCount do St:=st+'0';
    St:= St + StrNo;
    FillZeroNumber:= st;
  end else FillZeroNumber:= copy(Strno,1,aLength);
end;

function FillZeroNumber2(aNo:INt64; aLength:Integer): string;
var
  I       : Integer;
  st      : string;
  strNo   : String;
  StrCount: Integer;
begin
  Strno:= InttoStr(aNo);
  StrCount:= Length(Strno);
  St:= '';
  StrCount:=  aLength - StrCount;
  if StrCount > 0 then
  begin
    st:='';
    for I:=1 to StrCount do St:=st+'0';
    St:= St + StrNo;
    FillZeroNumber2:= st;
  end else FillZeroNumber2:= copy(Strno,1,aLength);
end;






function Setlength(st : String; aLength : Integer) : String;
begin
  result := st;
  while Length(Result) < aLength do
    Result := Result + ' ';
  Result := Copy(Result,1,aLength);
end;

function BinToInt(Value : String) : Integer;
var
  i   : Integer;
begin
  Result := 0;
  for i := 1 to Length(Value) do
  begin
    Result := Result shl 1;
    Result := Result + Integer((Value[i] = '1'));
  end;
end;


function Dec2Hex(N: LongInt; A: Byte): string;
begin
  Result := IntToHex(N, A);
end;

function Dec2Hex64(N: int64; A: Byte): string;
begin
    Result := IntToHex(N, A);
end;

Function Hex2DecStr(S:String):String;
var
  i: longint;
  L: int64;
begin
  L:=0;
  for i := 1 to length(S) do L:=L*16 + pos(S[i],HexString)-1;
  Result:=intToStr(L);
end;


procedure SetBitB(var b:byte; BittoSet: integer);
{ set a bit in a byte }
begin
  if (BittoSet < 0) or (BittoSet > 7) then exit;
  b:= b or ( 1 SHL BittoSet);
end;

procedure ClearBitB(var b:byte; BitToClear: integer);
{ clear a bit in a byte }
begin
  if (BitToClear < 0) or (BitToClear > 7) then exit;
  b := b and not (1 shl BitToClear);
end;

function IsBitSetB(const b:byte; BitToCheck:integer):Boolean;
{ Test bit in a byte }
begin
  Result := false;
  if (BitToCheck < 0) or (BitToCheck > 7) then exit;
  Result := (b and (1 shl BitToCheck)) <> 0;
end;

function MakeSum(st:string;nCSType:integer=0):Char;
var
  i: Integer;
  aBcc: Byte;
  BCC: string;
begin
  aBcc := Ord(st[1]);
  for i := 2 to Length(st) do
  begin
    aBcc := aBcc + Ord(st[i]);
  end;
  if nCSType = 1 then
  begin
    aBcc := aBcc + Ord(#$A7);
  end else if nCSType = 2 then
  begin
    aBcc := aBcc + Ord(#$9E);
  end;
  BCC := Chr(aBcc);
  Result := BCC[1];
end;

function MakeSumHexCheckSum(aData:string;aHexChecSum:string='00'):Char;
var
  i: Integer;
  aBcc: Byte;
  BCC: string;
begin
  aBcc := Ord(aData[1]);
  for i := 2 to Length(aData) do
  begin
    aBcc := aBcc + Ord(aData[i]);
  end;
  aBcc := aBcc + Hex2Dec(aHexChecSum);
  BCC := Chr(aBcc);
  Result := BCC[1];
end;


function MakeHexSum(aHex:string;nCSType:integer=0):Char;
var
  i: Integer;
  aBcc: Byte;
  BCC: string;
begin
  aBcc := 0;
  for i := 1 to (Length(aHex) div 2) do
  begin
    //aBcc := aBcc + Ord(Hex2Ascii(copy(aHex,(i * 2) - 1,2)));
    aBcc := aBcc + Hex2Dec(copy(aHex,(i * 2) - 1,2));
  end;

{ // �������� : ��� CS uPort�� ������ CS (CheckSumAdd)������ nCSType�� �����Ǿ� ���� ��.
  if nCSType = 1 then
  begin
    aBcc := aBcc + Ord(#$A7);
  end else if nCSType = 2 then
  begin
    aBcc := aBcc + Ord(#$9E);
  end;
}

  // �߰����� : ��� CS uPort�� ������ CS (CheckSumAdd)������ �Ϲ�ȭ �Ѵ�.
  aBcc := aBcc +Hex2Dec(CheckSumAdd2);   // By me : ��� CS uPort�� ������ CS (CheckSumAdd)�� �߰��Ѵ�.

  BCC := Chr(aBcc);
  Result := BCC[1];
end;

function MakeHexSumHexCheck(aData:string;aHexChecSum:string='00'):Char;
var
  i: Integer;
  aBcc: Byte;
  BCC: string;
begin
  aBcc := 0;
  for i := 1 to (Length(aData) div 2) do
  begin
    //aBcc := aBcc + Ord(Hex2Ascii(copy(aHex,(i * 2) - 1,2)));
    aBcc := aBcc + Hex2Dec(copy(aData,(i * 2) - 1,2));
  end;
  aBcc := aBcc + Hex2Dec(aHexChecSum);
  BCC := Chr(aBcc);
  Result := BCC[1];
end;


{CheckSum�� �����}
Function MakeCSData(aData: string;nCSType:integer=0):String;
var
  aSum: Integer;
//  I: Integer;
  st: string;
begin
  aSum:= Ord(MakeSum(aData,nCSType));
  aSum:= aSum*(-1);
  st:= Dec2Hex(aSum,2);

  Result:= copy(st,Length(st)-1,2);
end;
Function MakeCSDataHexCheckSum(aData: string; aHexChecSum:string='00'):String;
var
  aSum: Integer;
//  I: Integer;
  st: string;
begin
  aSum:= Ord(MakeSumHexCheckSum(aData,aHexChecSum));
  aSum:= aSum*(-1);
  st:= Dec2Hex(aSum,2);

  Result:= copy(st,Length(st)-1,2);
end;

Function MakeHexCSData(aHexData: string;nCSType:integer=0):String;
var
  aSum: Integer;
//  I: Integer;
  st: string;
begin
  aSum:= Ord(MakeHexSum(aHexData,nCSType));
  aSum:= aSum*(-1);
  st:= Dec2Hex(aSum,2);
  st := copy(st,Length(st)-1,2);
  Result := Ascii2Hex(st);
end;

Function MakeHexCSDataHexCheckSum(aData: string;aHexChecSum:string='00'):String;
var
  aSum: Integer;
//  I: Integer;
  st: string;
begin
  aSum:= Ord(MakeHexSumHexCheck(aData,aHexChecSum));
  aSum:= aSum*(-1);
  st:= Dec2Hex(aSum,2);
  st := copy(st,Length(st)-1,2);
  Result := Ascii2Hex(st);
end;

{���� ��ȣ��(BIT4,BIT3,BIT2,BIT1,BIT0) �� data�� XOR �Ѵ�.}
Function DataConvert1(aMakeValue:Byte;aData:String):String;
var
  I: Integer;
  bData: String;
begin
  bData:= aData;
  for I:= 1 to Length(bData) do
  begin
    bData[I]:= Char(ord(bData[I]) XOR aMakeValue);
  end;
  Result:= bData;
end;

{ ���� ��ȣ��(BIT4,BIT3,BIT2,BIT1,BIT0) �� data�� XOR �� Message No�� ���� Nibble�� �ٽ� XOR �Ѵ�.}
Function DataConvert2(aMakeValue:Byte;aData:String):String;
var
  I: Integer;
  bMakeValue: Byte;
//  st: string;
  bData: String;
  TempByte: Byte;
begin
  bData:= aData;
  {13���� Byte �� MessageNo}
  bMakeValue:= Ord(aData[13]) and $F;
  Result:= '';
  for I:= 1 to Length(bData) do
  begin
    if I <> 13 then
    begin
      TempByte:= ord(bData[I]) XOR aMakeValue;
      bData[I]:= Char(TempByte XOR bMakeValue);
    end;
  end;
  Result:= bData;
end;

function EncodeData(aKey:Byte; aData: String): String;
var
  Encodetype: Integer;
  aMakeValue: Byte;
  I: Integer;
begin
  EncodeType:= aKey SHR 6; //7,6 �� Bit�� ���ڵ� Ÿ��
  aMakeValue:= aKey;
  for I:= 5 to 7 do ClearBitB(aMakeValue,I); //1,2,3,4,5 Bit�� ������ȣ

  case EncodeType of
    0: Result:= DataConvert1(aMakeValue,aData);
    1: Result:= DataConvert2(aMakeValue,aData);
    else Result:= aData;
  end;
end;

function ExtractNumbers(const Text: string): string;
var
  CharIndex: Integer;
begin
  Result := '';
  for CharIndex := 1 to Length(Text) do
  begin
    if IsDigit(Text[CharIndex]) then
      Result := Result + Text[CharIndex];
  end;
end;

function ToHexStr(st:string;aSpace:Boolean=True):String;
var
  I : Integer;
  st2: string;
  st3: string[3];
begin
  for I:= 1 to length(st) do
  begin
    st3:= Dec2Hex(ord(st[I]),1);
    if Length(st3) < 2 then st3:= '0'+ st3;
    if aSpace then st2:=st2 +st3 +' '
    else st2:=st2 +st3;
  end;
  ToHexStr:= st2;
end;

function ToHexStrNoSpace(st:string):String;
var
  I : Integer;
  st2: string;
  st3: string[3];
begin
  for I:= 1 to length(st) do
  begin
    st3:= Dec2Hex(ord(st[I]),1);
    if Length(st3) < 2 then st3:= '0'+ st3;
    st2:=st2 +st3;
  end;
  ToHexStrnospace:= st2;
end;


function Hex2Ascii(St: String): String;
var
  st2: string;
  I: Integer;
  aLength: Integer;
  aa: Integer;
begin
  st2:= '';
  for I:= 1 to Length(st) do
  begin
    if st[i] <> #$20 then st2:= st2 + st[I];
  end;

  if Length(st2) MOD 2 <> 0 then
  begin
    aLength:= Length(st2);
    st:= copy(st2,1,aLength-1) + '0'+ st2[aLength];
  end else
  begin
   st:= st2;
  end;

  st2:= '';
  while st <> '' do
  begin
    aa:= Hex2Dec(copy(st,1,2));
    st2:= st2 + Char(aa);
    delete(st,1,2);
  end;
  Hex2Ascii:= st2;
end;

function Hex2Dec(const S: string): Longint;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then HexStr := '$' + S
  else HexStr := S;
  Result := StrToIntDef(HexStr, 0);
end;

function Hex2Dec64(const S: string): int64;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then HexStr := '$' + S
  else HexStr := S;
  Result := StrToInt64Def(HexStr, 0);
end;

function Isdigit(st: string):Boolean;
var
  I: Integer;
begin
  result:=True;
  if Length(st) < 1 then
  begin
    result:=False;
    Exit;
  end;
  for I:=1 to Length(st) do
    if (st[I]< '0') or (st[I] > '9')  then result:=False
end;

function GetNibble(aValue: Byte; NibbleHi:Byte; NibbleLo:Byte):Boolean;
begin
//  NibbleHi := aValue shr 4;
//  NibbleLo := aValue and $F;
  Result:= True;
end;

function IncTime(ATime: TDateTime; Hours, Minutes, Seconds,
  MSecs: Integer): TDateTime;
begin
  Result := ATime + (Hours div 24) + (((Hours mod 24) * 3600000 +
    Minutes * 60000 + Seconds * 1000 + MSecs) / MSecsPerDay);
  if Result < 0 then Result := Result + 1;
end;

function DecTime(ATime: TDateTime; Hours, Minutes, Seconds,
  MSecs: Integer): TDateTime;
begin
  Result := ATime - (Hours div 24) - (((Hours mod 24) * 3600000 -
    Minutes * 60000 - Seconds * 1000 + MSecs) / MSecsPerDay);
  if Result < 0 then Result := Result + 1;
end;

function Get_Local_IPAddr : string;
 type
   TaPInAddr = array [0..10] of PInAddr;
   PaPInAddr = ^TaPInAddr;
 var
   phe : PHostEnt;
   pptr : PaPInAddr;
   Buffer : array [0..63] of char;
   I : Integer;
   GInitData : TWSADATA;
begin
 try
   WSAStartup($101, GInitData);
   Result := '';
   GetHostName(Buffer, SizeOf(Buffer));
   phe := GetHostByName(buffer);
   if phe = nil then Exit;
   pptr := PaPInAddr(Phe^.h_addr_list);
   i := 0;
   result := '';
   while pptr^[I] <> nil do
   begin
     result:= result + StrPas(inet_ntoa(pptr^[I]^)) + ' ';
     Inc(I);
   end;
 finally WSACleanup; end;
end;
function HexToIP(aHex:string):string;
var
  stData:string;
//  stTemp : string;
//  nTemp : integer;
  i : integer;
begin
  if Length(aHex) < 8 then
  begin
    result := '';
    Exit;
  end;
  aHex := Hex2Ascii(aHex);
  stData := '';
  for i:=1 to 4 do
  begin
    if I < 4 then stData := stData + IntToStr(Ord(aHex[I])) + '.'
    else stData := stData + IntToStr(Ord(aHex[I]));
  end;
  result := stData ;
end;

function MacFormat(aMac:string):string;
begin
  result := copy(aMac,1,2) + ':' +
            copy(aMac,3,2) + ':' +
            copy(aMac,5,2) + ':' +
            copy(aMac,7,2) + ':' +
            copy(aMac,9,2) + ':' +
            copy(aMac,11,2);

end;
function IPtoHex(aIP:string):string;
var
  stTemp : string;
  i : integer;
  nTemp : integer;
  stData : string;
begin
  stData := '';
  for i := 0 to 3 do
  begin
    stTemp  := FindCharCopy(aIP, i, '.');
    if isdigit(stTemp) then nTemp  := StrToInt(stTemp);
    stData := stData + Char(nTemp);
  end;
  result := ToHexStrNoSpace(stData);

end;

function CheckIPType(aIP:string;aZeroType:Boolean):Boolean;
var
  stTemp : string;
  i : integer;
  nSum : integer;
  nTemp : integer;
begin
  Result := False;
  nSum := 0;
  Try
    for i := 0 to 3 do
    begin
      stTemp  := FindCharCopy(aIP, i, '.');
      if isdigit(stTemp) then nTemp  := StrToInt(stTemp);
      if nTemp > 255 then Exit;
      nSum := nSum + nTemp;
    end;
  Except
    Exit;
  End;

  if Not aZeroType then //0.0.0.0 �� �߸��� Ÿ������ �ν��ϴ� ���
  begin
    if nSum = 0 then Exit;
  end;
  result := True;
end;

function PortToHex(aPort:string):string;
var
  stTemp : string;
//  i : integer;
//  nTemp : integer;
  stData : string;
begin
  stData := '';
  if isdigit(aPort) then stTemp := Dec2Hex(StrToInt(aPort), 2);
  if Length(stTemp) < 4 then stTemp := '0' + stTemp;
  stData := Chr(Hex2Dec(Copy(stTemp, 1, 2))) + Char(Hex2Dec(Copy(stTemp, 3, 2)));
  result := ToHexStrNoSpace(stData);

end;


function FillSpace(aData:string;aLen:integer):string;
var
  i:integer;
begin
  if Length(aData)>= aLen then
  begin
    result := copy(aData,1,aLen);
    Exit;
  end;
  for i:= Length(aData) to aLen do
  begin
    aData := aData + ' ';
  end;
  result := copy(aData,1,aLen);

end;
// ���� ��� ���� �Լ�/���ν���

function MyF_UsingWinNT: Boolean;
var
  OS: TOSVersionInfo; 
begin 
  OS.dwOSVersionInfoSize := Sizeof(OS); 
  GetVersionEx(OS);
  if OS.dwPlatformId = VER_PLATFORM_WIN32_NT then Result:= True 
  else Result:= False; 
end; 


// ���� ��� ���� ���ν��� 
procedure My_RunDosCommand(Command : string; nShow : Boolean = False; bWait:Boolean = True);
var 
  hReadPipe : THandle; 
  hWritePipe : THandle; 
  SI : TStartUpInfo; 
  PI : TProcessInformation; 
  SA : TSecurityAttributes; 
  SD : TSecurityDescriptor; 
  BytesRead : DWORD; 
  Dest : array[0..1023] of char; 
  CmdLine : array[0..512] of char;
  TmpList : TStringList; 
//  S, Param : string;
  Avail, ExitCode, wrResult : DWORD; 
begin
  if MyF_UsingWinNT then begin
    InitializeSecurityDescriptor(@SD, SECURITY_DESCRIPTOR_REVISION); 
    SetSecurityDescriptorDacl(@SD, True, nil, False); 
    SA.nLength := SizeOf(SA); 
    SA.lpSecurityDescriptor := @SD; 
    SA.bInheritHandle := True; 
    Createpipe(hReadPipe, hWritePipe, @SA, 1024); 
  end else begin 
    Createpipe(hReadPipe, hWritePipe, nil, 1024); 
  end; 
  try 
     //Screen.Cursor := crHourglass; 
     FillChar(SI, SizeOf(SI), 0); 
     SI.cb := SizeOf(TStartUpInfo); 
     if nShow then begin 
       SI.wShowWindow := SW_SHOWNORMAL 
     end else begin 
       SI.wShowWindow := SW_HIDE; 
     end;
     SI.dwFlags := STARTF_USESHOWWINDOW;
     SI.dwFlags := SI.dwFlags or STARTF_USESTDHANDLES; 
     SI.hStdOutput := hWritePipe; 
     SI.hStdError := hWritePipe; 
     StrPCopy(CmdLine, Command); 
     //if CreateProcess(nil,CmdLine , nil, nil, True, NORMAL_PRIORITY_CLASS, nil, nil, SI, PI) then begin
     if CreateProcess(nil,pchar(Command) , nil, nil, True,  DETACHED_PROCESS, nil, nil, SI, PI) then begin
       if bWait then
       begin
         ExitCode := 0;
         while ExitCode = 0 do begin
           wrResult := WaitForSingleObject(PI.hProcess, 50);
           if PeekNamedPipe(hReadPipe, nil, 0, nil, @Avail, nil) then begin 
             if Avail > 0 then begin 
               TmpList := TStringList.Create; 
               try 
                 FillChar(Dest, SizeOf(Dest), 0); 
                 ReadFile(hReadPipe, Dest, Avail, BytesRead, nil); 
               finally
                 TmpList.Free; 
               end; 
             end; 
           end;
           if wrResult <> WAIT_TIMEOUT then begin
             ExitCode := 1;
           end;
           Application.ProcessMessages; 
         end; 
         GetExitCodeProcess(PI.hProcess, ExitCode); 
         CloseHandle(PI.hProcess); 
         CloseHandle(PI.hThread);
       end;
     end; 
  finally 
     CloseHandle(hReadPipe); 
     CloseHandle(hWritePipe); 
     Screen.Cursor := crDefault; 
  end;
end;

procedure MyProcessMessage;
var
  Msg: TMsg;
begin
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    if Msg.Message = WM_QUIT then
    begin
      PostQuitMessage(0);
    end else
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;

procedure FileAppend(aFileName,ast:string);
Var
  f: TextFile;
  st: string;
  stDir : string;
begin
  {$I-}
  stDir := ExtractFilePath(aFileName);
  if not DirectoryExists(stDir) then CreateDir(stDir);

  AssignFile(f, aFileName);
  Append(f);
  if IOResult <> 0 then Rewrite(f);
  st := ast;
  WriteLn(f,st);
  System.Close(f);
  {$I+}
end;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  SystemTime  : TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, FileTime);
  FileTimeToSystemTime(FileTime, SystemTime);
  Result  := SystemTimeToDateTime(SystemTime);
end;

function GetBuildDateTime: TDateTime;
var
  ExeName: string;
  FileHandle: THandle;
  FileInfo: TByHandleFileInformation;
begin
  ExeName := ParamStr(0);
  FileHandle := CreateFile(PChar(ExeName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if FileHandle = INVALID_HANDLE_VALUE then RaiseLastOSError;
  try
    if not GetFileInformationByHandle(FileHandle, FileInfo) then
      RaiseLastOSError;
    Result := FileTimeToDateTime(FileInfo.ftLastWriteTime);
  finally
    CloseHandle(FileHandle);
  end;
end;

end.
