unit uPGConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmPGConfig = class(TForm)
    Label1: TLabel;
    ed_SocketDelayTime: TEdit;
    Button1: TButton;
    Label2: TLabel;
    ck_USE: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPGConfig: TfmPGConfig;

implementation

uses
  uCommon,
  uLomosUtil;

{$R *.dfm}

procedure TfmPGConfig.FormCreate(Sender: TObject);
begin
  if G_bNodeConnectChecked then ck_USE.Checked := True;
  ed_SocketDelayTime.Text := inttostr(G_nNodeConnectDelayTime);
end;

procedure TfmPGConfig.Button1Click(Sender: TObject);
begin
  if isDigit(ed_SocketDelayTime.Text) then G_nNodeConnectDelayTime := strtoint(ed_SocketDelayTime.Text);
  G_bNodeConnectChecked := ck_USE.Checked;
  Close;
end;

end.
