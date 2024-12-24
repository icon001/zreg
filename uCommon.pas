unit uCommon;

interface

uses
  SysUtils, Classes;

type
  TAlarmList = Class(TComponent)
  private
    FOnEcuID: string;
  public
    AlarmList : TStringList;
    property EcuID : string read FOnEcuID write FOnEcuID;
  end;

  TDataModule1 = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

  Rcv_MsgNo     : Char;
  Send_MsgNo    : Integer;
  ComBuff       : String;   // ������ ���ſ�
  IsConfigMCU   : Boolean;  // MCU �������ΰ�?
  CurrentType   : string;   //���� �۾���� ���Ÿ�� MCU/ECU/ICU
  RegCardMode   : Boolean;  // ī���� ���
  ErrorMessage : string; //��� ���� ������
  IsStop        : Boolean;  //���μ��� ����

    bMCUIDCheck : Boolean; //MCUIDCheck ����
    bUsedDeviceCheck : Boolean; //Ȯ����� ���� üũ
    bUsedAlarmCheck : Boolean; //�˶�ǥ�ñ� üũ
    bLinkusIDCheck : Boolean;  //�ý��۾��̵� üũ
    bLinksTelNoCheck :Boolean;  //��� ���� ��ȭ��ȣ üũ
    bRingCountCheck : Boolean;  //��ȭ �Ŵ� Ƚ�� üũ
    bControlDialTime : Boolean; //�������� Dial Time
    bWiznetCheck : Boolean;     //IP �� üũ
    bSysInfoCheck : Boolean;    //�ý������� üũ
    bSysInfo2Check : Boolean;   //���Թ�����üũ
    bPortCheck : Boolean;       //��Ʈüũ
    bCardReaderCheck : Boolean; //������ üũ
    bCardReaderTypeCheck : Boolean; //������ Ÿ�� üũ
    bVERCheck : Boolean; //����üũ
    bReaderVERCheck : Boolean;  //������ ���� üũ
    bSearch : Boolean;   //��ȸ �� ���ȯ�� üũ �ؾߵ�
    bErrorCheck : Boolean; //��� ����
    bECUStatusCheck : Boolean; //MCU�϶� ECU üũ �ϱ� ����
    bECUCommState : Boolean;// ECU ��Ż��� üũ�ϱ� ����
    bReaderCOMCheck : Boolean; //������ ��Ż��� üũ�ϱ� ����
    bIndicatorCheck : Boolean; //��Ȳǥ�� üũ�ϱ� ����
    bDoorSch : Boolean; //������ ������ üũ
    bSended : Boolean; //�۽������� üũ
    //bCardDownLoad : Boolean; //ī�� �ٿ�ε�
    DelayTime : integer;
    ComCheckDelayTime : integer;
    LoopCount : integer ; //���� ��� Ƚ��
    LANTime : integer;
    LANLoop : integer;
    TCPConf : string; //TCPIP,TCPPort
    ConnectMode : Integer; //TCP,RS232
    ServerMode : Integer;  //Server,Client
    ComPort : integer;
    LogMode : Integer;
    LogFileName : string;
    StopConnection : Boolean;
    DoCloseWinsock : Boolean;
    TraceDebug : integer;
    nFileSeq : integer;

  G_bApplicationTerminate : Boolean;
  G_bNodeConnectChecked : Boolean;
  G_nDelayTime : integer = 1000;
  G_nLoopCount : integer = 2; //�߿� ������ �ݺ� Ƚ�� 
  G_nNodeConnectDelayTime : integer = 30;

  //S-Tec �߰� �Ǹ鼭 �����Ǵ� �κ�
  G_nProgramType : integer; //0:�Ϲ�,1:Stec
  G_nIDLength : integer=7;
//const DelayTime = 600;
//const ComCheckDelayTime = 500;
//const  LoopCount = 12 ; //���� ��� Ƚ��

  DeviceAlarmList : TStringList; //�˶� ���� �����޸�





//{$DEFINE DEBUG}


implementation

{$R *.dfm}


end.
