unit ZusiTools;

interface

Uses Windows, SysUtils, Registry;

function GetZusiDir: String;
function IsZusiLoaded: Boolean;
function SendKeyToZusi(Key: Integer; Pressed, Release: Boolean): Boolean;
function ShutdownComputer(Force: Boolean): Boolean;

implementation

function GetZusiDir: String;
var
  Reg: TRegistry;
  S: String;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKeyReadOnly('Software\Zusi');
  S := Reg.ReadString('ZusiDir');
  If S[Length(S)] <> '\' then S := S + '\';
  If S = '\' then
    S := '' else
      Result := S;
  Reg.CloseKey;
  Reg.Free;
end;

function IsZusiLoaded: Boolean;
var
  Wnd: HWND;
begin
  Wnd := FindWindow('TFormZusiD3DApplication',nil);
  Result := not (Wnd = 0);
end;

function SendKeyToZusi(Key: Integer; Pressed, Release: Boolean): Boolean;
var
  Wnd: HWND;
begin
  Wnd := FindWindow('TFormZusiD3DApplication',nil);

  SetForegroundWindow(Wnd);
  If Pressed then
    keybd_event(Key,0,0,(Key shl 8) + 1) else
      keybd_event(Key,0,KEYEVENTF_KEYUP,(Key shl 8) + 1);
  If (Pressed and Release) then
  begin
    Sleep(10);
    keybd_event(Key,0,KEYEVENTF_KEYUP,(Key shl 8) + 1);
  end;
  
  Result := not (Wnd = 0);
end;

function ShutdownComputer(Force: Boolean): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
  RebootParam: LongWord;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(),
      TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil,
                                       SE_SHUTDOWN_NAME,
                                       TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd,
                                      False,
                                      TTokenPvg,
                                      cbtpPrevious,
                                      rTTokenPvg,
                                      pcbtpPreviousRequired);
    end;
  end;
  If Force then
    RebootParam := EWX_POWEROFF or EWX_FORCE else
      RebootParam := EWX_POWEROFF;
  Result := ExitWindowsEx(RebootParam, 0);
end;

end.
 