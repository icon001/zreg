unit uGlobalVariable;

interface


var
  G_nDelayTime : integer = 1000;  //������� �� ��� �ð�
  G_bResponseChecking : Boolean; //���� ���� ��� ������ ���� - ������̸� ��Ŷ �۽��� ���� ����   
  G_bDeviceResponse: Array [0..200] of Boolean; //��� ���� ���� ���� ����

const
  conBLEBootVer = 1; //BLEBootVersion
  conBLECustomID = 2; //BLE CustomID
  conBLERssi = 3;     //BLE Rssi
  conBLEVer = 4;      //BLE ver

  conCARDREADERVERSION = 17;     //ī�帮�� ��������
  conCARDREADERSTATE = 23;     //ī�帮�� ��Ż���
  conDEVICECODECHECK = 74;        //����ڵ� ��ȸ
  conDEVICEVERSIONCHECK = 77;     //������üũ
  conECUSTATE = 90;              //Ȯ��� ��Ż���
  conUSEDEVICECHECK = 114;         //���Ȯ���üũ

implementation

end.
