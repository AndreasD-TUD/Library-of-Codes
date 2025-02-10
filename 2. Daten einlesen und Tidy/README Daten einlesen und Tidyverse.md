Daten einlesen und Tidyverse
================
Andreas Deim
10 Februar, 2025

- [Verwendete Befehle](#verwendete-befehle)
- [Pakete installieren und laden](#pakete-installieren-und-laden)
- [Datensatz einlesen](#datensatz-einlesen)
  - [Einlesebefehl für .sav
    Datensätze](#einlesebefehl-für-sav-datensätze)
  - [Einlesebefehl für .csv-Daten.](#einlesebefehl-für-csv-daten)
- [Exkurs: Setzen von NA Werten](#exkurs-setzen-von-na-werten)
- [Tidyverse zur vereinfachten
  Datenmanipulation](#tidyverse-zur-vereinfachten-datenmanipulation)
  - [Beispielhafte Anwendung von Tidyverse (Beispiel
    1)](#beispielhafte-anwendung-von-tidyverse-beispiel-1)
  - [Beispielhafte Anwendung von Tidyverse (Beispiel
    2)](#beispielhafte-anwendung-von-tidyverse-beispiel-2)

# Verwendete Befehle

------------------------------------------------------------------------

`read_spss()` = Einlesebefehl für sav-Datensätze (haven)  
`read.spss()` = Einlesebefehl für sav-Datensätze (foreign)  
`head()` = Gibt die ersten Werte einer Variable aus  
`read.csv()` = Einlesebefehl für csv-Datensätze  
`View()` = Variable in neuem Register anzeigen lassen (großes “V”)  
`group_by()` = Datensatz in Variablenspezifische Gruppen (z.B.
Ländergruppen) unterteilen (dplyr)  
`summarize()` = Berechnung und ausgabe als neue Variable (dplyr)  
`mutate()` = Berechnung und speichern/überschreiben als neue Variable
(dplyr)  
`left_join()` = Zuordnung eines Wertes im Datensatz (dplyr)  
`select()` = Auswahl einer oder mehrerer Variablen eines Datensatzes
(dplyr)  
`as.data.frame()` = In Format Dataframe transformieren  
`filter()` = Datensatz filtern (dplyr)

------------------------------------------------------------------------

# Pakete installieren und laden

Je nach dem in welchem Format der einzulesende Datensatz vorliegt, kann
es nötig sein zusätzliche Pakete hereunterzuladen und zu aktivieren. Bei
SPSS-Datensätzen (.sav) werden Pakete wie *haven* oder *foreign*
benötigt. Das Paket *haven* ist ein Teil des Paketes *tidyverse*,
welches wir noch später benötigen. Deswegen laden wir das komplette
Paket *tidyverse* herunter, anstatt nur *haven* separat.

Neben den Paketen für das Einlesen von Daten, können wir uns ebenso
Pakete zur Datenberarbeitung und Datenanalyse herunterladen und
aktivieren. Für die Datenbearbeitung empfiehlt sich *dplyr*, welches
ebenso Teil von *tidyverse* ist und für die Datenanalyse *psych*. Mit
dplyr können wir den Datensatz so “manipulieren” wie wir ihn benötigen.
Benötigen wir zum Beispiel nur die Einkommenswerten von Männern in einer
bestimmten Berufsbranche, so müssen wir den Datensatz filtern. Dazu aber
später mehr. Mit dem Pakte *psych* erhalten wir mit dem Befehl
*`describe()`* eine einfache Möglichkeit alle wichtigsten deskreptiven
Statistiken zu einer Variable uns anzeigen zu lassen.

``` r
install.packages("tidyverse")
install.packages("foreign")
install.packages("psych")
install.packages("haven")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tidyr")
```

``` r
library(foreign)
library(haven)
library(dplyr)
library(tidyr)
library(psych)
library(ggplot2)
```

# Datensatz einlesen

In den folgenden Skripten befassen wir uns mit dem Datensatz des
European Social Survey (ESS). Dieser Datensatz kann kostenlos von dem
[ESS Data Portal](https://ess.sikt.no/en/?tab=overview) heruntergeladen
werden. Dafür ist lediglich eine Anmeldung nötig, welche beispielsweise
mit einem bestehenden Google-Account vollzogen werden kann.

Die Daten sind in auf dem Portal in verschiedenen Datenformaten (.csv,
.sav und .dta) erhältlich. Der .sav Datensatz enthält entgegen dem .csv
Datensatz neben den Items und den Werten, zusätzlich noch die verbalen
Bezeichnungen der Werte. Da dies für die Erstellung von grafischen
Abbildungen praktisch sein kann, empfiehlt sich das einlesen der .sav
Dateien. In manchen Fällen kann es praktischer sein direkt auf den
.csv-Datensatz zurück zu greifen, welcher mit dem Befehl *`read.csv()`*
eingelesen werden kann.

## Einlesebefehl für .sav Datensätze

Das einlesen erfolgt über einen Befehl und dem Zuweisen zu einer
selbstgewählten Variable. Im folgenden verwenden wir den Befehl
*`read_spss()`* aus *haven* und *`read.spss()`* aus *foreign*. Beide
Befehle besitzen die gleiche Funktion, haben aber unterschiedliche Vor-
und Nachteile. So muss *haven* nicht extra installiert werden, während
*foreign* mehr Optionen beim Einlesen bietet.

**Empfehlenswert ist es sich beide Befehle auf der Hilfsseite anzeigen
zu lassen.**

Im ersten Schritt müssen wir den Datensatz in dem Arbeitspfad ablegen,
in welchem wir Arbeiten. Zur Erinnerung, den Arbeitspfad erhalten wir
mit *`getwd()`* und setzten wir mit *`setwd()`*. Da der Speicherort
automatisch dort angelegt wird, wo das jeweilige Skript liegt, lohnt es
sich Skripte und Datensätze in einem Ordner abzulegen.

**Ergänzung Arbeitsort wechseln (optional)**

Sollte das Skript nicht mit dem Datensatz in einem Ordner legen, so muss
noch der Arbeitsort geänder werden. Dies kann in Rmarkdown oder Quarto
relativ kompliziert sein und ist bei auftretenden Problemen mit
folgender Befehlskette möglich. Hier muss nur noch der Dateipfad ergänzt
werden.

``` r
require("knitr")
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = "Dateipfad")
setwd("Dateipfad")
getwd()
```

Im zweiten Schritt lesen wir dann den Datensatz ein.

``` r
data1<-read_spss(file = "ESS11.sav") #haven
data2<-read.spss(file = "ESS11.sav") #foreign
```

Nun haben wir den Datensatz ohne weitere Anweisungen eingelesen. Mit dem
Befehl *`read.spss()`* erhalten wir eine Warnmeldung, dass einige Werte
nicht deklariert sind, also keine Information zu der Bedeutung des
Wertes vorliegt. Vergleiche wir `data1` und `data2` in der Environment,
so sehen wir, dass `data1` als Dataframe und `data2` als Liste
eingelesen wurde. Ein Dataframe enthält im gegensatz zu einer Liste
wesentlich mehr Informationen, zum Beispiel die Deklaration der Werte.

Klicken wir im oberen rechten Fenster auf den blauen Pfeil bei `data1`
so sehen wir zu einem die Items beginnend mit `$` und darunter
verschiedene zusätzliche Attribute wie das Label. Ebenso können wir auch
hier wieder den Datentyp einsehen.

Schauen wir uns nun das Item `wrclmch` mit dem *`head()`*-Befehl genauer
an:

``` r
#Mit dem $-Zeichen können wir uns einzelne Items (genauer Faktoren) aufrufen. Der head()-Befehl gibt die ersten 20-Werte aus. 

head(data1$wrclmch, 20)
```

    ## <labelled<double>[20]>: How worried about climate change
    ##  [1] 4 5 5 4 4 4 3 4 4 2 4 3 4 3 4 4 4 2 3 3
    ## 
    ## Labels:
    ##  value              label
    ##      1 Not at all worried
    ##      2   Not very worried
    ##      3   Somewhat worried
    ##      4       Very worried
    ##      5  Extremely worried
    ##      6     Not applicable
    ##      7            Refusal
    ##      8         Don't know
    ##      9          No answer

``` r
head(data2$wrclmch, 20)
```

    ##  [1] Very worried      Extremely worried Extremely worried Very worried     
    ##  [5] Very worried      Very worried      Somewhat worried  Very worried     
    ##  [9] Very worried      Not very worried  Very worried      Somewhat worried 
    ## [13] Very worried      Somewhat worried  Very worried      Very worried     
    ## [17] Very worried      Not very worried  Somewhat worried  Somewhat worried 
    ## 9 Levels: Not at all worried Not very worried ... No answer

Mit data1 erhalten wir neben den ersten 20 Werten auch zusätzliche
Informationen wie die Frage zu dem Item und die verbale Abstufung. Mit
`data2` erhalten wir nur die verbalen Abstufungen, die wir nicht weiter
für die Berechnung verwenden können.

In der Konsequenz müssen wir den Einlesebefehl zu `data2` anpassen. Die
einzelnen Optionen, welche wir nun verwenden wollen, finden sich
ausführlich dokumentiert auf der Hilfeseite.

``` r
data2 <- read.spss(file = "ESS11.sav", to.data.frame = TRUE, use.value.labels = FALSE, use.missings = TRUE)
head(data2$wrclmch, 20)
```

    ##  [1] 4 5 5 4 4 4 3 4 4 2 4 3 4 3 4 4 4 2 3 3

Wir erhalten nun anstelle der verbalen Werte die nummerischen Werte. In
manchen Fällen kann es praktischer sein mit *foreign* zu arbeiten, da
hier nur die numerischen Werte ausgegeben werden, was bei *haven*
zunächst nicht der Fall ist und wodurch es teilweise zu Fehlermeldung in
Kombination mit manchen Befehlen kommen kann.

Im weiteren wollen wir mit `data1` weiterarbeiten, da dies anschaulicher
ist.

## Einlesebefehl für .csv-Daten.

``` r
data3 <- read.csv(file = "ESS11.csv")
head(data3$wrclmch, 300)
```

    ##   [1] 4 5 5 4 4 4 3 4 4 2 4 3 4 3 4 4 4 2 3 3 2 5 2 2 3 3 4 3 3 1 4 5 3 4 4 3 4
    ##  [38] 3 4 3 3 4 1 4 2 3 4 3 4 4 4 5 3 2 4 3 3 3 3 5 4 3 3 4 3 3 4 4 4 3 3 3 3 3
    ##  [75] 4 2 4 5 3 3 3 5 4 4 4 4 4 2 3 4 3 3 4 3 5 4 3 4 3 1 3 5 3 3 3 3 5 5 3 4 4
    ## [112] 2 4 3 4 4 5 4 3 2 3 3 3 4 2 4 3 3 4 2 4 4 3 3 3 3 4 4 4 4 4 3 3 3 3 2 3 2
    ## [149] 4 2 4 3 4 1 4 3 3 4 4 3 4 2 1 3 3 3 3 4 3 3 4 4 5 2 2 2 2 2 3 4 4 3 4 3 4
    ## [186] 3 5 5 4 4 3 3 3 2 4 2 3 3 3 5 3 2 2 5 2 3 4 2 5 4 4 3 3 4 3 3 4 2 4 5 2 2
    ## [223] 3 3 4 2 3 4 5 4 3 5 3 5 4 4 8 1 4 2 1 4 3 4 4 3 2 3 3 3 3 3 3 3 4 4 3 4 2
    ## [260] 3 3 3 4 5 3 2 4 2 3 3 5 3 4 3 3 4 3 4 4 4 3 1 3 3 4 4 3 3 3 4 3 3 2 5 3 4
    ## [297] 3 3 5 3

Wichtig ist hierbei noch, dass angegeben werden muss, welche Werte als
`NA` betrachten werden sollen. So findet sich in der Ausgabe eine
einzelne `8` welche für “Don´t know” steht. Bei einer
Mittelwertberechnung kann dieser Wert das Ergebnis verzerren. Der Befehl
*`read.csv(`*`)` besitzt noch die zusätzlich Option *`na.strings`*,
welche Abhilfe schaffen kann.

``` r
#Es werden 6,7,8 und 9 entsprechend dem Codebook als NA gesetzt.
data3 <- read.csv(file = "ESS11.csv", na.strings = c(6,7,8,9))

head(data1$wrclmch, 300)
```

    ## <labelled<double>[300]>: How worried about climate change
    ##   [1]  4  5  5  4  4  4  3  4  4  2  4  3  4  3  4  4  4  2  3  3  2  5  2  2  3
    ##  [26]  3  4  3  3  1  4  5  3  4  4  3  4  3  4  3  3  4  1  4  2  3  4  3  4  4
    ##  [51]  4  5  3  2  4  3  3  3  3  5  4  3  3  4  3  3  4  4  4  3  3  3  3  3  4
    ##  [76]  2  4  5  3  3  3  5  4  4  4  4  4  2  3  4  3  3  4  3  5  4  3  4  3  1
    ## [101]  3  5  3  3  3  3  5  5  3  4  4  2  4  3  4  4  5  4  3  2  3  3  3  4  2
    ## [126]  4  3  3  4  2  4  4  3  3  3  3  4  4  4  4  4  3  3  3  3  2  3  2  4  2
    ## [151]  4  3  4  1  4  3  3  4  4  3  4  2  1  3  3  3  3  4  3  3  4  4  5  2  2
    ## [176]  2  2  2  3  4  4  3  4  3  4  3  5  5  4  4  3  3  3  2  4  2  3  3  3  5
    ## [201]  3  2  2  5  2  3  4  2  5  4  4  3  3  4  3  3  4  2  4  5  2  2  3  3  4
    ## [226]  2  3  4  5  4  3  5  3  5  4  4 NA  1  4  2  1  4  3  4  4  3  2  3  3  3
    ## [251]  3  3  3  3  4  4  3  4  2  3  3  3  4  5  3  2  4  2  3  3  5  3  4  3  3
    ## [276]  4  3  4  4  4  3  1  3  3  4  4  3  3  3  4  3  3  2  5  3  4  3  3  5  3
    ## 
    ## Labels:
    ##  value              label
    ##      1 Not at all worried
    ##      2   Not very worried
    ##      3   Somewhat worried
    ##      4       Very worried
    ##      5  Extremely worried
    ##      6     Not applicable
    ##      7            Refusal
    ##      8         Don't know
    ##      9          No answer

**Wichtig:** Mit diesem Befehl wurden für alle Items die Werte 6, 7, 8
und 9 als `NA` gesetzt. Das ist problematisch, da manche Items eine
Abstufung von 1 bis 10 besitzen und nun nicht mehr vollständig
abgebildet werden.

Es ist demnach nötig `NA` für jedes Item einzeln zu setzen.

# Exkurs: Setzen von NA Werten

Das Festlegen von `NA` kann auf verschiedene Art und Weisen
funktionieren und ist bei der Berarbeitung selbst erstellter Datensätze
sehr wichtig.

Im weiteren werden zwei Wege vorgestellt, ein komplizierterer, der
allerdings für das Verständnis wichtig ist und ein einfacherer mit Hilfe
dem Paket *dplyr.*

``` r
#Laden wir zunächst nochmal den .csv-Datensatz des ESS ein
data3 <- read.csv(file = "ESS11.csv")
```

Mit Hilfe von **eckigen Klammern** `[]` können wir eine Ausgabe unter
Bedingung erstellen.  
Im folgenden lassen wir uns alle Werte des Items `wrclmch` ausgeben, die
der Zahl 8 entsprechen.

``` r
data3$wrclmch[data3$wrclmch == 8] 
```

    ##  [1] 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
    ## [39] 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8
    ## [77] 8 8 8

Der Befehl funktioniert wie folgt:

`[data3$wrclmch == 8]`

Das doppelte Gleichheitszeichen führt eine logische Operation durch.
Eine logische Operation gibt immer `TRUE` oder `FALSE` aus. In unserem
Fall gibt sie dann `TRUE` aus, wenn ein Wert in data3\$wrclmch einer 8
entspricht, und dann `FALSE`, wenn dies nicht der Fall ist.

`data3$wrclmch[ ]`

Wie lassen uns nun die Werte des Items `wrclmch` dann ausgeben, wenn in
der eckigen Klammer `TRUE` steht, also `wrclmch` gleich 8 ist. Neben dem
doppelten Gleichheitszeichen kann auch `<=` kleiner gleich, `>=` größer
gleich, `<` kleiner als oder `>` größer als verwendet werden.

Diese Ausgabe unter Bedingung kann sehr praktisch sein, wenn
beispielsweise nur das Einkommen von Frauen ausgegeben werden soll.

Um die Werte nun auf `NA` zu setzen, überschreiben wir die `8` einfach.

``` r
data3$wrclmch[data3$wrclmch == 8] <- NA
head(data3$wrclmch, 300)
```

    ##   [1]  4  5  5  4  4  4  3  4  4  2  4  3  4  3  4  4  4  2  3  3  2  5  2  2  3
    ##  [26]  3  4  3  3  1  4  5  3  4  4  3  4  3  4  3  3  4  1  4  2  3  4  3  4  4
    ##  [51]  4  5  3  2  4  3  3  3  3  5  4  3  3  4  3  3  4  4  4  3  3  3  3  3  4
    ##  [76]  2  4  5  3  3  3  5  4  4  4  4  4  2  3  4  3  3  4  3  5  4  3  4  3  1
    ## [101]  3  5  3  3  3  3  5  5  3  4  4  2  4  3  4  4  5  4  3  2  3  3  3  4  2
    ## [126]  4  3  3  4  2  4  4  3  3  3  3  4  4  4  4  4  3  3  3  3  2  3  2  4  2
    ## [151]  4  3  4  1  4  3  3  4  4  3  4  2  1  3  3  3  3  4  3  3  4  4  5  2  2
    ## [176]  2  2  2  3  4  4  3  4  3  4  3  5  5  4  4  3  3  3  2  4  2  3  3  3  5
    ## [201]  3  2  2  5  2  3  4  2  5  4  4  3  3  4  3  3  4  2  4  5  2  2  3  3  4
    ## [226]  2  3  4  5  4  3  5  3  5  4  4 NA  1  4  2  1  4  3  4  4  3  2  3  3  3
    ## [251]  3  3  3  3  4  4  3  4  2  3  3  3  4  5  3  2  4  2  3  3  5  3  4  3  3
    ## [276]  4  3  4  4  4  3  1  3  3  4  4  3  3  3  4  3  3  2  5  3  4  3  3  5  3

Zusätzlich müssten wir noch die `6`, `7` und `9` als `NA` setzen. Dies
können wir entweder wie bereits bekannt mit der Wiederholung es
ausgeführten Befehles machen oder wir passen die Bedingung mit `&`
(logisches UND) oder `|` (logisches ODER) an.

``` r
#Zuerst laden wir nochmal den Datensatz neu ein.
data3 <- read.csv(file = "ESS11.csv")

# Die Bedingung liest sich nun wie folgt: Wenn wrclmch 6 ist ODER wenn wrclmch 7 ist ODER wenn ... ist, dann setzte TRUE. 
data3$wrclmch[data3$wrclmch == 6 | data3$wrclmch == 7 | data3$wrclmch == 8 | data3$wrclmch == 9 ] <- NA
head(data3$wrclmch, 300)
```

    ##   [1]  4  5  5  4  4  4  3  4  4  2  4  3  4  3  4  4  4  2  3  3  2  5  2  2  3
    ##  [26]  3  4  3  3  1  4  5  3  4  4  3  4  3  4  3  3  4  1  4  2  3  4  3  4  4
    ##  [51]  4  5  3  2  4  3  3  3  3  5  4  3  3  4  3  3  4  4  4  3  3  3  3  3  4
    ##  [76]  2  4  5  3  3  3  5  4  4  4  4  4  2  3  4  3  3  4  3  5  4  3  4  3  1
    ## [101]  3  5  3  3  3  3  5  5  3  4  4  2  4  3  4  4  5  4  3  2  3  3  3  4  2
    ## [126]  4  3  3  4  2  4  4  3  3  3  3  4  4  4  4  4  3  3  3  3  2  3  2  4  2
    ## [151]  4  3  4  1  4  3  3  4  4  3  4  2  1  3  3  3  3  4  3  3  4  4  5  2  2
    ## [176]  2  2  2  3  4  4  3  4  3  4  3  5  5  4  4  3  3  3  2  4  2  3  3  3  5
    ## [201]  3  2  2  5  2  3  4  2  5  4  4  3  3  4  3  3  4  2  4  5  2  2  3  3  4
    ## [226]  2  3  4  5  4  3  5  3  5  4  4 NA  1  4  2  1  4  3  4  4  3  2  3  3  3
    ## [251]  3  3  3  3  4  4  3  4  2  3  3  3  4  5  3  2  4  2  3  3  5  3  4  3  3
    ## [276]  4  3  4  4  4  3  1  3  3  4  4  3  3  3  4  3  3  2  5  3  4  3  3  5  3

Diese Vorgehensweise ist üblich, wenn man ohne die Pakete *dplyr* oder
*tidyr* arbeitet. Wie man schnell sieht kann diese sehr unübersichtliche
Züge annehmen.

Aus dem Grund schauen wir uns im weiteren die eben genannten Pakete
genauer an.

# Tidyverse zur vereinfachten Datenmanipulation

Eine wichtige Empfehlung vorab. Im Internet gibt es sehr hilfreiche
sogenannte **Cheat Sheets**. Diese fassen auf einer oder zwei Seiten die
wichtigsten Befehle eines Paketes zusammen und ermöglichen schnell auf
die benötigten Funktionen zurückzugreifen. Am Anfang sind diese Blätter
relativ kompliziert, werden aber mit der Zeit zu großartigen
Spickzetteln.

Die wichtigsten Spickzettel findet ihr im oberen Register unter “Help
-\> Cheat Sheets”. Unter anderem sind da auch die Cheat Sheets zu
*dplyr* und *ggplot2* welche für das weitere Seminar relevant sind.

Nun zu *dplyr* und *tidyr*. Beide Pakete arbeiten mit der selben
Struktur, wodurch sie sich in ihrer Anwendung sehr ähneln. Wir werden
unseren Fokus vor allem *dplyr* legen, da dieses Paket aus meiner
Erfahrung häufiger in der Praxis anzuetreffen ist.

**Grundlegendes:**

1.  Jede Variable / jedes Item wird in einer Spalte dargestellt.
2.  Jede Kalkulation zwischen Variablen oder Items findet in der selben
    Reihe statt.
3.  Befehle werden mit sogenannten “pipes” (`|>` oder `%>%`) aufeinander
    aufgebaut.

Um das zu verstehen lohnt es sich nochmal damit zu beschäftigen, **wie
Datensätze aussehen** **und wie man sich sie imaginär vorstellen muss.**
Das geht relativ einfach mit einen Doppelklick auf `data1` in der
Environment. Alternativ ist es auch möglich den Befehl `View(data1)`
auszuführen und sich so den Datensatz anzeigen zu lassen.

``` r
View(data1)
```

Betrachten wir den Datensatz, so sehen wir, dass in jeder Spalte ein
Item oder eine Variable abgebildet ist. Die Spalten stellen demnach die
Variablen dar. Die Reihen stehen dagegen für jeweils eine Person.
Schauen wir uns die Zahlen unter der Tabelle an, so sehen wir dass es
558 verschiedene Variablen (Spalten) und 22190 Teilnehmerin (Zeilen) in
dem Datensatz gibt. Wird nun beispielsweise eine Berechnung
durchgeführt, so geschieht dies Zeilenweise. Das heißt zum Beispiel das
die Addition zwischen zwei Variablen Personenweise geschieht, also
jeweils die individuellen Werte zusammengerechnet werden. Somit ist 1.
und 2. erklärt.

## Beispielhafte Anwendung von Tidyverse (Beispiel 1)

Um den Sinn der pipes zu erklären und ein erstes Gefühl für die
vereinfachte Datenmanipulation zu bekommen wird erstmal ein Beispiel
heran genommen. Stellen wir uns vor, wir wollen einen Kennwert für jede
Person entwickeln, wie “konservativ” oder “liberal” sie ist. Dieser Wert
soll länderspezifisch sein, sich also an der nationalen Umwelt
orientieren, um Vergleich auf Länderebene durchführen zu können.

Dafür nehmen wir die Variablen `wprtbym` - Women should be protected by
men, `lrscale` - Placement on left right scale, `freehms` - Gays and
lesbians free to live life as they wish und `gincdif` - Government
should reduce differences in income levels. Im weiteren werden wir die
jeweiligen Mittelwerte der Variablen differenziert nach Land bilden und
dann die jeweilige Differenz zu den Mittelwerten bilden. Die Differenz
wird zum Schluss addiert und bildet unsere Kennzahl.

``` r
data1 %>%
  group_by(cntry) %>%
  summarize(mean_wprtbym = mean(wprtbym, na.rm = T))
```

    ## # A tibble: 13 × 2
    ##    cntry               mean_wprtbym
    ##    <chr+lbl>                  <dbl>
    ##  1 AT [Austria]                2.46
    ##  2 CH [Switzerland]            2.83
    ##  3 DE [Germany]                2.60
    ##  4 FI [Finland]                2.40
    ##  5 GB [United Kingdom]         2.60
    ##  6 HR [Croatia]                2.07
    ##  7 HU [Hungary]                2.47
    ##  8 IE [Ireland]                2.44
    ##  9 LT [Lithuania]              2.80
    ## 10 NL [Netherlands]            2.93
    ## 11 NO [Norway]                 3.18
    ## 12 SI [Slovenia]               1.89
    ## 13 SK [Slovakia]               2.07

`data1 %>%`  
Zuerst nehmen wir uns den Datensatz `data1`.

`group_by(cntry) %>%`  
Danach teilen (gruppieren) wir den Datensatz nach Ländern auf, sodass
wir die Personen nach ihrer Nationalität getrennt haben.

`summarize(mean_wprtbym = mean(wprtbym, na.rm = T))`Und anschließend
bilden wir den Mittelwert der Variable `wprtbym` und ordnen diesen
Mittelwert der Variable `mean_wprtbym`, die wir neu generiert haben.

Im Ergebnis haben wir eine Tabelle mit zwei Spalten und 13 Reihen, die
für die Länder stehen.

**Das nützliche an den pipes:** Da wir am Anfang `data1` “aufgerufen”
haben, ist es nicht mehr nötig die Information, dass wir in diesem
Datensatz arbeiten, immer wieder beizufügen. In dem Befehl
`data3$wrclmch[data3$wrclmch == 6 | data3$wrclmch == 7 | data3$wrclmch == 8 | data3$wrclmch == 9 ] <- NA`
von vorher müssen wir wiederholt angeben, dass wir in dem Datensatz
`data3` und mit der Variable `wrclmch` arbeiten. Dies können wir uns mit
den pipes ersparen. Es ist lediglich notwendig sich imaginär im Kopf zu
behalten welche Datensätze, Spalten oder Zeilen ich gerade verwende. Die
Bestimmung der NA könnte mit dplyr wie folgt aussehen.

``` r
#Wieder den Datensatz einlesen.
data3 <- read.csv(file = "ESS11.csv")

data3 <- data3 %>% mutate(wrclmch = replace(wrclmch, wrclmch %in% c(6,7,8,9), NA))
```

Dieser Befehl besteht aus zwei Teilen. Zum einen aus
`replace(wrclmch, wrclmch %in% c(6,7,8,9), NA)` und zum anderen aus
`mutate(wrclmch = ...)`.  
Mit *`replace()`* ersetzen wir Werte, die eine vorgegebene Bedingungen
erfüllen. In dem Fall lautete die Bedingung “wenn in wrclmch der Wert 6,
7, 8 oder 9 vorkommt” (`wrclmch %in% c(6,7,8,9)`). Ersetzt werden diese
Werte mit `NA`. Mit *`mutate()`* fügen dem dem Datensatz eine neue
Variable hinzu. Da wir allerdings in diesem Fall keine neue Variable
generieren sondern eine Variable ersetzen wollen, geben wir der neu
generierten Variable den bestehenden Namen `wrclmch`, wodurch das zuvor
bestehende `wrclmch` überschrieben wird. Abschließend wird der
abgeänderte Datensatz wieder in `data3` abgespeichert (`data3<- ...`)

Zurück zu unserem Kennwert. Wir widerholen nun die Mittelwertberechnung
für die übrigen Variablen und setzen wieder mit *`mutate()`* die neue
Variable mit den Mittelwerten. Anschließend werden wir mit dem Befehl
*`left_join()`* die Mittelwerte den jeweiligen Personen zuordnen.

``` r
meanwprtbym <- data1 %>%
  group_by(cntry) %>%
  summarize(mean_wprtbym = mean(wprtbym, na.rm = T))

meanlrscale <- data1 %>%
  group_by(cntry) %>%
  summarize(mean_lrscale = mean(lrscale, na.rm = T))

meanfreehms <- data1 %>%
  group_by(cntry) %>%
  summarize(mean_freehms = mean(freehms, na.rm = T))

meangincdif <- data1 %>%
  group_by(cntry) %>%
  summarize(mean_gincdif = mean(gincdif, na.rm = T))

data1<- data1 %>% left_join(.,meanwprtbym, by = "cntry")
data1<- data1 %>% left_join(.,meanlrscale, by = "cntry")
data1<- data1 %>% left_join(.,meanfreehms, by = "cntry")
data1<- data1 %>% left_join(.,meangincdif, by = "cntry")
```

**Hinweis:** In dem Befehl *`left_join()`* haben wir einen Punkt `.`
verwendet. Dieser hat die Funktion eines Platzhalters, in diesem Falle
für den aufgerufen Datensatz `data1`.  
Ein anderes Beispiel:

``` r
data1 %>% select(wprtbym, lrscale, freehms, gincdif) %>% describe(.)
```

    ##         vars     n mean   sd median trimmed  mad min max range  skew kurtosis
    ## wprtbym    1 21700 2.52 1.00      2    2.48 1.48   1   5     4  0.43    -0.23
    ## lrscale    2 19871 5.00 2.20      5    5.02 1.48   0  10    10 -0.02     0.11
    ## freehms    3 21768 2.00 1.09      2    1.81 1.48   1   5     4  1.16     0.74
    ## gincdif    4 21847 2.12 0.98      2    2.00 1.48   1   5     4  0.82     0.21
    ##           se
    ## wprtbym 0.01
    ## lrscale 0.02
    ## freehms 0.01
    ## gincdif 0.01

Der Punkt steht hier stellvertretend für die vier ausgewählten (über den
Befehl *`select()`*) Items des Datensatzes `data1`. In manchen Fällen
kann der Punkt auch weggelassen werden, wenn nur “x” (ein Datensatz oder
Matrix) angegeben werden muss. Bei *`left_join()`* wird “x” und “y”
gefordert, wodurch die Verwendung des Platzhalters notwendig wird.

Und wieder zurück zum eigentlichen Vorhaben: Da wir jetzt jeder Person
den landesweiten Mittelwert der ausgewählten Items zugeordnet haben,
können wir nun die Differenz der Personen zu diesen Mittelwert bilden
und dann einander aufsummieren.

``` r
data1<-data1 %>%
  mutate(lib_con = -(wprtbym - mean_wprtbym) + lrscale - mean_lrscale + freehms - mean_freehms + gincdif - mean_gincdif)

data1 %>% select(lib_con) %>% as.data.frame() %>% describe()
```

    ##         vars     n  mean   sd median trimmed  mad    min   max range  skew
    ## lib_con    1 19136 -0.01 3.12   0.03       0 2.97 -10.39 11.03 21.43 -0.01
    ##         kurtosis   se
    ## lib_con     0.08 0.02

Es muss beachtet werden, das wir die Polung des Items `wprtbym`
umdrehen, umso alle Differenzen gleich auszurichten von liberal
(negativ) zu konservativ (positiv).

Mit *`describe()`* lassen wir uns die wichtigsten Daten zu unserem neuen
Kennwert ausgeben. Für die Berechnung war es wichtig die neue Variable,
welche separiert als *Tibble* (einem speziellen Tabellenformat im
Tidyverse) ausgegeben wird in ein *Data-Frame* über den Befehl
*`as.data.frame()`* umzuwandeln. Dies kann manchmal notwendig sein, wenn
es zu einer Fehlermeldung kommt.

**Abschließend:** Die beispielhafte Entwicklung des Kennwertes ähnelt
der Anwendung der Human Values von Schwartz und wird uns wieder
begegnen. Somit kann dieses Beispiel auch als Orientierung im Umgang mit
den Human Values verwendet werden. Mehr dazu folgt allerdings im Laufe
des Seminares.

## Beispielhafte Anwendung von Tidyverse (Beispiel 2)

Eine weitere praktische Möglichkeit *dplyr* zu verwenden ist die
Generierung neuer Datensätze. Bisher haben wir nur Items im Datensatz
abgeändert oder ergänzt. Nun wollen wir allerdings einen neuen Datensatz
generieren, welcher nur die Human Values zu Conservation der Personen
aus verschiendenen Ländern beinhaltet. Die Verwendung eines
zugeschnittenen Datensatzes kann für die Anwendungen einzelner
Funktionen sehr praktisch sein.

**Hinweis:** Information zu den ESS Human Value Scale finden sich unter
<https://zis.gesis.org/skala/Schwartz-Breyer-Danner-Human-Values-Scale-(ESS)>

Beispiel für Deutschland:

``` r
data_hv_DE <- data1 %>%
  filter(cntry == "DE") %>%
  select(impsafea, ipfrulea, ipmodsta, ipstrgva, ipbhprpa, imptrada)
```

Beispiel für Großbritanien:

``` r
data_hv_GB <- data1 %>%
  filter(cntry == "GB") %>%
  select(impsafea, ipfrulea, ipmodsta, ipstrgva, ipbhprpa, imptrada)
```

Beispiel für Deutschland und Großbritanien:

``` r
data_hv_DE_GB <- data1 %>%
  filter(cntry %in% c("DE", "GB")) %>%
  select(impsafea, ipfrulea, ipmodsta, ipstrgva, ipbhprpa, imptrada)
```

`data1 %>%`  
Zuerst nehmen wir uns wieder den Datensatz `data1`.

`filter(cntry == "DE") %>%`  
Danach filtern wir den Datensatz mit dem Befehl `filter()` nach den
Itemausprägungen, die für uns relevant sind. In den drei Besipielen sind
das jeweils Deutschland `cntry == "DE"` , Großbritanien `cntry =="GB"`
und Deutschland und Großbritanien `cntry %in% c("DE", "GB")`.

`select(impsafea, ipfrulea, ipmodsta, ipstrgva, ipbhprpa, imptrada)`  
Und anschließend wählen wir mit dem Befehl `select()` die Items aus, die
wir in den neuen Datensatz übernehmen wollen.

`data_hv_DE <- ...`  
Nach dem wir die gefilterten Items ausgewählt haben speichern wir diese
in einen neuen Datensatz.
