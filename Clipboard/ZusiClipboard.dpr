program ZusiClipboard;

uses
  Windows,Kol;

{$R *.res}

Var
  Key: HKEY;
  ZusiPath: String;
  CopyPath: String;

begin
  If ParamStr(1) = '' then
  begin
    MessageBox(0,
      'Dieses Programm kopiert den relativen Zusi-Pfad von Dateien in die '+
      'Zwischenablage. Hierzu muß die zu kopierende Datei als Parameter '+
      'übergeben werden, zum Beispiel über das Menü "Senden an" oder per '+
      'Drag & Drop.'#13#13+
      'Das Programm entstand nach einer Idee von Sebastian Sperling.'#13+
      'Umsetzung: Daniel Schuhmann, 2005',
      'Programminformation',
      MB_OK or MB_ICONINFORMATION);
    Halt(0);
  end;

  Key := RegKeyOpenRead(HKEY_CURRENT_USER, 'Software\Zusi');
  ZusiPath := RegKeyGetStr(Key, 'ZusiDir');
  RegKeyClose(Key);
  If ZusiPath = '' then
  begin
    MessageBox(0,
      'Zusi ist nicht korrekt installiert. Installieren Sie Zusi neu, oder '+
      'legen Sie den Eintrag von Zusi in der Registrierung an.',
      'Zusi nicht korrekt installiert',
      MB_OK or MB_ICONERROR);
    Halt(255);
  end;

  If ZusiPath[Length(ZusiPath)] <> '\' then ZusiPath := ZusiPath + '\';
  If Pos(LowerCase(ZusiPath), LowerCase(ParamStr(1))) <> 1 then
  begin
    MessageBox(0,
      'Die ausgewählte Datei liegt nicht im Zusi-Verzeichnis.',
      'Falsche Datei gewählt',
      MB_OK or MB_ICONINFORMATION);
    Halt(1);
  end;
  CopyPath := Copy(ParamStr(1),Length(ZusiPath)+1,Length(ParamStr(1)));
  If DirectoryExists(ParamStr(1)) then CopyPath := CopyPath + '\';

  Text2Clipboard(CopyPath);


end.
