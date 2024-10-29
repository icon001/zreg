unit uHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmHelp = class(TForm)
    Memo1: TMemo;
    chk_edit: TCheckBox;
    lb_File: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure chk_editClick(Sender: TObject);
  private
    FFileName: string;
    procedure SetFileName(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property FileName:string read FFileName Write SetFileName;
  end;

var
  fmHelp: TfmHelp;

implementation

{$R *.dfm}

{ TfmHelp }

procedure TfmHelp.SetFileName(const Value: string);
begin
  FFileName := Value;
  lb_File.Caption := Value;
  Memo1.Clear;
  if(Not FileExists(Value)) then
  begin
    Memo1.text := Value + ' 파일을 참조합니다.';
    exit;
  end;
  Memo1.Lines.LoadFromFile(Value);
end;

procedure TfmHelp.Button1Click(Sender: TObject);
begin
  if(chk_edit.Checked) then
  begin
    Memo1.Lines.SaveToFile(FileName);
  end;
  Close;
end;

procedure TfmHelp.chk_editClick(Sender: TObject);
begin
  Memo1.ReadOnly := Not chk_edit.Checked ;
  if(chk_edit.Checked) then chk_edit.Caption := '편집(확인 버튼시 저장됨)'
  else chk_edit.Caption := '편집';
end;

end.
