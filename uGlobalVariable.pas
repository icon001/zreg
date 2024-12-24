unit uGlobalVariable;

interface


var
  G_nDelayTime : integer = 1000;  //기기전송 후 대기 시간
  G_bResponseChecking : Boolean; //현재 응답 대기 중인지 여부 - 대기중이면 패킷 송신을 보류 하자   
  G_bDeviceResponse: Array [0..200] of Boolean; //기기 설정 정보 응답 여부

const
  conBLEBootVer = 1; //BLEBootVersion
  conBLECustomID = 2; //BLE CustomID
  conBLERssi = 3;     //BLE Rssi
  conBLEVer = 4;      //BLE ver

  conCARDREADERVERSION = 17;     //카드리더 버젼정보
  conCARDREADERSTATE = 23;     //카드리더 통신상태
  conDEVICECODECHECK = 74;        //기기코드 조회
  conDEVICEVERSIONCHECK = 77;     //기기버젼체크
  conECUSTATE = 90;              //확장기 통신상태
  conUSEDEVICECHECK = 114;         //사용확장기체크

implementation

end.
