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
  ZusiPath: String;
  ZusiExe: String;
  SleepTime: Integer;

begin
  OpenIni;
  ZusiPath := GetZusiFileName;
  WndZusi := FindWindow('TFormZusiD3DApplication',nil);
  Ini.Section := 'Settings';
  ZusiExe := Ini.ValueString('ZusiExe','Zusi.exe');
  If not FileExists(ZusiPath + ZusiExe) then
  begin
    MessageBox(0,
      PChar('Zusi wurde unter dem Pfad '+ZusiPath + ZusiExe+' nicht gefunden. Korrigieren '+
      'Sie den Pfad in der Registry oder tragen Sie ihn in die Ini-Datei im '+
      'Bereich [Zusi] unter dem Eintrag Zusi an.'),
      'Zusi-Pfadangabe fehlerhaft',
      MB_ICONERROR or MB_OK);
    Halt(1);
  end;
  If WndZusi = 0 then WinExec(PChar(ZusiPath + ZusiExe), SW_SHOWNORMAL);

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
