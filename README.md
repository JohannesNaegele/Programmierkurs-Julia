# Programmierkurs Julia

In diesem Repository finden sich die Materialien für den Programmierkurs Julia 2024.

## Hilfe zur Installation
Tipps zur Installation finden sich im [Intro](Intro.pdf). Sollte der `PATH` nicht richtig gesetzt sein (das impliziert, VSCode findet Julia nicht und man kann daher kein `.jl`-Skript ausführen), helfen diese Schritte:

### Für MacOS:
1. **Julia-Executable finden**: Öffne das Terminal und führe `which julia` aus. Dies sollte den Pfad zu Julia anzeigen.
2. **PATH aktualisieren**: 
   - Öffne die `.bash_profile` oder `.zshrc` Datei in deinem Home-Verzeichnis mit einem Texteditor (abhängig von deiner Shell).
   - Füge `export PATH="$PATH:/Pfad/zu/Julia"` hinin, wobei `/Pfad/zu/Julia` der Pfad ist, der von `which julia` zurückgegeben wurde.
   - Speichere die Datei und führe `source ~/.bash_profile` oder `source ~/.zshrc` aus, um die Änderungen zu übernehmen.
3. **VSCode konfigurieren**: 
   - Öffne VSCode und gehe zu den Einstellungen.
   - Suche nach Julia und stelle sicher, dass der richtige Pfad zu Julia eingetragen ist.

### Für Windows:
1. **Julia-Executable finden**: Gehe zum Installationsordner von Julia, normalerweise unter `C:\Benutzer\DeinName\AppData\Local\Programs\Julia-1.x.y\bin`.
2. **PATH aktualisieren**: 
   - Öffne die Systemsteuerung und gehe zu "System und Sicherheit" > "System" > "Erweiterte Systemeinstellungen".
   - Klicke auf "Umgebungsvariablen" und dann im Abschnitt "Systemvariablen" auf "Path" und "Bearbeiten".
   - Füge den Pfad zum Julia `bin` Ordner hinzu und klicke auf "OK".
3. **VSCode konfigurieren**: 
   - Öffne VSCode und gehe zu den Einstellungen.
   - Suche nach Julia und stelle sicher, dass der korrekte Pfad zu Julia eingetragen ist.

Stelle sicher, dass du nach dem Ändern der PATH-Variablen alle offenen Terminalfenster oder VSCode neu startest, damit die Änderungen wirksam werden.

## Informationen zur Klausur

- 45 Minuten
- Googlen ist erlaubt, aber keine fortgeschrittene AI (ChatGPT etc.) oder externe Hilfe
- Skript/Notebook muss (am Stück) lauffähig sein!
- Die typischen Themen und der Klausuraufbau werden in etwa so aussehen:
  - Teil 1 (Basics): Loops und Rekursion, Kontrollstrukturen, Broadcasting, Lineare Algebra, Arrays, Funktionen
  - Teil 2 (Datenanalyse): Umgang mit DataFrames, Plots
  - Teil 3 (kurze Aufgabe zu fortgeschrittenen Themen): Typen, Zufallszahlen

## Praxiskurs Statistik

Die Materialien für den Praxikurs Statistik findet ihr [hier](https://github.com/JohannesNaegele/Praxiskurs-Statistik).

## Weitere Resourcen

- Eine schöne Einführung durch Beispiele: [The Julia Express](http://bogumilkaminski.pl/files/julia_express.pdf)