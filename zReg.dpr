program zReg;

uses
  Forms,
  uMain in 'uMain.pas' {MainForm},
  uLomosUtil in 'uLomosUtil.pas',
  systeminfos in 'systeminfos.pas',
  uFunction in 'uFunction.pas',
  UStateIndicate in 'UStateIndicate.pas' {fmStateIndicate},
  FileInfo in 'FileInfo.pas',
  DoorSchReg in 'DoorSchReg.pas' {DoorscheduleRegForm},
  uCommon in 'uCommon.pas' {DataModule1: TDataModule},
  uProcess in 'uProcess.pas' {fmPrograss},
  uMonitorMain in 'uMonitorMain.pas' {fmMonitorMain},
  LBSDisplayCtrl in 'LBSDisplayCtrl.pas',
  uLogin in 'uLogin.pas' {fmLogin},
  uConfig in 'uConfig.pas' {fmConfig},
  uDeviceRegMessage in 'uDeviceRegMessage.pas' {fmDeviceRegMessage},
  uSelect in 'uSelect.pas' {fmSelect},
  uAlarmList in 'uAlarmList.pas' {fmAlarmList},
  uSubForm in 'lib\uSubForm.pas' {fmASubForm},
  uMessage in 'uMessage.pas' {fmMessage},
  uPGConfig in 'uPGConfig.pas' {fmPGConfig},
  uNewCardReaderFirmWare in 'uNewCardReaderFirmWare.pas' {fmNewCardReaderFirmWare},
  uICU300FirmwareData in 'uICU300FirmwareData.pas' {dmICU300FirmwareData: TDataModule},
  uSocket in 'uSocket.pas' {dmSocket: TDataModule},
  uHelp in 'uHelp.pas' {fmHelp},
  uRemote3 in 'uRemote3.pas' {fmRemote3},
  uGlobalVariable in 'uGlobalVariable.pas';

{$R *.res}
{$R manifest.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDoorscheduleRegForm, DoorscheduleRegForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfmMessage, fmMessage);
  Application.CreateForm(TfmPGConfig, fmPGConfig);
  Application.CreateForm(TfmNewCardReaderFirmWare, fmNewCardReaderFirmWare);
  Application.CreateForm(TdmICU300FirmwareData, dmICU300FirmwareData);
  Application.CreateForm(TdmSocket, dmSocket);
  Application.CreateForm(TfmHelp, fmHelp);
  Application.CreateForm(TfmRemote3, fmRemote3);
  Application.Run;
end.
