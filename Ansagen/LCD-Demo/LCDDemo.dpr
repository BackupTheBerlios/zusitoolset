program LCDDemo;

uses
  Forms,
  LCDMain in 'LCDMain.pas' {LCDMainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TLCDMainForm, LCDMainForm);
  Application.Run;
end.
