unit uMain;

{
Das Copyright der Software liegt bei Daniel Schuhmann. Die Software
kann frei verwendet und beliebig geändert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
FÜR EINEN BESTIMMTEN ZWECK.

Viel Spaß,
Daniel Schuhmann
http://www.smartcoder.net
webmaster@smartcoder.net
ICQ# 32988298
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cCiaBuffer, WSocket, ExtCtrls, uTimetables,
  LibXmlParser, LibXmlComps, ComCtrls, fisHotKey, uSound, IniFiles, XPMan,
  Math, IntList, LCDScreen, Buttons;

type
  TMain = class(TForm)
    CliSocket: TWSocket;
    CliSocketBuffer: TCiaBuffer;
    GroupBox1: TGroupBox;
    laServer: TLabel;
    Label5: TLabel;
    btnConnect: TButton;
    edServer: TEdit;
    cbPort: TComboBox;
    paKm: TPanel;
    cbOnTop: TCheckBox;
    cXML: TEasyXmlScanner;
    btnScan: TButton;
    cbLines: TComboBox;
    cbTracks: TComboBox;
    cbStations: TComboBox;
    btnPlay: TButton;
    cHotKey: TfisHotKey;
    HkHotKey: THotKey;
    cbDisplay: TComboBox;
    cbFolder: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    btnNextKm: TButton;
    ListBox1: TListBox;
    btnParse: TButton;
    btnLoad: TButton;
    cLCD: TLCDScreen;
    Label7: TLabel;
    btnFestlegen: TSpeedButton;
    btnApspielen: TSpeedButton;
    procedure cLCDClick(Sender: TObject);
    procedure HkHotKeyChange(Sender: TObject);
    procedure CliSocketBufferReceived(Sender: TObject);
    procedure CliSocketDataAvailable(Sender: TObject; Error: Word);
    procedure CliSocketSessionClosed(Sender: TObject; Error: Word);
    procedure CliSocketSessionConnected(Sender: TObject; Error: Word);
    procedure btnConnectClick(Sender: TObject);
    procedure cbOnTopClick(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cXMLStartTag(Sender: TObject; TagName: String;
      Attributes: TAttrList);
    procedure cXMLEndTag(Sender: TObject; TagName: String);
    procedure cbLinesChange(Sender: TObject);
    procedure cbTracksChange(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnFestlegenClick(Sender: TObject);
    procedure cHotKeyHotKey(Sender: TObject);
    procedure cXMLContent(Sender: TObject; Content: String);
    procedure cbStationsChange(Sender: TObject);
    procedure cbDisplayChange(Sender: TObject);
    procedure cbFolderChange(Sender: TObject);
    procedure btnNextKmClick(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
  private
    IniFile: TIniFile;
    Lines: TLines;
    Position: TPosition;
    NextKm: String;
    XmlFormat: TFormatSettings;
    Channel: DWord;
    UseSound: Boolean;

    procedure SendData(Data: String);
    procedure GetNeededData;
    procedure ParseInput(Input: String);
    procedure SetIncomingData(Data: String);
  public
    { Public-Deklarationen }
  end;

var
  Main: TMain;

resourcestring
  ClientName = 'IBIS/FIS-Server';

implementation

uses uUtilities;

{$R *.dfm}

procedure TMain.CliSocketBufferReceived(Sender: TObject);
var
  S: String;
begin
  S := CliSocketBuffer.ReceiveStr;
  ParseInput(S);
end;

procedure TMain.SendData(Data: String);
var
  I: Integer;
  S: String;
  FArray: Array [0..3] of Byte;
  FCardinal: Cardinal;
begin
  S := Data;
  // Paketlänge festlegen
  FCardinal := Length(S);
  PCardinal(@FArray)^ := FCardinal;

  // Endgültigen Sendstring basteln
  // Länge im Intel Byteorder-Format
  For I := 3 downto 0 do
    S := Chr(FArray[I]) + S;

  CliSocket.SendStr(S);
end;

procedure TMain.CliSocketDataAvailable(Sender: TObject; Error: Word);
var
  Count: Integer;
begin
  If Error <> 0 then
    Exit;

  With CliSocket do
    Count := Receive(CliSocketBuffer.MemoryWrite, CliSocketBuffer.MemFree);
  CliSocketBuffer.BytesWritten := Count;
  if CliSocketBuffer.MemFree < 512 then
    CliSocketBuffer.Grow(2048);
end;

procedure TMain.CliSocketSessionClosed(Sender: TObject; Error: Word);
begin
  btnConnect.Caption := 'Verbinden';
end;

procedure TMain.CliSocketSessionConnected(Sender: TObject; Error: Word);
begin
  if Error <> 0 then begin
    // Verbindung konnte nicht hergestellt werden
    MessageBox(handle,
               'Die Verbindung konnte nicht hergestellt werden.',
               'Keine Verbindung möglich',
               MB_OK or MB_ICONERROR);
  end else begin
    // Verbindung erfolgreich hergestellt: HELLO-Befehl senden
    btnConnect.Caption := 'Trennen';
    SendData(Chr($00)+Chr($01)+        // CMD_HELLO
             Chr($01)+                 // PROTOKOLLVERSION 1
             Chr($06)+                 // TYP FIS
             Chr(Length(ClientName))+  // STRING-LÄNGE
             ClientName);
  end;
end;

procedure TMain.btnConnectClick(Sender: TObject);
begin
  If CliSocket.State <> wsConnected then
  begin
    Try
      // Verbinden
      CliSocket.Port := cbPort.Text;
      CliSocket.Addr := edServer.Text;
      CliSocket.Proto := 'tcp';
      CliSocket.Connect;
    Except End;
  end else begin
    // Verbindung Trennen
    Try
      CliSocket.Close;
    Except End;
    btnConnect.Caption := 'Verbinden';
  end;
end;

procedure TMain.GetNeededData;
begin
  // Mit dem Befehl GET_NEEDED_DATA die benötigen IDs anfordern. Hier ist dies
  // nur 85 (55 hex) für den Kilometerstand.
  SendData(Chr($00) + Chr($03)+ // NEEDED_DATA
           Chr($00) + Chr($0A)+ // Datensatz Führerstand
           Chr($55) + Chr($56));// KM-Stand und Türen
  SendData(Chr($00) + Chr($03)+ // NEEDED_DATA
           Chr($00) + Chr($1A)+ // Datensatz FIS
           Chr($01) + Chr($02)+ Chr($03)+ Chr($04)+ Chr($05)+ Chr($06)+
           Chr($07) + Chr($08)+ Chr($09)+ Chr($0A)+ Chr($0B)+ Chr($10)+
           Chr($11) + Chr($12)+ Chr($13)+ Chr($17)+ Chr($18)+ Chr($19)+
           Chr($1A) + Chr($20)+ Chr($21)+ Chr($22)+ Chr($23)+ Chr($24)+
           Chr($25));           // FIS-IDs             
  // Und den Befehl nochmal mit Datensatz 00 00 als Kennung für den letzten
  // Befehl.
  SendData(Chr($00) + Chr($03) + Chr($00) + Chr($00)); // Letzter Befehl
end;

procedure TMain.ParseInput(Input: String);
begin
  Case Ord(Input[1]) of
    $00: begin
           // Befehle mit Befehlsnummern bis max. 0x00FF, das sind zur Zeit
           // alle aktuellen Befehle
           Case Ord(Input[2]) of
             $01: begin
                    // HELLO-Befehl, kann der Client nicht verarbeiten.
                    // Keine Aktion.
                  end;
             $02: begin
                    // ACK_HELLO-Befehl:
                    // Prüfen, ob der Client akzeptiert wurde, falls nicht,
                    // Fehlermeldung anzeigen und Verbindung trennen.
                    // Ansonsten ist alles glatt, NEEDED_DATA anfordern.
                    Case Ord(Input[3]) of
                      $00: begin
                             // Kein Fehler: Client wurde akzeptiert
                             // NEEDED_DATA anfordern
                             GetNeededData;
                           end;
                      $01: begin
                             // Zu viele Verbindungen
                             btnConnectClick(Self);
                             MessageBox(handle,
                                        'Es bestehen zu viele Verbindungen. '+
                                        'Der Server hat diese nicht mehr '+
                                        'akzeptiert',
                                        'Zu viele Verbindungen',
                                        MB_OK or MB_ICONERROR);
                           end;
                      $02: begin
                             // Zusi bereits Verbunden
                             btnConnectClick(Self);
                             MessageBox(handle,
                                        'Zusi ist bereits verbunden. Trennen '+
                                        'Sie Zusi und versuchen Sie es erneut.',
                                        'Zusi ist bereits verbunden',
                                        MB_OK or MB_ICONINFORMATION);
                           end;
                      else begin
                             // Unbekannter Fehler
                             btnConnectClick(Self);
                             MessageBox(handle,
                                        'Es ist ein unbekannter Fehler beim '+
                                        'Verbinden während des CMD_HELLO-'+
                                        'Befehls aufgetreten. Falls Sie zuvor '+
                                        'den Server aktualisiert hatten, '+
                                        'aktualisieren Sie bitte nun das'+
                                        ' Client-Programm.',
                                        'Unbekannter Fehler',
                                        MB_OK or MB_ICONERROR);
                           end;
                    end;
                  end;
             $03: begin
                    // NEEDED_DATA-Befehl, kann der Client nicht verarbeiten.
                    // Keine Aktion.
                  end;
             $04: begin
                    // ACK_NEEDED_DATA-Befehl, dieser Befehl gibt Aufschluß
                    // darüber, ob der NEEDED_DATA-Befehl vom Server akzeptiert
                    // wurde.
                    Case Ord(Input[3]) of
                      $00: begin
                             // Befehl wurde akzeptiert, keine weitere Aktion
                           end;
                      $01: begin
                             // NEEDED_DATA enthält einen unbekannten
                             // Befehlsvorrat
                             MessageBox(handle,
                                        'NEEDED_DATA enthält einen unbekannten'+
                                        ' Befehlsvorrat, der vom Server nicht '+
                                        'akzeptiert wurde.',
                                        'Unbekannter Befehlsvorrat',
                                        MB_OK or MB_ICONERROR);
                           end;
                      else begin
                             // ACK_NEEDED_DATA hat einen unbekannten
                             // Fehlercode zurückgesendet.
                             MessageBox(handle,
                                        'CMD_NEEDED_DATA verursachte '+
                                        'eine unbekannte Server-Fehlermeldung.',
                                        'Unbekannte Server-Fehlermeldung',
                                        MB_OK or MB_ICONERROR);
                           end;
                    end;
                  end;
             $0A: begin
                    // DATA-Befehl: Durch diesen Befehl werden die Führerstands-
                    // anzeigen aktualisiert.
                    SetIncomingData(Input);
                  end;
           end;
         end;
  end;
end;

procedure TMain.SetIncomingData(Data: String);
var
  Buffer: String;
  I: Integer;
  FSingle: Single;
  AktKm: String;
  FArray: Array[1..4] of Byte;
begin
  // Mit dieser Prozedur werden die eingehenden Daten ausgegeben. Zunächst wird
  // überprüft, ob der Datensatz 00 0A vorliegt, ansonsten werden die Daten
  // ignoriert.
  If not ((Ord(Data[1])=$00) and (Ord(Data[2])=$0A)) then Exit;
  // Die Daten werden in den Arbeitspuffer kopiert
  Buffer := Copy(Data,3,Length(Data));
  // Wenn noch genug Daten im Puffer sind (mind. 1 Datensatz), werden die Daten
  // ausgelesen
  While Length(Buffer) >= 5 do
  begin
    // Bytes in das Array kopieren
    For I := 1 to 4 do
      FArray[I] := Ord(Buffer[I+1]);
    // Array in Single umwandeln
    FSingle := PSingle(@FArray)^;
    // Singlewert ausgeben
    paKm.Caption := Format('%1.2f km', [FSingle / 1000]);

    AktKm := Format('%1.1f' ,[(FSingle / 1000)]);
    Caption := AktKm + 'A, N:' + NextKm;

    If AktKm = NextKm then
    begin
      cHotKeyHotKey(self);
      btnNextKmClick(self);
      cbStationsChange(self);
    end;
    
    // Gerade verwendete Daten aus dem Puffer löschen
    Delete(Buffer,1,5);
  end;
end;


procedure TMain.cbOnTopClick(Sender: TObject);
var
  Flags: Cardinal;
begin
  Flags := SWP_DRAWFRAME or SWP_NOMOVE or SWP_NOSIZE;
  If cbOnTop.Checked
    then SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, Flags)
      else SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, Flags);
end;

procedure TMain.btnScanClick(Sender: TObject);
var
  Files: TStringList;
  I: Integer;
begin
  Files := TStringList.Create;
  FindFiles(ExtractFilePath(Application.ExeName)+'Ansagen','*.xml',True,Files);

  For I := 0 to Files.Count -1 do
  begin
    cXML.Filename := Files[I];
    cXML.Execute;
  end;

  Files.Free;

  btnScan.Enabled := False;

  cbStations.Clear;
  cbTracks.Clear;
  cbLines.Clear;

  For I := 0 to Lines.Count -1 do
    If ((Lines[I].Folder <> '') and
      (cbFolder.Items.IndexOf(Lines[I].Folder) = (-1)))
    then cbFolder.Items.Add(Lines[I].Folder);
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  Main.ClientHeight := 375;
  If Screen.Fonts.IndexOf('Tahoma') <> (-1) then Font.Name := 'Tahoma';
  Lines := TLines.Create;
  XmlFormat.DecimalSeparator := '.';
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  Main.Left := IniFile.ReadInteger('Settings', 'Left', Screen.Width div 2 - Main.Width div 2);
  Main.Top := IniFile.ReadInteger('Settings', 'Top', Screen.Height div 2 - Main.Height div 2);
  cHotKey.Key := IniFile.ReadInteger('Settings','HotKey',0);
  HkHotKey.HotKey := cHotKey.Key;
  cbOnTop.Checked := IniFile.ReadBool('Settings','HotKey',True);
  cbOnTopClick(Self);

  UseSound := IniFile.ReadBool('Settings','UseSound',True);
  If UseSound then
  begin
    if BASS_GetVersion <> DWORD(MAKELONG(2,1)) then
    begin
      MessageBox(0, 'Die Datei IBIS.dll liegt in einer falschen Version vor.'+
        ' Bitte laden Sie eine aktuelle Version aus dem Internet unter '+
        'http://zusitoolset.berlios.de herunter', 'Falsche Dateiversion',
        MB_OK or MB_ICONERROR);
      Application.Terminate;
      Exit;
    end;

    BASS_SetConfig(BASS_CONFIG_FLOATDSP, 1);
    if not BASS_Init(1, 44100, 0, Handle, nil) then
    begin
      MessageBox(0, 'Das Audiogerät kann nicht initialisiert werden. Zum '+
        'Betrieb wird eine Soundkarte benötigt. Sollen nur die Serverdienste '+
        'verwendet werden, setzen Sie die Variable "UseSound" in der INI-Datei'+
        ' im Abschnitt [Settings] auf den Wert 0.', 'Kein Audiogerät',
        MB_OK or MB_ICONERROR);
      Application.Terminate;
      Exit;
    end;
  end;
  btnScanClick(Self);
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IniFile.WriteInteger('Settings','HotKey',cHotKey.Key);
  IniFile.WriteInteger('Settings', 'Left', Main.Left);
  IniFile.WriteInteger('Settings', 'Top', Main.Top);
  IniFile.WriteBool('Settings','HotKey',cbOnTop.Checked);
  Lines.Free;
  IniFile.Free;
  Bass_Free;
end;

procedure TMain.cXMLStartTag(Sender: TObject; TagName: String;
  Attributes: TAttrList);

var
  I: Integer;
  Line: TLine;
  Track: TTrack;
  Station: TStation;
begin
  If TagName = 'Line' then
  begin
    Line := TLine.Create;
    Line.Directory := ExtractFilePath(cXML.Filename);
    For I := 0 to Attributes.Count -1 do
    begin
      If Attributes.Name(I) = 'Name'
        then Line.Name := Attributes.Value(I);
      If Attributes.Name(I) = 'Folder'
        then Line.Folder := Attributes.Value(I);
    end;
    Lines.Add(Line);
    Inc(Position.Line);
  end;

  If TagName = 'Track' then
  begin
    Track := TTrack.Create;
    For I := 0 to Attributes.Count -1 do
    begin
      If Attributes.Name(I) = 'Route'
        then Track.Route := Attributes.Value(I);
    end;
    Lines.Line[Position.Line -1].Tracks.Add(Track);
    Inc(Position.Track);
  end;

  If TagName = 'Station' then
  begin
    Station := TStation.Create;
    For I := 0 to Attributes.Count -1 do
    begin
      If Attributes.Name(I) = 'Name'
        then Station.Name := Attributes.Value(I);
      If Attributes.Name(I) = 'Filename'
        then Station.FileName := Attributes.Value(I);
      If Attributes.Name(I) = 'Position'
        then Station.Position := StrToFloat(Attributes.Value(I), XmlFormat);
    end;
    Lines.Line[Position.Line -1].Tracks.Track[Position.Track -1].Stations.Add(
      Station.Name,Station.FileName,Station.Position);
    Inc(Position.Station);
  end;
end;

procedure TMain.cXMLEndTag(Sender: TObject; TagName: String);
begin
  If TagName = 'Line' then Position.Track := 0;
  If TagName = 'Track' then Position.Station := 0;
end;

procedure TMain.cbLinesChange(Sender: TObject);
Var
  I, J: Integer;
begin
  cbDisplay.Clear;
  cbStations.Clear;
  cbTracks.Clear;

  For I := 0 to Lines.Count -1 do
  begin
    If (Lines[I].Name = cbLines.Text) and (Lines[I].Folder = cbFolder.Text) then
      For J := 0 to Lines[I].Tracks.Count -1 do
        cbTracks.Items.Add(Lines[I].Tracks[J].Route);
  end;

end;

procedure TMain.cbTracksChange(Sender: TObject);
Var
  I, J: Integer;
begin

  cbStations.Clear;
  For I := 0 to Lines.Count -1 do
  begin
    If (Lines[I].Name = cbLines.Text) and (Lines[I].Folder = cbFolder.Text) then
      For J := 0 to Lines[I].Tracks[cbTracks.ItemIndex].Stations.Count -1 do
        cbStations.Items.Add(Lines[I].Tracks[cbTracks.ItemIndex].Stations[J].Name);
  end;

  cbDisplay.Clear;
  For I := 0 to Lines.Count -1 do
  begin
    If (Lines[I].Name = cbLines.Text) and (Lines[I].Folder = cbFolder.Text) then
      For J := 0 to Lines[I].Tracks[cbTracks.ItemIndex].Stations.Count -1 do
        cbDisplay.Items.Add(Lines[I].Tracks[cbTracks.ItemIndex].Stations[J].Display);
  end;

end;

procedure TMain.btnPlayClick(Sender: TObject);
var
  I: Integer;
  S: String;
begin
  If UseSound then
  begin

    For I := 0 to Lines.Count -1 do
    begin
      If (Lines[I].Name = cbLines.Text) and (Lines[I].Folder = cbFolder.Text) then
      begin
        S :=
          Lines[I].Directory +
          Lines[I].Tracks[cbTracks.ItemIndex].
          Stations[cbStations.ItemIndex].FileName;
        Break;
      end;
    end;
    If S = '' then Exit;

    BASS_StreamFree(Channel);

    Channel := BASS_StreamCreateFile(False, PChar(S), 0, 0, 0);
    if (Channel = 0) then
    begin
      // whatever it is, it ain't playable
      MessageBox(0,
        PChar(Format('Die Datei %s kann nicht gefunden werden, ist defekt oder'+
          ' liegt in einem falschen Format vor.',[S])),
          'Fehler beim Dateizugriff',
        MB_OK or MB_ICONERROR);
      Exit;
    end;

    BASS_ChannelPlay(Channel, False);
  end;

end;

procedure TMain.btnFestlegenClick(Sender: TObject);
begin
  cHotKey.Key := HkHotKey.HotKey;
  paKm.SetFocus;
  btnFestlegen.Enabled := False;
end;

procedure TMain.cHotKeyHotKey(Sender: TObject);
begin
  cbStations.ItemIndex := cbStations.ItemIndex + 1;
  cbDisplay.ItemIndex := cbStations.ItemIndex;
  cLCD.Lines[0] := cbDisplay.Text;
  btnPlayClick(Self);
end;

procedure TMain.cXMLContent(Sender: TObject; Content: String);
begin
  Lines.Line[Position.Line -1].Tracks.Track[Position.Track -1].Stations.
    Station[Position.Station -1].Display := Content;
end;

procedure TMain.cbStationsChange(Sender: TObject);
begin
  cbDisplay.ItemIndex := cbStations.ItemIndex;
  cLCD.Lines[0] := cbDisplay.Text;
end;

procedure TMain.cbDisplayChange(Sender: TObject);
begin
  cbStations.ItemIndex := cbDisplay.ItemIndex;
  cLCD.Lines[0] := cbDisplay.Text;
end;

procedure TMain.cbFolderChange(Sender: TObject);
var
  I: Integer;
begin
  cbDisplay.Clear;
  cbStations.Clear;
  cbTracks.Clear;
  cbLines.Clear;

  For I := 0 to Lines.Count -1 do
    If (Lines[I].Folder = cbFolder.Text)
      then cbLines.Items.Add(Lines[I].Name);

end;

procedure TMain.btnNextKmClick(Sender: TObject);
var
  I: Integer;

begin
  For I := 0 to Lines.Count -1 do
  begin
    If (Lines[I].Name = cbLines.Text) and (Lines[I].Folder = cbFolder.Text) then
    begin
      NextKm := Format('%1.1f',[Lines[I].Tracks[cbTracks.ItemIndex].
        Stations[cbStations.ItemIndex].Position]);

caption := nextkm;

      Break;
    end;
  end;
end;

procedure TMain.btnParseClick(Sender: TObject);
var
  I, J, K, L: Integer;
  slNetz: TStringList;
  slStartStations: TStringList;
  slZielStations : TStringList;
begin
  ListBox1.Clear;
  slNetz := TStringList.Create;
  slStartStations := TStringList.Create;
  slZielStations  := TStringList.Create;

  For I := 0 to Lines.Count -1 do
    if slNetz.IndexOf(Lines[I].Folder) = (-1) then
      slNetz.Add(Lines[I].Folder);

  For K := 0 to slNetz.Count -1 do
  begin
    ListBox1.Items.Add('NETZ: '+slNetz[K]);

    For I := 0 to Lines.Count -1 do
      If Lines[I].Folder = slNetz[K] then
    begin
      ListBox1.Items.Add('LINE: '+Lines[I].Name);
      slStartStations.Clear;
      For J := 0 to Lines[I].Tracks.Count -1 do
      begin
        If Lines[I].Tracks[J].Stations.Count > 0 then
          If slStartStations.IndexOf(Lines[I].Tracks[J].Stations[0].Display) = (-1) then
            slStartStations.Add(Lines[I].Tracks[J].Stations[0].Display);
      end;

      For L := 0 to slStartStations.Count -1 do
      begin
        ListBox1.Items.Add('START: '+slStartStations[L]);
        slZielStations.Clear;
        For J := 0 to Lines[I].Tracks.Count -1 do
        If Lines[I].Tracks[J].Stations.Count > 0 then
        begin
          If Lines[I].Tracks[J].Stations[0].Display = slStartStations[L] then
          begin
            If slZielStations.IndexOf(Lines[I].Tracks[J].Stations[Lines[I].Tracks[J].Stations.Count -1].Display) = (-1) then
            begin
              slZielStations.Add(Lines[I].Tracks[J].Stations[Lines[I].Tracks[J].Stations.Count -1].Display);
              ListBox1.Items.Add('ZIEL: '+Lines[I].Tracks[J].Stations[Lines[I].Tracks[J].Stations.Count -1].Display);
            end;
          end;
        end;
        ListBox1.Items.Add('NO_MORE_ZIEL');
      end;
      ListBox1.Items.Add('NO_MORE_START');
    end;
    ListBox1.Items.Add('NO_MORE_NETZ');
  end;
  ListBox1.Items.Add('NO_MORE_DATA');
  slNetz.Free;
  slStartStations.Free;
  slZielStations.Free;
end;

procedure TMain.HkHotKeyChange(Sender: TObject);
begin
  btnFestlegen.Enabled := True;
end;

procedure TMain.cLCDClick(Sender: TObject);
begin
  If Main.ClientHeight = 62
    then Main.ClientHeight := 375
      else Main.ClientHeight := 62;

end;

end.
