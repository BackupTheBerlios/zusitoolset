TCP-Testclient für Delphi


Was ist das?
Dieser Testclient mit Delphi-Sourcecode richtet sich an alle Delphi-
Entwickler, die TCP-Anwendungen für Zusi programmieren wollen. Der
Client erlaubt einen einfachen Einstieg in das TCP-Datenausgabe-
Protokoll und bietet einen guten Startpunkt für eigene Anwendungen.
Das Programm ist in der Lage, sich am TCP-Server anzumelden und die 
ID 85 für die Streckenkilometrierung anzufordern. Die aktuelle 
Kilometrierung zeigt es dann im Programm an.

Was ist nötig?
Die Demo verwendet für die Kommunikation die Komponente TWSocket von 
Francois Piette, die in der kostenlosen Internetkomponentensammlung 
ICS enthalten ist. Die ICS kann unter
http://www.overbyte.be/frame_index.html?redirTo=/products/ics.html
heruntergeladen werden.
Zusätzlich ist noch die Komponente TCiaBuffer von Wilfried Mestdagh 
erforderlich. Diese überwacht den eingehenden Datenstrom und kümmert 
sich um die korrekte Paketlänge. Somit wird für jedes vollständig 
empfangene Paket ein Ereignis ausgelöst, über das das aktuelle Paket 
empfangen werden kann. Den TCiaBuffer gibt es zum Download unter
http://users.pandora.be/sonal.nv/ics/demos/CiaBuffer.zip
Nach Installation der Komponenten kann es losgehen. Die Demo wurde 
unter Delphi 7 Personal kompiliert, sollte aber auch unter anderen 
Versionen problemlos kompilieren.

Wie funktioniert es?
Die Funktion des Programms ist im Sourcecode ausführlich erklärt 
und sollte keine weiteren Probleme aufwerfen.
Das Protokoll kann unter
http://www.smartcoder.net/eisenbahn/zusi/tcp
heruntergeladen werden.

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
