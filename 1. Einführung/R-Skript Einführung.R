#---------------------Verwendete Befehle---------------------------------------------------
  
#  `<-` = Wert speichern
#  `c()` = Erstellen eines Vektors
#  `rep()` = Erstellen eines Vektors, Wiederholung eines Wertes
#  `seq()` = Erstellen eines Vektors, Festgelegte abstuffungen zwischen einem Minimun und Maximum
#  `mean(..., na.rm = TRUE)` = Mittelwertberechnung (mit Option NA-Werte entfernen)
#  `?` = Hilfeseite aufrufen
#  `as.numeric()` = In numerischen Wert umwandeln
#  `getwd()` = Arbeitspfad auslesen
#  `setwd()` = Arbeitspfad setzen
#  `install.packages()` = Pakete installieren
#  `library()` = Pakete aktivieren

  
# ---------------------Zu Beginn---------------------
  
#  R ist wie bereits erwähnt eine skriptbasierte Sprache. Das bedeutet wir führen unsere Berechnungen mit geschriebenen Befehlen aus. Doch bevor wir dazu kommen, erstmal grundlegende Informationen.
  
#  Sofern dieses Skript das erste Mal geöffnet ist sollte das rechte obere Fenster "Environment" noch leer sein. Dort werden die Variablen angezeigt, welche wir zum Berechnen verwenden. Der erste Schritt wird demnach erstmal sein, probeweise **Variablen anzulegen**
    
#  Dies funktioniert wie folgt:
    
#  *Hinweis: Das ausführen eines Befehls in einer Zeile ist durch die Tastenkombination STRG + Enter möglich. Soll ein kompletter Abschnitt ausgeführt werden, so kann dieser markiert und mit jener Tastenkombination ausgeführt werden. Die visuelle Oberfläche von Quarto ermöglicht ebenso die Nutzung von Buttons, welche sich in den "executable cells" (Befehlszellen) oben rechts befinden. Damit kann die komplette grau hinterlegte Box ausgeführt werden.*
    
# Mit dem "<-" weisen wir einer selbstgewählten Variable (mit selbstgewählter Bezeichnung) einen bestimmten Wert zu.
  
  variable <- 42
  
# Nun lassen wir uns diese Variable zur Überprüfung ausgeben.
  
  variable

  
#  Hinweis: Mit `#` können wir in unser Skript Kommentare einbauen. Diese werden nicht als Befehl ausgeführt.
  
#  Nun können wir in der Environment unsere Variable "variable" mit dem dazugehörigen Wert sehen.
  
  ## Datentypen
  
#  Legen wir wie folgt weitere Variablen mit verschiedenen wichtigsten **Datentypen** an.
  
#  **Numeric**
#  Wir weisen `x` wieder die Zahl 42 zu. `x` wir als Datentyp "numeric" gespeichert.
  
  x <- 42

  
#  **Charakter**
#  `y` soll die Frage "Was ist der Sinn des Lebens" enthalten. Um dies zu ermöglichen müssen wir Textzeichen immer in `" "` anführen. `y` wird als Datentyp "character" gespeichert.
  
  y <- "Was ist der Sinn des Lebens?"
  
#  **Logical**
#  `z` soll einen Boolean-Wert (in R als logical bezeichnet) beinhalten. Dieser ist wichtig, wenn wir eine Berechnung unter bestimmten Bedingungen durchführen wollen, die Bedingungen also WAHR oder FALSCH sind. Boolesche Werte sind in R `FALSE` oder `TRUE`, sie können auch abgekürzt als `F` oder `T` geschrieben werden. Diese Werte werden von R-Studio hellblau gefärbt. `z` wird als Datenyp "logical" gespeichert
  
  z <- FALSE
  
#  **Vektor**
#  `v` soll ein Vektor sein. Vektoren enthalten ein Reihe von Werten, welche verschiedenen Datentypen angehören können. Die Werte werden in einer Reihe aufgelistet. Um einen Vektor zu generieren benötigen wir den Befehl `c()`. Zu den Befehlen gleich mehr. In dem Vektor kommt die Bezeichnung `NA` vor, dies steht stellvertretend für fehlende Werte. Ein fehlender Wert kann entstehen, wenn eine befragte Person in einem Fragebogen keine Auskunft gibt.
  
  v <- c(1, 2, 4, 5, 1, "2", NA, 3, 7, 9)
  
#  Ein Vektor kann auch mit weiteren Befehlen erstellt werden. Beispielsweise *`rep()`* und *`seq()`*. Bei `rep()` geben wir an, dass ein bestimmter Wert bestimmte Male wiederholt werden soll. Mit `seq()` können wir einen Vekor generieren, welcher zwischen einem Minimum und Maximum Werte in bestimmten Schritten ausgibt.\
#  Im folgenden generieren wir einen Vektor `v_rep` welcher aus 10 Einsen besteht und einen Vektor `v_seq` welcher alle Were von 1 bis 10 in Einerschritten beinhaltet. Anschließend lassen wir uns die Vektoren ausgeben.
  
  v_rep <- rep(1,10)
  v_rep
  
  v_seq <- seq(1,10, 1)
  v_seq
  
#  Es gibt noch viele weitere Datentypen, welche auch Paktespezifisch sein können.
  
  ## Befehle
  
#  Und nun zu den **Befehlen**. Ein Befehl beginnt immer der Bezeichnung des Befehles gefolgt von ( ). Besonders wichtig ist bei einem Befehl die Einhaltung der Syntax (der Grammatik der Programmiersprache/des Befehles). Auf der bereits erwähnten Hilfeseite findet sich in der Regel zu jedem Befehl eine detailierte Beschreibung der Syntax.
  
#  Wir wollen nun Probeweise den Mittelwert des Vektors "v" berechnen. Dies ist mit dem Befehl *`mean()`* möglich.
  
#  *Hinweis: Bei dem Schreiben von Befehlen empfiehlt R-Studio automatisch existierende Funktionen. Diese können dann mit TAB alternativ ausgewählt werden. Dies ersparrt bei längeren Funktionsnamen Zeit.*
    
  mean(v)
  
#  Wir erhalten eine Warn-/Fehlermeldung und das Ergebnis lautet "NA" ("kein Wert")
  
#  Der "spaßigste" Teil beim Programmieren ist das Debuggen und nimmt in der Regel die meiste Zeit in Anspruch (insbesondere wenn eine Programmiersprache neu gelernt wird). Debuggen bedeutet nichts anderes als das Entfernen von Fehlern. Bei Auftauchenden Fehlern kann entweder das Internet gefragt werden oder man überprüft zuerst die Syntax.
  
#  Zweiteres wollen wir mit `?mean()` versuchen.
  
  ?mean()
  
#  In dem unteren rechten Fenster erscheint nun die Informationsseite zu dem Befehl. Unter *Usage* sehen wir die Syntax und unter *Arguments* eine genauere Ausführung der Variablen, welche wir für die Berechnung verwenden dürfen, und Optionen, mit denen wir den Befehl anpassen können. Eine wichtige zusätzliche Option beim Befehl mean() ist das ignorieren von NA-Werten. Optionen in einem Befehl werden durch ein Komma ( , ) abgegrenzt.
  
#  Da wir einen NA-Wert in dem Vektor haben, probieren wir dies.
  
  mean(v, na.rm = TRUE)
  
#  Dies hat nicht funktioniert. Einen Blick auf die Warnmeldung zeigt an, dass das Argument (also v) keine numerischen oder booleschen Werte enthält. Ein Blick in das obere rechte Fenster (Environment) verdeutlich dies. Hier wird v als charakter (chr) bestehen aus eine Reihe und zehn Spalten [1:10] angezeigt. Ebenso sind alle Zahlen in " " aufgeführt. Die Ursache dafür liegt in dem Wert "2", welchen wir mit in dem Vektor eingegeben haben. Da es sich hier um den Datentyp charakter handelt, wandelt R auch alle anderen Zahlen in den Vektor zu den Datentyp charakter um. R will dahingehend vereinheitlichen.
  
#  Um dieses Problem zu lösen können wir mit dem Befehl *`as.numeric()`* den Datentyp ändern.
  
  v
  as.numeric(v)
  
#  In Verbindung mit dem Befehl mean() sieht dies nun wie folgt aus.
  
  mean(as.numeric(v))
  mean(as.numeric(v), na.rm = TRUE)
  
#  Bisher haben wir v nur temporär geändert, wodurch wir in jeder weiteren Berechnung den Befehl as.numeric immer wieder verwenden müssten. Wir ersparen uns das, in dem wir v überschreiben.
  
  v <- as.numeric(v)
  v
  
#---------------------Dateipfad setzen und suchen---------------------
  
#  Nach dem ein neues Projekt angelegt wurde, wird auch immer ein Arbeitsort festgelegt, in welchem das Projekt als solches, die generierten und zu ladenden Datensätz, wie auch die gespeicherten Grafiken oder auch Tabellen zu finden sind. Manchmal kann es notwendig sein diesen Ort zu ändern. Die ist entweder in der Registerleiste oben links unter "Session" –\> "Set Working Directory" oder über den Befehl *`setwd()`* möglich.
  
#  Der Arbeitsort wird automatisch immer dort gesetzt, von wo aus ihr das jeweilige Skript geöffnet habt. Es kann sich demnach anbieten, alle Skripte in den Arbeitsordner zu verschieben.
  
#  Bevor wir eine neuen Speicherort setzen können wir und mit *`getwd()`* unseren aktuellen einsehen
  
  getwd()
  
#  Und nun wird ein neuer Dateipfad gesetzt.\
#  (Beachte die Richtung des "/" \| Bei Windows `"C:/..."` \| Bei Mac `"~/..."`)
  
  # Beispiel:
  setwd("C:/Users/Arbeitsdesktop/OneDrive/Dokumente/SHK TU Dresden/Tutorium Quanti")
  getwd()
  
#---------------------Pakete installieren und laden---------------------
  
#  Die Grundausstattung von R enthält viele Funktionen, wie der Berechnung des Mittelwertes, des Medians, der Standardabweichung, und so weiter. Es ist allerdings oftmals nötig zusätzliche Funktionen aus dem Internet zu importieren, wie zum Beispiel die Berechnung mittels neuer Methoden wie dem LDA (Latent Dirichlet Allocation, ein Methode der Textverarbeitung - Topic Modeling).
  
#  Diese zusätzlichen Funktionen finden sich in bestimmten Paketen, die mehrere weiter Funktionen beinhalten. Wichtige Pakete sind zum Beispiel: "*dplyr*", "*psych*", "*car*", "*ggplot2*" oder auch "*haven*".
  
#  Diese Pakete müssen einmalig installiert und bei jedem Neustart von R aktiviert (geladen) werden.
  
#  Die Installation ist mit dem Befehl *`install.packages("Paketname")`* möglich:

  install.packages("dplyr")
  install.packages("psych")
  install.packages("car")
  install.packages("ggplot2")
  install.packages("haven")
  
#  Mit dem Befehl *`library(Paketname)`* werden diese anschließend aktiviert. Dieser Befehl steht in der Regel immer am Anfang eines Skriptes.

  library(dplyr)
  library(psych)
  library(car)
  library(ggplot2)
  library(haven)
  
#---------------------Youtube-Empfehlung---------------------
  
#  Soweit erstmal das wichtigste Fundament für die weitere Arbeit. Im Rahmen des Kurses werden noch viele weitere Befehle hinzukommen und es wird gezeigt wie ein Datensatz importiert wird und welche Pakete es dazu benötigt.
  
#  Da das Lernen einer Programmiersprache viel Zeit benötigt und oftmals sich nach dem Motto "Learning-by-Doing" vertieft, möchte ich noch folgende Kanalempfehlung mitgeben:
    
#    [**R programming for beginners - R Programming 101**](https://www.youtube.com/playlist?list=PLtL57Fdbwb_Chn-dNR0qBjH3esKS2MXY3)
