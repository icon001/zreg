unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    btn_Update: TSpeedButton;
    GroupBox1: TGroupBox;
    btn_telecop: TSpeedButton;
    btn_stec: TSpeedButton;
    btn_Close: TSpeedButton;
    btn_Infosec: TSpeedButton;
    btn_Sg: TSpeedButton;
    procedure btn_UpdateClick(Sender: TObject);
    procedure btn_ProgramExecClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_telecopClick(Sender: TObject);
    procedure btn_stecClick(Sender: TObject);
    procedure btn_InfosecClick(Sender: TObject);
    procedure btn_SgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uLomosUtil;

{$R *.dfm}

procedure TForm1.btn_UpdateClick(Sender: TObject);
var
  stExec:string;
begin
  stExec := ExtractFileDir(Application.ExeName) + '\smartupdate\SmartUpdate.exe';
  btn_Update.Enabled := False;
  My_RunDosCommand(stExec,True,False);
//  btn_Update.Enabled := False;
//  Close;

end;

procedure TForm1.btn_ProgramExecClick(Sender: TObject);
var
  stExec:string;
begin
  My_RunDosCommand(stExec,True,False);
  Close;
end;

procedure TForm1.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btn_telecopClick(Sender: TObject);
var
  stExec:string;
begin
  stExec := ExtractFileDir(Application.ExeName) + '\zReg.exe KT';
  My_RunDosCommand(stExec,True,False);
  Close;
end;

procedure TForm1.btn_stecClick(Sender: TObject);
var
  stExec:string;
begin
  stExec := ExtractFileDir(Application.ExeName) + '\zReg.exe ST';
  My_RunDosCommand(stExec,True,False);
  Close;

end;

procedure TForm1.btn_InfosecClick(Sender: TObject);
var
  stExec:string;
begin
  stExec := ExtractFileDir(Application.ExeName) + '\zReg.exe SKT';
  My_RunDosCommand(stExec,True,False);
  Close;

end;

procedure TForm1.btn_SgClick(Sender: TObject);
var
  stExec:string;
begin
  stExec := ExtractFileDir(Application.ExeName) + '\zReg.exe SG';
  My_RunDosCommand(stExec,True,False);
  Close;
end;

end.
