unit LCDMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, Buttons, JvHidControllerClass;

const
  cCodeMercenariesVID = $07C0;
  cIOWarrior40PID     = $1500;
  cIOWarrior24PID     = $1501;
  cLCDEnableReportID  = $04;
  cLCDWriteReportID   = $05;
  cLCDReadReportID    = $06;
  cEnable             = $01;
  cDisable            = $00;

type
  TIOWarriorOutputReport = packed record
    ReportID: Byte;
    LCDBytes: array [1..7] of Byte;
  end;

  TLCDMainForm = class(TForm)
    HidCtl: TJvHidDeviceController;
    IOWarriorAvailable: TLabel;
    Button1: TButton;
    edData: TEdit;
    Button2: TButton;
    edPos: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure HidCtlDeviceChange(Sender: TObject);
    procedure EnableChkClick(Sender: TObject);
    procedure HidCtlDeviceData(HidDev: TJvHidDevice; ReportID: Byte;
      const Data: Pointer; Size: Word);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  public
    Edits: array [1..7] of TEdit;
    IOWarrior: TJvHidDevice;
    EnableDevice: Boolean;
    procedure SendData(S: String; Pos: Byte);
  end;

var
  LCDMainForm: TLCDMainForm;

implementation

{$R *.dfm}

procedure TLCDMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  // otherwise the Edits are not assigned yet
  HidCtl.OnDeviceChange := HidCtlDeviceChange;
end;

function FindLcdIOWarrior(HidDev: TJvHidDevice): Boolean; stdcall;
begin
  // the IO-Warrior shows up as two devices
  // we want access to the IO-Warrior device for the LCD module
  // the other one with a InputReportByteLength of 5 is for access to
  // the IO pins
  // It is quite interesting to use the IO-WarriorDemo in parallel!
  Result := (HidDev.Attributes.VendorID = cCodeMercenariesVID) and
     ((HidDev.Attributes.ProductID = cIOWarrior40PID) and
      (HidDev.Caps.InputReportByteLength = 8)) or
     ((HidDev.Attributes.ProductID = cIOWarrior24PID) and
      (HidDev.Caps.InputReportByteLength = 8));
end;

procedure TLCDMainForm.HidCtlDeviceChange(Sender: TObject);
begin
  // Free the device object if it has been unplugged
  if Assigned(IOWarrior) and not IOWarrior.IsPluggedIn then
  begin
    FreeAndNil(IOWarrior);
    // throw away the log (better save it before unplugging)
    EnableDevice := False;
  end;

  // if no IO-Warrior in use yet then search for one
  if not Assigned(IOWarrior) then
    if HidCtl.CheckOutByCallback(IOWarrior, FindLcdIOWarrior) then
    begin
      EnableDevice := True;
    end;
  if Assigned(IOWarrior) then
  begin
    if IOWarrior.Attributes.ProductID = cIOWarrior24PID then
      IOWarriorAvailable.Caption := 'IOWarrior 24 found'
    else
      IOWarriorAvailable.Caption := 'IOWarrior 40 found';
  end
  else
    IOWarriorAvailable.Caption := 'No IOWarrior found';
end;

procedure TLCDMainForm.HidCtlDeviceData(HidDev: TJvHidDevice; ReportID: Byte;
  const Data: Pointer; Size: Word);
var
  I: Integer;
  Str: string;
  P: PChar;
begin
  P := Data;
end;

procedure TLCDMainForm.EnableChkClick(Sender: TObject);
var
  I: Integer;
  BytesWritten: Cardinal;
  IOWarriorOutputReport: TIOWarriorOutputReport;
begin
  if Assigned(IOWarrior) then
    with IOWarriorOutputReport do
    begin
      // initialize the output report to enable/disable the LCD module
      ReportID := cLCDEnableReportID;
      for I := Low(LCDBytes) to High(LCDBytes) do
        LCDBytes[I] := $00;
      if EnableDevice then
        LCDBytes[Low(LCDBytes)] := cEnable
      else
        LCDBytes[Low(LCDBytes)] := cDisable;
      // write the bits to the IO-Warrior to enable/disable the LCD
      IOWarrior.WriteFile(IOWarriorOutputReport, SizeOf(IOWarriorOutputReport), BytesWritten);
    end;
end;

procedure TLCDMainForm.Button1Click(Sender: TObject);
var
  I: Integer;
  Written: Cardinal;
  Str: string;
  IOWarriorOutputReport: TIOWarriorOutputReport;
begin
  with IOWarriorOutputReport do
  begin
    ReportID := cLCDWriteReportID;
    // get the input from the user
    LCDBytes[1] := $03;
    LCDBytes[2] := $3C;
    LCDBytes[3] := $0E;
    LCDBytes[4] := $01;
    For I := 5 to 7 do
      LCDBytes[I] := $00;
    // reset unused bits in first byte
    LCDBytes[1] := LCDBytes[1] and $07;
    // add the RS bit from the checkbox
//    if RSBit.Checked then
//      LCDBytes[1] := LCDBytes[1] or $80;
    IOWarrior.WriteFile(IOWarriorOutputReport, 8, Written);
  end;
end;

procedure TLCDMainForm.SendData(S: String; Pos: Byte);
var
  I: Integer;
  Written: Cardinal;
  Text: String;
  Str: string;
  IOWarriorOutputReport: TIOWarriorOutputReport;
begin
  with IOWarriorOutputReport do
  begin
    ReportID := cLCDWriteReportID;
    // Set Position
    For I := 1 to 7 do
      LCDBytes[I] := $00;
    LCDBytes[1] := $01 and $07;
    LCDBytes[2] := Pos;
    IOWarrior.WriteFile(IOWarriorOutputReport, 8, Written);

    Text := S;
    While Length(Text) > 0 do
    begin

      For I := 2 to 7 do
        If Length(Text) >= I-1 then
          LCDBytes[I] := Ord(Text[I-1]) else
            LCDBytes[I] := $00;
      If Length(Text) < 6 then
        LCDBytes[1] := Length(Text) else
          LCDBytes[1] := 6;
      Delete(Text, 1, 6);

      // reset unused bits in first byte
      LCDBytes[1] := LCDBytes[1] and $07;
      // add the RS bit to send Display text
      LCDBytes[1] := LCDBytes[1] or $80;
      IOWarrior.WriteFile(IOWarriorOutputReport, 8, Written);
    end;
  end;
end;

procedure TLCDMainForm.Button2Click(Sender: TObject);
begin
  SendData(edData.Text, StrToIntDef(edPos.Text, $80));
end;

end.
