program Infofenster;

uses
  Windows,
  Kol,
  Utilities in 'Utilities.pas';

{$R *.res}
var
  WndInfo: HWND;
  WndZusi: HWND;
  Rect: TRect;
  InfoWndSize: TPoint;
  ZusiExe: String;
  SleepTime: Integer;

begin
  OpenIni;
  ZusiExe := GetZusiFileName;
  WndZusi := FindWindow('TFormZusiD3DApplication',nil);
  If WndZusi = 0 then WinExec(PChar(ZusiExe), SW_SHOWNORMAL);

  Ini.Section := 'Settings';
  SleepTime := Ini.ValueInteger('Sleep',1000);

  Ini.Section := 'Info';
  InfoWndSize.X := Ini.ValueInteger('Width',92);
  InfoWndSize.Y := Ini.ValueInteger('Height',123);

  WndInfo := FindWindow('TFormFahrtInfo',nil);
  If WndInfo = 0 then
  begin
    SleepEx(1000, True);

    Repeat
      WndInfo := FindWindow('TFormFahrtInfo',nil);
      WndZusi := FindWindow('TFormZusiD3DApplication',nil);
    Until (WndInfo <> 0) or (WndZusi = 0);
  end;
  GetWindowRect(WndInfo, Rect);
  SetWindowPos(WndInfo,0,Rect.Left, Rect.Top, InfoWndSize.X, InfoWndSize.Y, 0);
  SetWindowText(WndInfo, 'Info');
end.