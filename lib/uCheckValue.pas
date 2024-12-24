unit uCheckValue;

interface
const


var
  G_bResponseChecking : Boolean; //현재 응답 대기 중인지 여부 - 대기중이면 패킷 송신을 보류 하자(현재는 미사용)
  G_bDeviceResponse: Array [0..200] of Boolean; //기기 설정 정보 응답 여부


implementation

end.
