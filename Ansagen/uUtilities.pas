unit uUtilities;

interface

uses Classes, SysUtils;

Procedure FindFiles (aPath, aFindMask: String; aWithSub: Boolean; aResult: tStrings);

implementation

Procedure FindFiles (aPath, aFindMask: String; aWithSub: Boolean; aResult: tStrings);
Var  
  FindRec: tSearchRec;
Begin  
  // Wenn die Stringliste nil ist oder aPath oder aFind nicht angegeben ist  
  // dann raus  
  If (aPath = '') or (aFindMask = '') or Not Assigned (aResult) Then  
    Exit;  

 
  // Wenn am Ende der Pfadangabe noch kein \ steht, dieses hinzufügen  
  If aPath[Length (aPath)] <> '\' Then  
    aPath := aPath + '\';  

 
  // Im aktuellen Verzeichnis nach der Datei suchen  
  If FindFirst (aPath + aFindMask, faAnyFile, FindRec) = 0 Then  
    Repeat  
      If (FindRec.Name <> '.') and (FindRec.Name <> '..') Then  
        // ...Ergebnis in die Stringlist einfügen  
        aResult.Add (aPath + FindRec.Name);  
    Until FindNext (FindRec) <> 0;

 
  FindClose (FindRec);  

 
  // Wenn nicht in Unterverzeichnissen gesucht werden soll dann raus  
  If Not aWithSub Then  
    Exit;  

 
  // In Unterverzeichnissen weiter suchen  
  If FindFirst (aPath + '*.*', faAnyFile, FindRec) = 0 Then  
    Repeat  
      If (FindRec.Name <> '.') and (FindRec.Name <> '..') Then  
        // Feststellen, ob es sich um ein Verzeichnis handelt  
        If Boolean (FindRec.Attr and faDirectory) Then  
          // Funktion erneut aufrufen, um Verzeichnis zu durchsuchen (Rekursion)  
          FindFiles (aPath + FindRec.Name, aFindMask, aWithSub, aResult);  
    Until FindNext (FindRec) <> 0;  

 
   FindClose (FindRec);  
End; 


end.
