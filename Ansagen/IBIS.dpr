program IBIS;

{
Das Copyright der Software liegt bei Daniel Schuhmann. Die Software
kann frei verwendet und beliebig ge�ndert werden, solange der
Copyrighthinweis erhalten bleibt.
Die Ver�ffentlichung dieses Programms erfolgt in der Hoffnung, da�
es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar
ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT
F�R EINEN BESTIMMTEN ZWECK.

Viel Spa�,
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
