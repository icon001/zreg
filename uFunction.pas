unit uFunction;

interface
uses
uLomosUtil,
AdvGrid,
SysUtils,
stdCtrls,
RzButton,
Gauges,
Forms,
RzEdit,
ExtCtrls,
RzBtnEdt,
Windows;

var
  G_bSendStop : Boolean = False;  //���� ����

//���Թ� Event �� string
Function GetAccEventString(aData:string):string;
//Hex Code�� ǥ��
Function ConvertToHex(aData:string):string;
//���� ������ �����ֱ� ���� Hex ���� ����
Function BroadToHex(aMsgData:String):String;

procedure GridInit(sg:TAdvStringGrid;aCol:integer);

function ResponseCheck(aIndex,aDelay:integer):Boolean;

Function SendStop():Boolean;
Function StringXOR(Src:String;Org:String):Boolean;
Function StrToHex(const S: string): string;
Function StringAND(Src:String;Org:String;len:integer):String;

//Edit ã�� �Լ�
Function TravelEditItem(GroupBox:TGroupBox;stName:string; no:Integer):TEdit;
Function TravelRzEditItem(GroupBox:TGroupBox;stName:string; no:Integer):TRzEdit;
//RzBitBtn ã�� �Լ�
Function TravelRzBitBtnItem(GroupBox:TGroupBox;stName:string; no:Integer):TRzBitBtn;
//CheckBox ã�� �Լ�
Function TravelCheckBoxItem(GroupBox:TGroupBox;stName:string; no:Integer):TCheckBox;
//ComboBox ã�� �Լ�
Function TravelComboBoxItem(GroupBox:TGroupBox;stName:string; no:Integer):TComboBox;
//Panel���� �޺��ڽ� ã�� �Լ�
Function TravelComboBoxItemFromPanel(Panelname:TPanel;stName:string; no:Integer):TComboBox;
//Label ã�� �Լ�
Function TravelLabelItem(GroupBox:TGroupBox;stName:string; no:string):TLabel;
//Gauge ã�� �Լ�
Function TravelGaugeItem(GroupBox:TGroupBox;stName:string; no:string):TGauge;
//TRzButtonEdit ã�� �Լ�
Function TraveTRzButtonEditItem(GroupBox:TGroupBox;stName:string; no:string):TRzButtonEdit;
//TStaticText ã�� �Լ�
Function TravelTStaticTextItem(GroupBox:TGroupBox;stName:string; no:Integer):TStaticText;
//TStaticText ã�� �Լ�
Function TravelTEditTextItem(GroupBox:TGroupBox;stName:string; no:Integer):TEdit;


Function GetDay(aMin:integer):integer;
Function GetHour(aMin:integer):integer;


implementation
uses
  uGlobalVariable;

//���Թ� Event �� string
Function GetAccEventString(aData:string):string;
var
  st: String;
begin
  {1.�ð�}
  st:= Copy(aData,6,2)+'-'+
       Copy(aData,8,2)+'-'+
       Copy(aData,10,2)+' '+
       Copy(aData,12,2)+':'+
       Copy(aData,14,2)+':'+
       Copy(aData,16,2)+';';

  {2.��ư}
  st:= st + aData[23] +';'; //��ư �߰�
  {3.����ȣ}
  st:= st + aData[3]+';';
  {4.����ġ}
  if aData[5] = '0' then
    st:= st + '����' +';'
  else st:= st + '�ܺ�' +';'; //��ư �߰�

  {5.Posi/Nega}
  case aData[18] of
    '0': st:=st + 'Positive;';
    '1': st:= st + 'Negative;';
    '2': st:=st + 'Positive-ACK;';
    '3': st:= st + 'Negative-ACK;';
    '4': st:= st + 'Positive-NAK;';
    else   st:= st+ aData[18] + ';';
  end;
  {6.����}
  case aData[19] of
    '0': st:= st+'����;';
    '1': st:= st+'������;';
    '2': st:= st+'�����;';
    '3': st:= st+'�����͸��;';
    else   st:= st+aData[19]+ ';';
  end;
  {7.�������}
  case aData[20] of
    'C': st:= st + 'ī��;';
    'P': st:= st + '��ȭ;';
    'R': st:= st + '��������;';
    'B': st:= st + '��ư;';
    'S': st:= st + '������;';
    else st:= st + aData[20];
  end;
  {8.���Խ��ΰ��}
  st := st + '(' + aData[21] + ')';
  case aData[21]of
    #$30: st:= st + '�ش���׾���;';
    #$31: st:= st + '���Խ���;';
    #$32: st:= st + '���ī������;'; //���ī������(*)
    #$33: st:= st + '�������;'; //���ī������(*)
    #$34: st:= st + '��������;'; //���ī������(*)
    #$41: st:= st + '�̵��ī��;';
    #$42: st:= st + '���ԺҰ�;';
    #$43: st:= st + '���ī��Ұ�;'; //�̵��ī��(*)
    #$44: st:= st + '��������ԺҰ�;';
    #$45: st:= st + '�������ѽð�;';
    #$46: st:= st + '��ȿ�Ⱓ����;';
    'G' : st:= st + '����;';
    'H' : st:= st + '��������ԺҰ�;';
    'I' : st:= st + '���� �ٸ�;';
    'J' : st:= st + '��Ƽ�н���;';
    'K' : st:= st + 'DS�������ԺҰ�;';
    'L' : st:= st + '�����͸�����ԺҰ�;';
    else st:= st +';';        //aData[21]
  end;
  {9.���Թ� ����}
  case aData[22]of
    'C': st:= st +'����;';
    'O': st:= st +'����;';
    else st:= st +aData[22];
  end;

  Result := st;

end;
//Hex Code�� ǥ��
Function ConvertToHex(aData:string):string;
var
  nLength : integer;
  stData : string;
  stHex :string;
  i : integer;
begin
  nLength := Length(aData);
  stData := '';
  for i:=1 to nLength do
  begin
    stHex := Dec2Hex(Ord(aData[i]),2);
    if ( stHex <= '1F') OR ( stHex >= '7F') then
      stData := stData + '[' + stHex + ']'
    else stData := stData + aData[i];
  end;
  result := stData;
end;

//��ε� ������ Ȯ��� �κ� Hex�� ǥ�� �ȵǴ� �κж����� ������ Hexǥ�� ��
function BroadToHex(aMsgData: String): String;
var
  StTemp : String;
  Loop : Integer;
  nASC : Integer;
begin
  StTemp := copy(aMsgData,1,11);
  for Loop := 1 to 9 do
  begin
//     nASC := 0;
     nASC := byte(aMsgData[Loop + 11]);
     StTemp := StTemp + '[' + IntToHex(nASC,2) + ']';
  end;

  StTemp := StTemp + copy(aMsgData,21,Length(aMsgData) - 20);
  Result := stTemp;
end;

procedure GridInit(sg:TAdvStringGrid;aCol:integer);
var
  i:integer;
begin
  with sg do
  begin
    RowCount := 2;
    //RemoveCheckBox(0,0);
    //RemoveCheckBox(0,1);

    //AddCheckBox(0,0,False,False);
    for i:= 0 to ColCount - 1 do
    begin
      Cells[i,1] := '';
    end;

    for i := aCol to ColCount - 1 do
    begin
      ColWidths[i] := 0;
    end;
  end;
end;

function ResponseCheck(aIndex,aDelay:integer):Boolean;
var
  FirstTickCount : double;
begin
  Try
    G_bResponseChecking := True;
    FirstTickCount := GetTickCount + aDelay;
    While Not G_bDeviceResponse[aIndex] do
    begin
      Application.ProcessMessages;
      if GetTickCount > FirstTickCount then Break;
    end;
    result := G_bDeviceResponse[aIndex];
  Finally
    G_bResponseChecking := False;
  End;
end;

Function SendStop():Boolean;
begin
  while G_bSendStop do
  begin
    sleep(1);
    Application.ProcessMessages;
  end;
end;

Function StringXOR(Src:String;Org:String):Boolean;
var
  bSrc : Byte;
  bOrg : Byte;
//  stSrc,stOrg : String;
  Loop : integer;
  Temp : Byte;
  len : integer;
begin

  Result:= False;
  len := length(src);
  for Loop:=1 to len do
  begin
    bSrc := Byte( Src[Loop] );
    bOrg := Byte( Org[Loop] );
    Temp := bSrc Xor bOrg;
    if Temp = $00 then continue  //0x00 �̸� �����Ƿ� ��� ��
    else exit;
  end;

  Result:= True;
end;

Function StrToHex(const S: string): string;
var
 Index: Integer;
 bSrc : Byte;
begin
 Result := '';
 for Index := 1 to Length(S) do
 begin
   bSrc := Byte( S[Index] );
   if bSrc = $20 then bSrc := $00;
   Result := Result + IntToHex( bSrc, 2 );
 end;
end;

Function StringAND(Src:String;Org:String;len:integer):String;
var
  bSrc : Byte;
  bOrg : Byte;
//  stSrc,stOrg : String;
  Loop : integer;
  Temp : Byte;
begin

  Result:= '';
//  Src := stringreplace(src,' ',inttostring($00));

  for Loop:=1 to len do
  begin
    bSrc := Byte( Src[Loop] );
    if bSrc = $20 then bSrc := $00;
    bOrg := Byte( Org[Loop] );
    Temp := bSrc And bOrg;
    Result:= Result + IntToHex( Temp, 2 );
  end;
end;

Function TravelEditItem(GroupBox:TGroupBox;stName:string; no:Integer):TEdit;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TEdit(GroupBox.Controls[Loop]);
      exit;
    End;
  End;

end;

Function TravelRzEditItem(GroupBox:TGroupBox;stName:string; no:Integer):TRzEdit;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TRzEdit(GroupBox.Controls[Loop]);
      exit;
    End;
  End;

end;

Function TravelRzBitBtnItem(GroupBox:TGroupBox;stName:string; no:Integer):TRzBitBtn;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TRzBitBtn(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;
//CheckBox ã�� �Լ�
Function TravelCheckBoxItem(GroupBox:TGroupBox;stName:string; no:Integer):TCheckBox;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TCheckBox(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;
//ComboBox ã�� �Լ�
Function TravelComboBoxItem(GroupBox:TGroupBox;stName:string; no:Integer):TComboBox;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TComboBox(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;

Function TravelComboBoxItemFromPanel(Panelname:TPanel;stName:string; no:Integer):TComboBox;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to Panelname.ControlCount-1 do
  Begin
    If LowerCase(Panelname.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TComboBox(Panelname.Controls[Loop]);
      exit;
    End;
  End;
end;
//Label ã�� �Լ�
Function TravelLabelItem(GroupBox:TGroupBox;stName:string; no:string):TLabel;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + no then
    Begin
      Result:=TLabel(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;

//Gauge ã�� �Լ�
Function TravelGaugeItem(GroupBox:TGroupBox;stName:string; no:string):TGauge;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + no then
    Begin
      Result:=TGauge(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;

Function TraveTRzButtonEditItem(GroupBox:TGroupBox;stName:string; no:string):TRzButtonEdit;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + no then
    Begin
      Result:=TRzButtonEdit(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;

Function TravelTStaticTextItem(GroupBox:TGroupBox;stName:string; no:Integer):TStaticText;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TStaticText(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;


// �̻��
Function TravelTEditTextItem(GroupBox:TGroupBox;stName:string; no:Integer):TEdit;
var
Loop:integer;
begin
  Result:= Nil;

  For Loop:=0 to GroupBox.ControlCount-1 do
  Begin
    If LowerCase(GroupBox.Controls[Loop].name) = LowerCase(stName) + inttostr(no) then
    Begin
      Result:=TEdit(GroupBox.Controls[Loop]);
      exit;
    End;
  End;
end;



Function GetDay(aMin:integer):integer;
begin
  Result := aMin Div ( 60 * 24 );
end;

Function GetHour(aMin:integer):integer;
var
  nHour:integer;
begin
  nHour := aMin Div 60;
  Result := nHour mod 24;
end;
end.




(*

Procedure BroadDownLoadRom(aDeviceID:String;aFileName: String);
Procedure BroadSendRomData(aDeviceID:String; adata: String);
Procedure BroadFirmwareProcess(aData: String);
Procedure CreateLogDB;
Procedure DoorModeChange(DeviceID: String;  aMode:Char);
Procedure Cnt_Lamp(aDeviceID: String; aOn:Boolean);
Procedure Cnt_Siren(aDeviceID: String; aOn:Boolean);
procedure CheckLocate(aDeviceID: String);
procedure RegLocate(aDeviceID: String;aLocate:String);
function  RecevieDataProcess(aData:String; var bData:String):Boolean;

procedure TMainForm.BroadDownLoadRom(aDeviceID:String;aFileName: String);
var
  I: Integer;
  st: string;
begin
  DownLoadList.Clear;
  DownLoadList.LoadFromFile(aFileName);
  st:= DownLoadList[0];
  BroadSendRomData(aDeviceID,st);

  OffCount:= 0;
  DownLoadCount:= 0;
  ProgressBar1.Position:= 0;
  ProgressBar1.Max:= DownLoadList.Count;
  Label1.Caption:= InttoStr(ProgressBar1.Position)+'/'+ InttoStr(ProgressBar1.Max);
end;

procedure TMainForm.BroadSendRomData(aDeviceID:String; adata: String);
var
  st: string;
  stData: String;
begin

  if BroadID = '03' then
  begin
    st:= 'FP00'+aData;
    Write_ListBox_DownLoadInfo('RomData ����');
  end
  else if BroadID = '04' then
  begin
    st:= 'FD00'+aData;
  end;

  if rdMode.ItemIndex = 3 then stData := 'BI' + '02' + FillZeroNumber(1,7)
  else if rdMode.ItemIndex = 2 then  stData := 'BS' + '02' + FillZeroNumber(1,7);

  st:= 'BD' + BroadID + FillZeroNumber(1,7) + BroadControlerNum + st;

  BroadOrgDataList.Clear;
  BroadOrgDataList.Add(st);
  BroadSendDataList := BroadOrgDataList;   //���� �۽� ������ ����Ʈ�� �߰�

  SendPacket(aDeviceID,'*',st);

end;


procedure TMainForm.BroadFirmwareProcess(aData: String);
var
  aRegCode: String;
begin

  aRegCode:= Copy(aData,19,2);
  //FI:Flash Memory Map
  //FP:Flash Writer File Name
  //FD:Flash Data File Name
  //FX:Flash Start Command

  if aRegCode = 'FI' then
  begin
    IsDownLoad:= True;
    //if cb_Download.Checked = False then  ReceiveFI(aData)
    if rdMode.ItemIndex = 1 then ReceiveFI(aData)
    else Write_ListBox_DownLoadInfo('�߿��� ���׷��̵����� ����');
  end else if aRegCode = 'FP' then
  begin
    //if cb_Download.Checked = False then ReceiveFPFD(aData)
    if rdMode.ItemIndex = 0 then ReceiveFPFD(aData)
    else Write_ListBox_DownLoadInfo('flash write program ����');
  end else if aRegCode = 'FD' then
  begin
    //if cb_Download.Checked = False then ReceiveFPFD(aData)
    if rdMode.ItemIndex = 1 then ReceiveFPFD(aData)
    else Write_ListBox_DownLoadInfo('flash Data program ����');
  end else if aRegCode = 'FX' then
  begin
    //if cb_Download.Checked = False then ReceiveFX(aData)
    if rdMode.ItemIndex = 0 then ReceiveFX(aData)
    else Write_ListBox_DownLoadInfo('flash exec data ��û ����');
  end else  if aRegCode = 'FU' then
  begin

  end else
  begin

  end;
end;

{LOG �����Ϳ� �޸� DB����}
procedure TMainForm.CreateLogDB;
begin
  with DBISAMTable1.FieldDefs do
  begin
     Clear;
     Add('SeqNo',ftInteger,0,True);
     Add('EventTime',ftDatetime,0,False);
     Add('IP',ftString,20,False);
     Add('DeviceID',ftString,10,False);
     Add('DEviceNo',ftString,2,False);
     Add('Cmmd',ftString,3,False);
     Add('Data',ftString,200,False);
     Add('FullData',ftString,200,False);
  end;
  with DBISAMTable1.IndexDefs do
  begin
     Clear;
     Add('','SeqNo',[ixPrimary]);
     Add('ByCompany','Company',[ixCaseInsensitive],'',icDuplicateByte);
  end;
  if not DBISAMTable1.Exists then DBISAMTable1.CreateTable;
end;
Procedure TMainForm.DoorModeChange(DeviceID: String;  aMode:Char);
var
  st: string;
begin

  st:= #$32 +
       //IntToStr(Send_MsgNo)+                      //Msg Count
       '0'+
       InttoStr(gbDoorNo2.ItemIndex +1)+
       //ComboBox_DoorNo3.Text[1]+
       '  '+
       aMode; //'0':� ,'1':����

  ACC_sendData(DeviceID, st);
end;


procedure TMainForm.Cnt_Lamp(aDeviceID: String; aOn: Boolean);
begin
  if aOn then SendPacket(aDeviceID,'R','RY00'+'LP1')
  else        SendPacket(aDeviceID,'R','RY00'+'LP0')
end;

procedure TMainForm.Cnt_Siren(aDeviceID: String; aOn: Boolean);
begin
  if aOn then SendPacket(aDeviceID,'R','RY00'+'SI1')
  else        SendPacket(aDeviceID,'R','RY00'+'SI0');

end;


procedure TMainForm.CheckLocate(aDeviceID: String);
begin
  Edit_Locate.Color:= clWhite;
  Edit_Locate.Text:= '';
  SendPacket(aDeviceID,'Q','IF00');
end;

procedure TMainForm.RegLocate(aDeviceID: String;aLocate:String);
var
  aNo: String[2];
begin

  aLocate:= Setlength(aLocate,16);
  aNo:= Copy(aDeviceID,8,2);
  if   Length(aDeviceID) = 9 then
  begin
    SendPacket(aDeviceID,'I','IF'+aNo+aLocate);
  end else
  begin
    SHowMessage('���ID��  Ȯ���ϼ���');
  end;
end;



function TMainForm.RecevieDataProcess(aData:String; var bData :String):Boolean;
var
//  st: string;
  aIndex: Integer;
  Lenstr: String;
  RealDataLength: Integer;
  StrBuff: String;
begin

  Result:= False;

  Lenstr:= Copy(aData,2,3);
  if not isDigit(Lenstr) then
  begin
    Delete(aData,1,1);
    aIndex:= Pos(STX,aData);
    if aIndex = 0 then
    begin
      aIndex:= Length(aData);
      StrBuff:= Copy(aData,1,aIndex);
    end else
    begin
      StrBuff:= Copy(aData,1,aIndex-1);
    end;


    Delete(aData, 1, Length(StrBuff));
    bData:= aData;
    Exit;
  end;

  RealDataLength:= StrtoInt(Lenstr);

  if aData[RealDataLength] = ETX then
  begin
    RealDataLength:= StrtoInt(LenStr);
    StrBuff:= Copy(aData,1,RealDataLength);
    Result:= True;
    bData:=StrBuff;
    Delete(aData, 1, RealDataLength);
  end else
  begin
    if Length(aData) < RealDataLength then
    begin
      bData:= aData;
      Exit;
    end;
    Delete(aData,1,1);
    aIndex:= Pos(STX,aData);
    StrBuff:= Copy(aData,1,aIndex-1);
    //ReceviePackettoListView(ListView_Comm,2,ClientThread.Socket.PeerIPAddress,'[E0002]'+STX+StrBuff);
    //Codesite.SendError('DATA ERROR:'+STX+StrBuff);
    Delete(aData, 1, aIndex-1);
    bData:= aData;
  end;
end;
*)

