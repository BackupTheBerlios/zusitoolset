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
  while Pos('�', S) > 0 do
    S[Pos('�', S)] := '�';
  while Pos('�', S) > 0 do
    S[Pos('�', S)] := '�';
  while Pos('�', S) > 0 do
    S[Pos('�', S)] := '�';
  Result := S;
end;

end.
