unit Utilities;

interface

Uses
  Windows, Kol;

Var
  Ini: PIniFile;
  Key: HKEY;

procedure OpenIni;
function GetZusiFileName: String;

implementation

procedure OpenIni;
begin
  Ini := OpenIniFile(ChangeFileExt(ParamStr(0), '.ini'));
  Ini.Mode := ifmRead;
end;

function GetZusiFileName: String;
begin
  Ini.Section := 'Zusi';
  Result := Ini.ValueString('Zusi','');
  If Result = '' then
  begin
    Key := RegKeyOpenRead(HKEY_CURRENT_USER, 'Software\Zusi');
    Result := RegKeyGetStr(Key, 'ZusiDir');
    RegKeyClose(Key);

    If Result = '' then
    begin
      MessageBox(0,
        'Der Pfad von Zusi konnte weder in der Registry noch in der Ini-Datei '+
        'gefunden werden. Legen Sie in der Ini-Datei den Bereich [Zusi] und '+
        'den Eintrag Zusi an und weisen Sie dem Eintrag den Pfad von Zusi zu.',
        'Zusi nicht gefunden',
        MB_ICONERROR or MB_OK);
      Halt(1);
    end;
  end;
  If Result[Length(Result)] <> '\' then
    Result := Result + '\' else
      Result := Result + '';
end;

end.
