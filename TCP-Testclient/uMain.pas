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
  Dialogs, StdCtrls, cCiaBuffer, WSocket, ExtCtrls;

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
    procedure CliSocketBufferReceived(Sender: TObject);
    procedure CliSocketDataAvailable(Sender: TObject; Error: Word);
    procedure CliSocketSessionClosed(Sender: TObject; Error: Word);
    procedure CliSocketSessionConnected(Sender: TObject; Error: Word);
    procedure btnConnectClick(Sender: TObject);
    procedure cbOnTopClick(Sender: TObject);
  private
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
  ClientName = 'Testclient für TCP-Datenausgabe';

implementation

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
             Chr($02)+                 // TYP FAHRPULT
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
           Chr($00) + Chr($0A)+ // Datensatz
           Chr($55));           // KM
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
    paKm.Caption := Format('%8.2f km', [FSingle / 1000]);
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

end.
