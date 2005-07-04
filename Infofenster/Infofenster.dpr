program Infofenster;

uses
  Windows,
  Kol,
  Utilities in 'Utilities.pas';

{$R *.res}
var
  WndInfo: HWND;
  WndZusi: HWND;
  WndBfpl: HWND;

  Rect: TRect;

  InfoWndSize: TPoint;
  InfoWndPos: TPoint;

  ZusiWndSize: TPoint;
  ZusiWndPos: TPoint;

  BfplWndSize: TPoint;
  BfplWndPos: TPoint;

  ZusiPath: String;
  ZusiExe: String;
  SleepTime: Integer;

resourcestring
  sClassNameZusi = 'TFormZusiD3DApplication';
  sClassNameInfo = 'TFormFahrtInfo';
  sClassNameBfpl = 'TFormBuchfahrplan';

begin
  OpenIni;
  ZusiPath := GetZusiFileName;
  WndZusi := FindWindow(PChar(sClassNameZusi), nil);
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

  WndInfo := FindWindow(PChar(sClassNameInfo), nil);
  WndZusi := FindWindow(PChar(sClassNameZusi), nil);
  WndBfpl := FindWindow(PChar(sClassNameBfpl), nil);

  If WndInfo = 0 then
  begin
    SleepEx(SleepTime, True);
    Repeat
      WndInfo := FindWindow(PChar(sClassNameInfo) ,nil);
      WndZusi := FindWindow(PChar(sClassNameZusi) ,nil);
      WndBfpl := FindWindow(PChar(sClassNameBfpl) ,nil);
    Until ((WndInfo <> 0) and (WndBfpl <> 0)) or (WndZusi = 0);
  end;
  GetWindowRect(WndInfo, Rect);

  Ini.Section := 'Info';
  InfoWndSize.X := Ini.ValueInteger('Width',92);
  InfoWndSize.Y := Ini.ValueInteger('Height',123);
  InfoWndPos.X := Ini.ValueInteger('PosX', Rect.Left);
  InfoWndPos.Y := Ini.ValueInteger('PosY', Rect.Top);

  SetWindowPos(WndInfo, 0, InfoWndPos.X, InfoWndPos.Y,
    InfoWndSize.X, InfoWndSize.Y, 0);
  SetWindowText(WndInfo, 'Info');

  Ini.Section := 'Zusi';
  GetWindowRect(WndZusi, Rect);
  ZusiWndSize.X := Ini.ValueInteger('Width', Rect.Right - Rect.Left);
  ZusiWndSize.Y := Ini.ValueInteger('Height', Rect.Bottom - Rect.Top);
  ZusiWndPos.X := Ini.ValueInteger('PosX', Rect.Left);
  ZusiWndPos.Y := Ini.ValueInteger('PosY', Rect.Top);
  SetWindowPos(WndZusi, 0, ZusiWndPos.X, ZusiWndPos.Y,
    ZusiWndSize.X, ZusiWndSize.Y, 0);

  Ini.Section := 'Bfpl';
  GetWindowRect(WndBfpl, Rect);
  BfplWndSize.X := Ini.ValueInteger('Width', Rect.Right - Rect.Left);
  BfplWndSize.Y := Ini.ValueInteger('Height', Rect.Bottom - Rect.Top);
  BfplWndPos.X := Ini.ValueInteger('PosX', Rect.Left);
  BfplWndPos.Y := Ini.ValueInteger('PosY', Rect.Top);
  SetWindowPos(WndBfpl, 0, BfplWndPos.X, BfplWndPos.Y,
    BfplWndSize.X, BfplWndSize.Y, 0);



end.
