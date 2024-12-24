unit uNewCardReaderFirmWare;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzCmboBx, LMDCustomComponent, LMDIniCtrl;

type
  TfmNewCardReaderFirmWare = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    ed_CMD: TEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    Panel2: TPanel;
    ed_DataCMD: TEdit;
    Label2: TLabel;
    ed_DataNo: TEdit;
    Label3: TLabel;
    ed_DataDest: TEdit;
    Label4: TLabel;
    Bevel2: TBevel;
    Panel3: TPanel;
    ed_FWCMD: TEdit;
    Label7: TLabel;
    ed_FWNO: TEdit;
    Label8: TLabel;
    ed_FWLen: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    ed_FWData: TEdit;
    btn_Send: TButton;
    btn_Exit: TButton;
    ComboBox_IDNO: TRzComboBox;
    Label11: TLabel;
    ed_DataDest2: TEdit;
    Label12: TLabel;
    ed_DataAddr: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    ed_Class: TEdit;
    LMDIniCtrl2: TLMDIniCtrl;
    procedure btn_ExitClick(Sender: TObject);
    procedure ed_FWDataKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_SendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDeviceID: string;
    FVersion: string;
    { Private declarations }
  public
    { Public declarations }
    property DeviceID : string read FDeviceID write FDeviceID;
    property Version : string read FVersion write FVersion;
  end;

var
  fmNewCardReaderFirmWare: TfmNewCardReaderFirmWare;

implementation

uses
  uLomosUtil,
  uMain;

{$R *.dfm}

procedure TfmNewCardReaderFirmWare.btn_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewCardReaderFirmWare.ed_FWDataKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ed_FWLen.Text := Dec2Hex(Length(ed_FWData.text),2);
end;

procedure TfmNewCardReaderFirmWare.btn_SendClick(Sender: TObject);
var
  stData : string;
begin
  if ed_Class.Text = '' then
  begin
    showmessage('�����͸� �Է� �ϼ���.');
    ed_Class.SetFocus;
    Exit;
  end;
  if ed_DataAddr.Text = '' then
  begin
    showmessage('�����͸� �Է� �ϼ���.');
    ed_DataAddr.SetFocus;
    Exit;
  end;
  if ed_FWCMD.Text = '' then
  begin
    showmessage('�����͸� �Է� �ϼ���.');
    ed_FWCMD.SetFocus;
    Exit;
  end;
  stData := ed_DataCMD.Text + ed_DataNo.Text + ed_DataDest.Text + ed_DataDest2.Text + Hex2Ascii(ed_Class.text) +
            Hex2Ascii(ed_DataAddr.Text) + (ed_FWNO.Text) + Hex2Ascii(ed_FWCMD.Text) +
            Hex2Ascii(ed_FWLen.Text) + ed_FWData.Text;

  MainForm.SendPacket(DeviceID + ComboBox_IDNO.Text,ed_CMD.Text[1],stData,Version);
end;

procedure TfmNewCardReaderFirmWare.FormCreate(Sender: TObject);
var
  i : integer;
begin
  ComboBox_IDNO.Clear;
  for i := 0 to 63 do ComboBox_IDNO.Items.Add(FillZeroNumber(i,2));
  ComboBox_IDNO.ItemIndex := 0;

  ed_CMD.Text := LMDIniCtrl2.ReadString('Data','1','R');
  ed_DataCMD.Text := LMDIniCtrl2.ReadString('Data','2','FW');
  ed_DataNo.Text := LMDIniCtrl2.ReadString('Data','3','80');
  ed_DataDest.Text := LMDIniCtrl2.ReadString('Data','4','E');
  ed_DataDest2.Text := LMDIniCtrl2.ReadString('Data','5','E');
  ed_Class.Text := LMDIniCtrl2.ReadString('Data','6','');
  ed_DataAddr.Text := LMDIniCtrl2.ReadString('Data','7','');
  ed_FWNO.Text := LMDIniCtrl2.ReadString('Data','8','');
  ed_FWCMD.Text := LMDIniCtrl2.ReadString('Data','9','');
  ed_FWLen.Text := LMDIniCtrl2.ReadString('Data','10','');
  ed_FWData.Text := LMDIniCtrl2.ReadString('Data','11','');
//  SetForegroundWindow(Handle);
end;

procedure TfmNewCardReaderFirmWare.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   LMDIniCtrl2.WriteString('Data','1',ed_CMD.Text);
   LMDIniCtrl2.WriteString('Data','2',ed_DataCMD.Text);
   LMDIniCtrl2.WriteString('Data','3',ed_DataNo.Text);
   LMDIniCtrl2.WriteString('Data','4',ed_DataDest.Text);
   LMDIniCtrl2.WriteString('Data','5',ed_DataDest2.Text);
   LMDIniCtrl2.WriteString('Data','6',ed_Class.Text);
   LMDIniCtrl2.WriteString('Data','7',ed_DataAddr.Text);
   LMDIniCtrl2.WriteString('Data','8',ed_FWNO.Text);
   LMDIniCtrl2.WriteString('Data','9',ed_FWCMD.Text);
   LMDIniCtrl2.WriteString('Data','10',ed_FWLen.Text);
   LMDIniCtrl2.WriteString('Data','11',ed_FWData.Text); 
end;

end.
