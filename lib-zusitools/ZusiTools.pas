unit ZusiTools;

interface

Uses Windows, Registry;

function GetZusiDir: String;
function IsZusiLoaded: Boolean;

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

end.
 