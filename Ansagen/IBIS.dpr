program IBIS;

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

uses
  Forms,
  uMain in 'uMain.pas' {Main},
  uTimetables in 'uTimetables.pas',
  uUtilities in 'uUtilities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'IBIS';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
