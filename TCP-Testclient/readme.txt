TCP-Testclient f�r Delphi


Was ist das?
Dieser Testclient mit Delphi-Sourcecode richtet sich an alle Delphi-
Entwickler, die TCP-Anwendungen f�r Zusi programmieren wollen. Der
Client erlaubt einen einfachen Einstieg in das TCP-Datenausgabe-
Protokoll und bietet einen guten Startpunkt f�r eigene Anwendungen.
Das Programm ist in der Lage, sich am TCP-Server anzumelden und die 
ID 85 f�r die Streckenkilometrierung anzufordern. Die aktuelle 
Kilometrierung zeigt es dann im Programm an.

Was ist n�tig?
Die Demo verwendet f�r die Kommunikation die Komponente TWSocket von 
Francois Piette, die in der kostenlosen Internetkomponentensammlung 
ICS enthalten ist. Die ICS kann unter
http://www.overbyte.be/frame_index.html?redirTo=/products/ics.html
heruntergeladen werden.
Zus�tzlich ist noch die Komponente TCiaBuffer von Wilfried Mestdagh 
erforderlich. Diese �berwacht den eingehenden Datenstrom und k�mmert 
sich um die korrekte Paketl�nge. Somit wird f�r jedes vollst�ndig 
empfangene Paket ein Ereignis ausgel�st, �ber das das aktuelle Paket 
empfangen werden kann. Den TCiaBuffer gibt es zum Download unter
http://users.pandora.be/sonal.nv/ics/demos/CiaBuffer.zip
Nach Installation der Komponenten kann es losgehen. Die Demo wurde 
unter Delphi 7 Personal kompiliert, sollte aber auch unter anderen 
Versionen problemlos kompilieren.

Wie funktioniert es?
Die Funktion des Programms ist im Sourcecode ausf�hrlich erkl�rt 
und sollte keine weiteren Probleme aufwerfen.
Das Protokoll kann unter
http://www.smartcoder.net/eisenbahn/zusi/tcp
heruntergeladen werden.

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
