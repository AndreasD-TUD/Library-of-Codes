Einführung in R
================
Andreas Deim
10 Februar, 2025

- [Download und Einrichtung von R, R-Studio](#download-und-einrichtung-von-r-r-studio)
  - [Unterstützung für macOS](#unterstützung-für-macos)
- [Grundlegende Information:](#grundlegende-information)
  - [R-Studio](#r-studio)
  - [R-Markdown](#r-markdown)
- [Schreiben in R](#schreiben-in-r)
  - [Zu Beginn](#zu-beginn)
  - [Dateipfad setzen und suchen](#dateipfad-setzen-und-suchen)
  - [Pakete installieren und laden](#pakete-installieren-und-laden)
  - [Youtube-Empfehlung](#youtube-empfehlung)

# Verwendete neue Befehle

------------------------------------------------------------------------

`<-` = Wert speichern  
`c()` = Erstellen eines Vektors  
`rep()` = Erstellen eines Vektors, Wiederholung eines Wertes  
`seq()` = Erstellen eines Vektors, Festgelegte abstuffungen zwischen
einem Minimun und Maximum  
`mean(..., na.rm = TRUE)` = Mittelwertberechnung (mit Option NA-Werte
entfernen)  
`?` = Hilfeseite aufrufen  
`as.numeric()` = In numerischen Wert umwandeln  
`getwd()` = Arbeitspfad auslesen  
`setwd()` = Arbeitspfad setzen  
`install.packages()` = Pakete installieren  
`library()` = Pakete aktivieren

------------------------------------------------------------------------

# Download und Einrichtung von R, R-Studio

R und R-Studio lassen sich ganz von der folgenden Website herunterladen:
<https://posit.co/download/rstudio-desktop/>

<img src="https://github.com/user-attachments/assets/177baac7-d696-4b00-abb1-66b245072729" alt="" width="1960"/>

Nach der Installation ist es wichtig den Rechner neu zu starten,
andernfalls kann es zu Problemen bei der Ausführung von R kommen.

## Unterstützung für macOS

Da es bei der Anwendung von R auf macOS zu verschiedenen Komplikationen, vor allem bei der Installation von Paketen, kommen kann, lässt sich zur Unterstützung des Betriebssystems zusätzlich XQuartz installieren. 

Diese Installation ist optional: <https://www.xquartz.org/>

# Grundlegende Information:

R ist eine kostenlose und frei verfügbare skriptbasierter
Programmiersprache für statistische Berechnungen und Grafiken. Während
in SPSS statistische Berechnungen mit Hilfe einer grafischen
Benutzeroberfläche möglich sind, muss in R jede Berechnung durch einen
geschriebenen Befehl in einer Konsole durchgeführt werden. R ist
OpenSource und bietet dementsprechend viele Vorteile. So werden von
einer breiten wissenschaftlichen Community fortlaufend neue
Berechnungsmethoden und statistische Verfahren bereitgestellt, welche
nur selten in SPSS implementiert sind.

## R-Studio

R-Studio ist eine zusätzliche grafische Oberfläche, welche die Nutzung
von R als Programmiersprache vereinfacht. Sie wird parallel mit R
heruntergeladen und installiert.

Im folgenden die wichtigsten Bestandteile in R-Studio.

<img src="https://github.com/user-attachments/assets/b12c32d7-c236-4e5a-929d-bf294c9ae1fd" alt="" width="1960"/>

------------------------------------------------------------------------

<img src="https://github.com/user-attachments/assets/0b47c6f1-b4ba-42f9-9cfa-966f32f8e9d0" alt="" width="400"/>

In dem oberen Registerfeld können die wichtigsten Funktionen genutzt
werden. Das Laden von kompletten Skripten, die Generierung neuer
Projekte und setzen von Arbeitspfaden (Wo Daten geladen und gespeichert
werden sollen) ist hier möglich ohne die Nutzung der Konsole.

------------------------------------------------------------------------
<img src="https://github.com/user-attachments/assets/651b3a77-5b1f-486c-9c36-537d48969fca" alt="" width="700"/>
In dem oberen linken Fenster finden sich die Skripte, welche vorab
geschrieben wurden. Hier werden die Befehle der Reihe nach
eingeschrieben und mit STRG + Enter ausgeführt.

Neben den Befehlen können auch Kommentare gesetzt werden, welche einen
besseren Überblick für Personen schaffen kann, die jenes Skript nicht
geschrieben haben. Dies ist entweder mit \# oder mit ‚‘ möglich.
Kommentare werden Grün hervorgehoben. Insbesondere bei komplexeren
Skripten empfiehlt sich die Verwendung von Kommentaren.

------------------------------------------------------------------------
<img src="https://github.com/user-attachments/assets/3c0e84f2-a49d-41b3-91ce-dee0f83a105f" alt="" width="700"/>

In dem unteren linken Fenster befindet sich die Befehlskonsole von R.
Ohne die Oberfläche R-Studio, würde nur dieses Feld für statistische
Berechnungen bereitstehen. In diesem Feld werden die zuvor geschriebenen
Befehle ausgeführt. Findet die Bearbeitung eines Befehles statt, so
erscheint im oberen rechten Eck ein rotes STOP-Symbol. Bei ungewollter
längerer Ausführung oder bei fehlerhaften Befehlen, kann es wenigen
Fällen nötig sein durch ein Klicken auf dieses Symbol den
Bearbeitungsprozess zu beenden. Darauf hin kommt es zu einer
Fehlermeldung.

In der Konsole finden sich zudem nach der Ausführung des Befehls die
Ergebnisse einer Berechnung. Kommt es zu Fehlern, zum Beispiel eine
Division durch 0, so werden in diesem Feld rot gefärbte Fehlermeldungen
ausgegeben.

------------------------------------------------------------------------
<img src="https://github.com/user-attachments/assets/c5c4c871-5cf8-4d35-9584-f932aedb36ee" alt="" width="700"/>

In der oberen rechten Ecke befindet sich das Environment. Hier werden
alle geladenen und gesetzten Variablen und Datensätze angezeigt. Eine
wichtige Information kann dabei der mitangezeigte Datentyp sein. Sollte
zum Beispiel die Zahl 42 als Zeichenkette (als String) gespeichert sein,
so ist es nicht möglich sie für Berechnungen zu verwenden. In dem Falle
erkennt R (wie auch viele weitere Programmiersprachen) die 42 als
eigenständiges Wort und nicht mehr als Zahl. Es ist dann nötig mit einem
Befehl den Datentyp zu ändern.

Mit einem Klick auf den angezeigt Datensatz oder Variable können die
Inhalte in einem separaten Fenster angeschaut werden. Diese öffnet sich
dann in dem linken oberen Fenster, wo auch die Skripte angezeigt werden.

Neben den Variablen werden auch Informationen, wie der verwendete
Arbeitsspeicher, angezeigt. Mit einem Klick auf den Besen werden alle
Datensätze und Variablen aus dem Environment entfernt. Dies kann in
manchen Fällen hilfreich sein, wenn der Speicher voll ist oder ein neues
Skript zur Berechnung von neuen Datensätzen verwendet wird.

------------------------------------------------------------------------
<img src="https://github.com/user-attachments/assets/a348fdd1-d248-4d76-ba8c-4471c28e007a" alt="" width="600"/>

In dem rechten unteren Fenster werden die Dateien in dem aktuellen
Arbeitspfad, generierte Grafiken, geladene Pakete und die Hilfeseite
angezeigt.

<img src="https://github.com/user-attachments/assets/3354197c-d002-4702-94f4-8fbb59afd5c8" alt="" width="600"/>

Die Grafiken können direkt mit über die Schaltfläche „Export“
gespeichert werden. Alternativ ist dies auch über Befehle wie png()
möglich. Über die Pfeiltasten können vorher ausgeführt Grafiken erneut
angeschaut werden.

<img src="https://github.com/user-attachments/assets/3a5667ca-436c-4b79-a3c8-14d427cbe733" alt="" width="600"/>

Pakete sind ein wichtiger Bestandteil in der Arbeit mit R. Pakete
liefern vorgefertigte Funktionen und Befehle, welche wir für die Analyse
von Daten benötigen. In diesem Fenster können Pakete aktiviert oder auch
deaktiviert werden. Dies ist nötig, um auf die Befehle in den Paketen
zuzugreifen. Alternativ geschieht das geläufig durch den Befehl
*`library()`*. Neben der Standardausrüstung die R bereit hält (z.B. Paket
„base“) sind auch zusätzliche Pakete aus der Community wie „dplyr“ und
„ggplot2“ von hoher Relevanz. Ersteres vereinfacht die Programmierung,
zweiteres ermöglicht komplexere grafische Ausgaben.

<img src="https://github.com/user-attachments/assets/e4259437-ae81-4e37-b72a-0871b865c01a" alt="" width="600"/>

Die Hilfeseite ist sprichwörtlich dein bester Freund. Hier werden
Struktur und theoretischer Hintergrund von Befehlen ausführlich
aufgezeigt. Alternativ kann die Suche nach einem Befehl mit einem
?Befehl oder ??Befehl in der Konsole erfolgen.

Sollte ein Befehl nicht funktionieren, ist dies die erste Anlaufstelle
um die Ursache des Problems zu finden.

## R-Markdown

Um die Verständlichkeit der folgenden Skripte zu unterstützen arbeiten
wir im folgenden mit R-Markdown. Mit R-Markdown können Skripte einfach
und verständlich kommentiert und später publiziert werden.

Um mit R-Markdown zu arbeiten müssen wir das entsprechende Paket
installieren. Dafür muss die folgende Zeile entweder mit STRG+ENTER oder
über den günen Pfeil in der oberen rechten Ecke des grauen Feldes
angeklickt werden.

``` r
install.packages("rmarkdown")
```

# Schreiben in R

## Zu Beginn

R ist wie bereits erwähnt eine skriptbasierte Sprache. Das bedeutet wir
führen unsere Berechnungen mit geschriebenen Befehlen aus. Doch bevor
wir dazu kommen, erstmal grundlegende Informationen.

Sofern dieses Skript das erste Mal geöffnet ist sollte das rechte obere
Fenster “Environment” noch leer sein. Dort werden die Variablen
angezeigt, welche wir zum Berechnen verwenden. Der erste Schritt wird
demnach erstmal sein, probeweise **Variablen anzulegen**

Dies funktioniert wie folgt:

*Hinweis: Das ausführen eines Befehls in einer Zeile ist durch die
Tastenkombination STRG + Enter möglich. Soll ein kompletter Abschnitt
ausgeführt werden, so kann dieser markiert und mit jener
Tastenkombination ausgeführt werden. Die visuelle Oberfläche von Quarto
ermöglicht ebenso die Nutzung von Buttons, welche sich in den
“executable cells” (Befehlszellen) oben rechts befinden. Damit kann die
komplette grau hinterlegte Box ausgeführt werden.*

``` r
# Mit dem "<-" weisen wir einer selbstgewählten Variable (mit selbstgewählter Bezeichnung) einen bestimmten Wert zu.

variable <- 42

# Nun lassen wir uns diese Variable zur Überprüfung ausgeben.

variable
```

    ## [1] 42

Hinweis: Mit `#` können wir in unser Skript Kommentare einbauen. Diese
werden nicht als Befehl ausgeführt.

Nun können wir in der Environment unsere Variable “variable” mit dem
dazugehörigen Wert sehen.

## Datentypen

Legen wir wie folgt weitere Variablen mit verschiedenen wichtigsten
**Datentypen** an.

**Numeric  
**Wir weisen `x` wieder die Zahl 42 zu. `x` wir als Datentyp “numeric”
gespeichert.

``` r
# Wir weisen "x" wieder die Zahl 42 zu. x wir als Datentyp "numeric" gespeichert. 
x <- 42
```

**Charakter**  
`y` soll die Frage “Was ist der Sinn des Lebens” enthalten. Um dies zu
ermöglichen müssen wir Textzeichen immer in `" "` anführen. `y` wird als
Datentyp “character” gespeichert.

``` r
y <- "Was ist der Sinn des Lebens?"
```

**Logical**  
`z` soll einen Boolean-Wert (in R als logical bezeichnet) beinhalten.
Dieser ist wichtig, wenn wir eine Berechnung unter bestimmten
Bedingungen durchführen wollen, die Bedingungen also WAHR oder FALSCH
sind. Boolesche Werte sind in R `FALSE` oder `TRUE`, sie können auch
abgekürzt als `F` oder `T` geschrieben werden. Diese Werte werden von
R-Studio hellblau gefärbt. `z` wird als Datenyp “logical” gespeichert

``` r
z <- FALSE
```

**Vektor**  
`v` soll ein Vektor sein. Vektoren enthalten ein Reihe von Werten,
welche verschiedenen Datentypen angehören können. Die Werte werden in
einer Reihe aufgelistet. Um einen Vektor zu generieren benötigen wir den
Befehl `c()`. Zu den Befehlen gleich mehr. In dem Vektor kommt die
Bezeichnung `NA` vor, dies steht stellvertretend für fehlende Werte. Ein
fehlender Wert kann entstehen, wenn eine befragte Person in einem
Fragebogen keine Auskunft gibt.

``` r
v <- c(1, 2, 4, 5, 1, "2", NA, 3, 7, 9)
```

Ein Vektor kann auch mit weiteren Befehlen erstellt werden.
Beispielsweise *`rep()`* und *`seq()`*. Bei `rep()` geben wir an, dass
ein bestimmter Wert bestimmte Male wiederholt werden soll. Mit `seq()`
können wir einen Vekor generieren, welcher zwischen einem Minimum und
Maximum Werte in bestimmten Schritten ausgibt.  
  
Im folgenden generieren wir einen Vektor `v_rep` welcher aus 10 Einsen
besteht und einen Vektor `v_seq` welcher alle Were von 1 bis 10 in
Einerschritten beinhaltet. Anschließend lassen wir uns die Vektoren
ausgeben.

``` r
v_rep <- rep(1,10)
v_rep
```

    ##  [1] 1 1 1 1 1 1 1 1 1 1

``` r
v_seq <- seq(1,10, 1)
v_seq
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

Es gibt noch viele weitere Datentypen, welche auch Paktespezifisch sein
können.

## Befehle

Und nun zu den **Befehlen**. Ein Befehl beginnt immer der Bezeichnung
des Befehles gefolgt von ( ). Besonders wichtig ist bei einem Befehl die
Einhaltung der Syntax (der Grammatik der Programmiersprache/des
Befehles). Auf der bereits erwähnten Hilfeseite findet sich in der Regel
zu jedem Befehl eine detailierte Beschreibung der Syntax.

Wir wollen nun Probeweise den Mittelwert des Vektors “v” berechnen. Dies
ist mit dem Befehl *`mean()`* möglich.

*Hinweis: Bei dem Schreiben von Befehlen empfiehlt R-Studio automatisch
existierende Funktionen. Diese können dann mit TAB alternativ ausgewählt
werden. Dies ersparrt bei längeren Funktionsnamen Zeit.*

``` r
mean(v)
```

    ## Warning in mean.default(v): Argument ist weder numerisch noch boolesch: gebe NA
    ## zurück

    ## [1] NA

Wir erhalten eine Warn-/Fehlermeldung und das Ergebnis lautet “NA”
(“kein Wert”)

Der “spaßigste” Teil beim Programmieren ist das Debuggen und nimmt in
der Regel die meiste Zeit in Anspruch (insbesondere wenn eine
Programmiersprache neu gelernt wird). Debuggen bedeutet nichts anderes
als das Entfernen von Fehlern. Bei Auftauchenden Fehlern kann entweder
das Internet gefragt werden oder man überprüft zuerst die Syntax.

Zweiteres wollen wir mit `?mean()` versuchen.

``` r
?mean()
```

In dem unteren rechten Fenster erscheint nun die Informationsseite zu
dem Befehl. Unter *Usage* sehen wir die Syntax und unter *Arguments*
eine genauere Ausführung der Variablen, welche wir für die Berechnung
verwenden dürfen, und Optionen, mit denen wir den Befehl anpassen
können. Eine wichtige zusätzliche Option beim Befehl mean() ist das
ignorieren von NA-Werten. Optionen in einem Befehl werden durch ein
Komma ( , ) abgegrenzt.

Da wir einen NA-Wert in dem Vektor haben, probieren wir dies.

``` r
mean(v, na.rm = TRUE)
```

    ## Warning in mean.default(v, na.rm = TRUE): Argument ist weder numerisch noch
    ## boolesch: gebe NA zurück

    ## [1] NA

Dies hat nicht funktioniert. Einen Blick auf die Warnmeldung zeigt an,
dass das Argument (also v) keine numerischen oder booleschen Werte
enthält. Ein Blick in das obere rechte Fenster (Environment) verdeutlich
dies. Hier wird v als charakter (chr) bestehen aus eine Reihe und zehn
Spalten \[1:10\] angezeigt. Ebenso sind alle Zahlen in ” ” aufgeführt.
Die Ursache dafür liegt in dem Wert “2”, welchen wir mit in dem Vektor
eingegeben haben. Da es sich hier um den Datentyp charakter handelt,
wandelt R auch alle anderen Zahlen in den Vektor zu den Datentyp
charakter um. R will dahingehend vereinheitlichen.

Um dieses Problem zu lösen können wir mit dem Befehl *`as.numeric()`*
den Datentyp ändern.

``` r
v
```

    ##  [1] "1" "2" "4" "5" "1" "2" NA  "3" "7" "9"

``` r
as.numeric(v)
```

    ##  [1]  1  2  4  5  1  2 NA  3  7  9

In Verbindung mit dem Befehl mean() sieht dies nun wie folgt aus.

``` r
mean(as.numeric(v))
```

    ## [1] NA

``` r
mean(as.numeric(v), na.rm = TRUE)
```

    ## [1] 3.777778

Bisher haben wir v nur temporär geändert, wodurch wir in jeder weiteren
Berechnung den Befehl as.numeric immer wieder verwenden müssten. Wir
ersparen uns das, in dem wir v überschreiben.

``` r
v <- as.numeric(v)
v
```

    ##  [1]  1  2  4  5  1  2 NA  3  7  9

# Dateipfad setzen und suchen

Nach dem ein neues Projekt angelegt wurde, wird auch immer ein
Arbeitsort festgelegt, in welchem das Projekt als solches, die
generierten und zu ladenden Datensätz, wie auch die gespeicherten
Grafiken oder auch Tabellen zu finden sind. Manchmal kann es notwendig
sein diesen Ort zu ändern. Die ist entweder in der Registerleiste oben
links unter “Session” –\> “Set Working Directory” oder über den Befehl
*`setwd()`* möglich.

Der Arbeitsort wird automatisch immer dort gesetzt, von wo aus ihr das
jeweilige Skript geöffnet habt. Es kann sich demnach anbieten, alle
Skripte in den Arbeitsordner zu verschieben.

Bevor wir eine neuen Speicherort setzen können wir und mit *`getwd()`*
unseren aktuellen einsehen

``` r
getwd()
```

    ## [1] "C:/Users/Arbeitsdesktop/OneDrive/Dokumente/SHK TU Dresden/Tutorium Quanti/Quanti MA WS2425"

Und nun wird ein neuer Dateipfad gesetzt.  
(Beachte die Richtung des “/” \| Bei Windows `"C:/..."` \| Bei Mac
`"~/..."`)

``` r
# Beispiel:
setwd("C:/Users/Arbeitsdesktop/OneDrive/Dokumente/SHK TU Dresden/Tutorium Quanti")
getwd()
```

    ## [1] "C:/Users/Arbeitsdesktop/OneDrive/Dokumente/SHK TU Dresden/Tutorium Quanti"

# Pakete installieren und laden

Die Grundausstattung von R enthält viele Funktionen, wie der Berechnung
des Mittelwertes, des Medians, der Standardabweichung, und so weiter. Es
ist allerdings oftmals nötig zusätzliche Funktionen aus dem Internet zu
importieren, wie zum Beispiel die Berechnung mittels neuer Methoden wie
dem LDA (Latent Dirichlet Allocation, ein Methode der Textverarbeitung -
Topic Modeling).

Diese zusätzlichen Funktionen finden sich in bestimmten Paketen, die
mehrere weiter Funktionen beinhalten. Wichtige Pakete sind zum Beispiel:
“*dplyr*”, “*psych*”, “*car*”, “*ggplot2*” oder auch “*haven*”.

Diese Pakete müssen einmalig installiert und bei jedem Neustart von R
aktiviert (geladen) werden.

Die Installation ist mit dem Befehl *`install.packages("Paketname")`*
möglich:

``` r
install.packages("dplyr")
install.packages("psych")
install.packages("car")
install.packages("ggplot2")
install.packages("haven")
```

Mit dem Befehl *`library(Paketname)`* werden diese anschließend
aktiviert. Dieser Befehl steht in der Regel immer am Anfang eines
Skriptes.

``` r
library(dplyr)
library(psych)
library(car)
library(ggplot2)
library(haven)
```

# Youtube-Empfehlung

Soweit erstmal das wichtigste Fundament für die weitere Arbeit. Im
Rahmen des Kurses werden noch viele weitere Befehle hinzukommen und es
wird gezeigt wie ein Datensatz importiert wird und welche Pakete es dazu
benötigt.

Da das Lernen einer Programmiersprache viel Zeit benötigt und oftmals
sich nach dem Motto “Learning-by-Doing” vertieft, möchte ich noch
folgende Kanalempfehlung mitgeben:

[**R programming for beginners - R Programming
101**](https://www.youtube.com/playlist?list=PLtL57Fdbwb_Chn-dNR0qBjH3esKS2MXY3)
