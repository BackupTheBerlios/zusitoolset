program LCDDemo;

uses
  Forms,
  LCDMain in 'LCDMain.pas' {LCDMainForm},
  LCDUtils in 'LCDUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TLCDMainForm, LCDMainForm);
  Application.Run;
end.
