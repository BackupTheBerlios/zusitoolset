unit ZusiTools;

interface

Uses Windows, Registry;

function GetZusiDir: String;
function IsZusiLoaded: Boolean;
function SendKeyToZusi(Key: Integer; Pressed, Release: Boolean): Boolean;

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


end.
 