unit uTimetables;

interface

uses Classes, FloatList;

type
  TPosition = record
    Line: Integer;
    Track: Integer;
    Station: Integer;
  end;

  TStation = class
    Name: String;
    Display: String;
    FileName: String;
    Position: Single;
  end;

  TStations = class
  private
    fStations: TList;
    function GetStation(Index: Integer): TStation;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Name, FileName: String; Position: Single);
    property Station[Index: Integer]: TStation read GetStation; default;
    property Count: Integer read GetCount;
  end;

  TTrack = class
    Route: String;
    Stations: TStations;
    constructor Create;
    destructor Destroy; override;
  end;

  TTracks = class
  private
    fTracks: TList;
    function GetTrack(Index: Integer): TTrack;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Track: TTrack);
    property Track[Index: Integer]: TTrack read GetTrack; default;
    property Count: Integer read GetCount;
  end;

  TLine = class
    Name: String;
    Directory: String;
    Folder: String;
    Tracks: TTracks;
    constructor Create;
    destructor Destroy; override;
  end;

  TLines = class
  private
    fLines: TList;
    function GetLine(Index: Integer): TLine;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Line: TLine);
    property Line[Index: Integer]: TLine read GetLine; default;
    property Count: Integer read GetCount;
  end;

implementation

constructor TLine.Create;
begin
  Tracks := TTracks.Create;
end;

destructor TLine.Destroy;
begin
  Tracks.Free;
end;

constructor TTrack.Create;
begin
  Stations := TStations.Create;
end;

destructor TTrack.Destroy;
begin
  Stations.Free;
end;

constructor TStations.Create;
begin
  fStations := TList.Create;
end;

destructor TStations.Destroy;
begin
  fStations.Free;
end;

function TStations.GetStation(Index: Integer): TStation;
begin
  Result := TStation(fStations.Items[Index]);
end;

function TStations.GetCount: Integer;
begin
  Result := fStations.Count;
end;

procedure TStations.Add(Name, FileName: String; Position: Single);
var
  Station: TStation;
begin
  Station := TStation.Create;
  Station.Name := Name;
  Station.FileName := FileName;
  Station.Position := Position;
  fStations.Add(Station);
end;

constructor TTracks.Create;
begin
  fTracks := TList.Create;
end;

destructor TTracks.Destroy;
begin
  fTracks.Free;
end;

function TTracks.GetTrack(Index: Integer): TTrack;
begin
  Result := TTrack(fTracks.Items[Index]);
end;

procedure TTracks.Add(Track: TTrack);
begin
  fTracks.Add(Track);
end;

function TTracks.GetCount: Integer;
begin
  Result := fTracks.Count;
end;

constructor TLines.Create;
begin
  fLines := TList.Create;
end;

destructor TLines.Destroy;
begin
  fLines.Free;
end;

function TLines.GetLine(Index: Integer): TLine;
begin
  Result := TLine(fLines.Items[Index]);
end;

function TLines.GetCount: Integer;
begin
  Result := fLines.Count;
end;

procedure TLines.Add(Line: TLine);
begin
  fLines.Add(Line);
end;


end.
