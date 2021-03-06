unit ZusiTools;

interface

Uses Windows, SysUtils, Registry, Classes;

function GetZusiDir: String;
function IsZusiLoaded: Boolean;
function SendKeyToZusi(Key: Integer; Pressed, Release: Boolean): Boolean;
function ShutdownComputer(Force: Boolean): Boolean;
procedure FindFiles (aPath, aFindMask: String; aWithSub: Boolean; aResult: tStrings);
function FarbeRGBToInt(R, G, B: Byte): Integer;


implementation

procedure FindFiles (aPath, aFindMask: String; aWithSub: Boolean; aResult: tStrings);
var
  FindRec: tSearchRec;
begin
  // Wenn die Stringliste nil ist oder aPath oder aFind nicht angegeben ist  
  // dann raus  
  If (aPath = '') or (aFindMask = '') or Not Assigned (aResult) Then  
    Exit;  

 
  // Wenn am Ende der Pfadangabe noch kein \ steht, dieses hinzuf�gen  
  If aPath[Length (aPath)] <> '\' Then  
    aPath := aPath + '\';  

 
  // Im aktuellen Verzeichnis nach der Datei suchen  
  If FindFirst (aPath + aFindMask, faAnyFile, FindRec) = 0 Then  
    Repeat  
      If (FindRec.Name <> '.') and (FindRec.Name <> '..') Then  
        // ...Ergebnis in die Stringlist einf�gen  
        aResult.Add (aPath + FindRec.Name);  
    Until FindNext (FindRec) <> 0;

 
  FindClose (FindRec);  

 
  // Wenn nicht in Unterverzeichnissen gesucht werden soll dann raus  
  If Not aWithSub Then  
    Exit;  

 
  // In Unterverzeichnissen weiter suchen  
  If FindFirst (aPath + '*.*', faAnyFile, FindRec) = 0 Then  
    Repeat  
      If (FindRec.Name <> '.') and (FindRec.Name <> '..') Then  
        // Feststellen, ob es sich um ein Verzeichnis handelt  
        If Boolean (FindRec.Attr and faDirectory) Then  
          // Funktion erneut aufrufen, um Verzeichnis zu durchsuchen (Rekursion)  
          FindFiles (aPath + FindRec.Name, aFindMask, aWithSub, aResult);  
    Until FindNext (FindRec) <> 0;  

 
   FindClose (FindRec);  
end; 


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

function FarbeRGBToInt(R, G, B: Byte): Integer;
var FarbeHex: String;
begin
  FarbeHex := IntToHex(B, 2) + IntToHex(G, 2) + IntToHex(R, 2);
  Result := StrToInt('$' + FarbeHex);
end;

end.
 