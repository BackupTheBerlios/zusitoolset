unit LCDUtils;

interface

function GetUmlaut(Text: String): String;

implementation

function GetUmlaut(Text: String): String;
var
  I: Integer;
  S: String;
begin
  S := Text;
  while Pos('ä', S) > 0 do
    S[Pos('ä', S)] := 'á';
  while Pos('ö', S) > 0 do
    S[Pos('ö', S)] := 'ï';
  while Pos('ü', S) > 0 do
    S[Pos('ü', S)] := 'õ';
  Result := S;
end;

end.
