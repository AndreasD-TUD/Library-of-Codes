Gewichtung in R
================
11 Februar, 2025

- [Verwendete neue Befehle](#verwendete-neue-befehle)
- [Pakete laden](#pakete-laden)
- [Gewichten](#gewichten)
  - [Mit gewichteten Daten arbeiten - s*urvey* und
    *srvyr*](#mit-gewichteten-daten-arbeiten---survey-und-srvyr)
  - [Mittelwertberechnung](#mittelwertberechnung)
  - [Berechnung des
    Konfidenzintervalls](#berechnung-des-konfidenzintervalls)
  - [Berechnung Varianz und Quantile](#berechnung-varianz-und-quantile)
  - [QQ-Plot](#qq-plot)
- [Absolute und relative Häufigkeit mit
  `frq()`](#absolute-und-relative-häufigkeit-mit-frq)
- [Deskriptive Statistiken mit
  *Summarytools*](#deskriptive-statistiken-mit-summarytools)

# Verwendete neue Befehle

------------------------------------------------------------------------

`svydesign()` = Gewichteten Datensatz erstellen (survey)  
as_survey_design`()` = Gewichteten Datensatz erstellen für die Arbeit
mit dplyr (srvyr)  
`survey_mean()` = Gewichteten Mittelwert berechnen (srvyr)  
`cascade()` = Berechnung und Anlegen mehrerer Variablen in einem Befehl
(dplyr)  
`survey_var()` = Gewichtete Varianz berechnen (srvyr)  
`survey_quantile()` = Gewichtete Quantile berechnen (srvyr)  
`svyqqmath()` = Gewichteten QQPlot generieren (survey)  
`freq()` = Häufigkeitstabelle berechnen (summarytools)  
`descr()` = Deskriptive Statistiken berechnen (summarytools)

------------------------------------------------------------------------

# Pakete laden

Neben den bereits bekannten Paketen benötigen wir nun noch zusätzlich
das *survey*-, *srvyr*- und *summarytools*-Paket.

Das *survey*-Paket ist unser zentralles Paket in diesem Skript, auch
wenn dessen Funktion nicht so häufig aufgerufen werden. Mit diesem Paket
werden Befehle bereit gestellt, die die Berücksichtung eines komplexen
Erhebungsdesign, wie im ESS, über Gewichtung ermöglicht.

Das *srvyr*-Paket ist eine Ergänzung zu *survey* mit der wir in der
gewohnten Struktur von *dplyr* weiter arbeiten können. *srvyr* übernimmt
lediglich die Transformation der Daten in ein lesbares Format für
*dplyr*. Die Gewichtung wird weiterhin mit Hilfe des *survey*-Paketes
durchgeführt.

Das *summarytools*-Pakte gibt uns ähnlich wie *sjmisc* oder *psych* eine
breite Palette von Befeheln mit denen wir die deskriptiven Statistiken
berechnen können. Entgegen den anderen Paketen lässt sich
*summarytools* gut mit *dplyr* und Gewichtung verbinden.

``` r
install.packages("survey")
install.packages("srvyr")
install.packages("summarytools")
```

``` r
library(haven)
library(dplyr)
library(tidyr)
library(survey)
library(srvyr)
library(sjmisc)
library(sjPlot)
library(summarytools)
```

Datensatz wieder einlesen (Wenn nötig)

``` r
data <- read_sav("ESS10_HV.sav")
```

# Gewichten

**Warum gewichten?**

In der Stichprobenentwicklung nutzen wir verschiedene Methoden um die
zufällige Auswahl von Personen oder die Vergleichbarkeit verschiedener
Gruppen (disproportional geschichte Stichprobe) zu gewährleisten. Dabei
entstehen immer wieder gewollte wie auch ungewollte Verzerrungen in
unseren Daten, wodurch manche Stimmen entgegen unserem Willen mehr
Gewicht haben, als andere. Um diese Verzerrungen zu kompensieren werden
in den meisten Umfragen Gewichtungsparameter mitgeliefert, die wir
verwenden können.

In dem ESS werden verschiedene Parameter mitgeliefert, die unter
<https://www.europeansocialsurvey.org/methodology/ess-methodology/data-processing-and-archiving/weighting>
genauer betrachtet werden können.

Im Folgenden werden verschiedene Möglichkeiten aufgezeigt, mit denen die
Gewichtungsparameter berücksichtigt werden können. Wie auch bei anderen
Befehlen gibt es bei manchen Vor-und Nachteile, die je nach Situation
abgewägt werden müssen.

## Mit gewichteten Daten arbeiten - s*urvey* und *srvyr*

Zum Anfang werden wir den gewichteten Datensatz definieren. Dies ist mit
dem Befehl `svydesign()` des *survey*-Paketes oder mit
`as_survey_design()` des *srvyr*-Paketes möglich.  
Folgend beide Variationen.

**Wichtig!**  
Je nachdem mit welchem ESS wir arbeiten müssen wir die Option
`...(..., weights = ...)` anpassen. In dem ESS10 stehen uns alle
Gewichtungsparameter zu Verfügung, weswegen wir mit dem empfohlenen
`anweight` arbeiten. Im ESS11 ist dieses Gewicht noch nicht angegeben,
da hier unter anderem das post-stratified design weight `pspwght` fehlt.
Aus diesem Grund arbeiten wir im ESS11 notgedrungen mit `dweight`.

``` r
data_weigth_survey <- svydesign(ids = ~psu, 
                                strata = ~stratum, 
                                weights = ~anweight, 
                                data = data, 
                                nest = TRUE)

data_weight_srvyr <- data %>% as_survey_design(ids = psu, 
                                               strata = stratum, 
                                               weights = anweight, 
                                               nest = TRUE)
```

Wie zu sehen sind, sie die beiden Funktionen sehr ähnlich im Aufbau.

`ids = ...` –\> Hier geben wir die Rangfolge der Cluster an. Diese sind
vom ESS mit `psu` vorgegeben.  
`strata = ...` –\> Hier geben wir die Informationen zu den Schichten an.
Wieder vorgegeben mit `stratum`  
`weights = ...` –\> Hier geben wir unseren Geichtungsparameter an. Für
den ESS10 ist das `anweight` und für ESS11 `dweight`  
`data = ...` –\> Hier wird der Datensatz angegeben. Bei
`as_survey_design` erfolgt dies vor dem Befehl `<- data %>% ...`  
`nest = TRUE` –\> Hiermit geben wir an, das es Überschneidungen zwischen
Schichten und Cluster gibt. Die Cluster werden in die Schichten
eingebettet.

Im folgenden arbeiten wir nun mit dem neuen Datensatz, der durch das
*srvyr*-Paket entstanden ist.

Die Gewichtung führt nun zu unterschiedlichen Ergebnissen in den
deskriptiven Analysen. Um das zu berücksichtigen können wir nun
verschiedene Befehle zur erneuten Berechnung des Mittelwertes, der
Standardabweichung, und vieles mehr, nutzen.

## Mittelwertberechnung

Für die Berechnung des Mittelwertes und dem dazugehörigen
Konfidenzinterval verwenden wir die Funktion `survey_mean()` (*srvyr*).
Eine weitere geläufige Funktion ist `svymean()` des *survey*-Paketes.
Dieses wird aber hier nicht weiter berücksichtigt.  
In der Arbeit mit `survey_mean()` können wir leider nicht wie wir es
gewohnt sind mit `select()` arbeiten. Anstelle von `select()` arbeiten
wir nun mit dem Befehl `across()` des *dplyr-* oder mit `cascade()` des
*srvyr-*Paketes. Die Befehle `filter()`, `group_by()`, `mutate()` und
`summarise()` sind weiterhin möglich.

Der Befehl `survey_mean()` muss häufig mit `summarise()` oder mit
`mutate()` verbunden werden. In den meisten Fällen ist es nicht möglich
den Befehl allein auszuführen.

**Die Berechnung einer Variable**

``` r
data_weight_srvyr %>% 
  summarise(mean = survey_mean(hv_power, na.rm = TRUE))
```

    ## # A tibble: 1 × 2
    ##     mean mean_se
    ##    <dbl>   <dbl>
    ## 1 -0.949  0.0113

``` r
data_weight_srvyr %>% 
  filter(cntry == "GB") %>%
  summarise(mean = survey_mean(hv_power, na.rm = TRUE))
```

    ## # A tibble: 1 × 2
    ##    mean mean_se
    ##   <dbl>   <dbl>
    ## 1 -1.20  0.0316

``` r
data_weight_srvyr %>% 
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  summarise(mean = survey_mean(hv_power, na.rm = TRUE))
```

    ## # A tibble: 3 × 3
    ##   cntry                mean mean_se
    ##   <chr+lbl>           <dbl>   <dbl>
    ## 1 BE [Belgium]        -1.14  0.0295
    ## 2 GB [United Kingdom] -1.20  0.0316
    ## 3 SI [Slovenia]       -1.13  0.0263

Um den Mittelwert der gewichteten Daten zu errechnen rufen wir zuerst
den gewichteten Datensatz `data_weight_srvyr` auf und passen diesen wie
gewohnt und nach Bedarf mit `filter()` oder `group_by()` an.

Um den Mittelwert zu berechnen verwenden wir nun den
`summarise()`-Befehl des *dplyr* Paketes, welche alle Werte einer Spalte
zu einem Wert zusammenführt. In unseren Fall den Mittelwert. Diesen
zusammengefassten Wert geben wir die Bezeichnung `mean` mit
`summarise(mean = ...)`.

Die Berechnung des Mittelwertes erfolgt dann mit dem Befehl
`survey_mean(...)`. Innerhalb dieses Befehles geben wir noch die
Information der zu berechnenden Variable `hv_power` an und die Option
dass die `NA`s entfernt werden sollen.

Neben den Mittelwert erhalten wir auch noch den Standardfehler (also
inwieweit unsere Mittelwert von der Grundgesamtheit abweichen kann
-Schätzung!).

**Die Berechnung mehrere Variablen Gleichzeitig**

Für die Berechnung mehrere Variablen gelichzeitig können wir auf
`across()` des *dplyr*-Paketes oder auf `cascade()` des *srvyr*-Paketes
zurückgreifen. Der Befehl `cascade()` funktioniert genauso wie der
`summarise()`-Befehl, nur mit dem Unterschied das wir mehrere Werte
berechnen können.

``` r
data_weight_srvyr %>% 
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  summarise(across(c("hv_power", "hv_univ", "hv_achiev"), 
                   ~survey_mean(.,na.rm = TRUE)))
```

    ## # A tibble: 3 × 7
    ##   cntry           hv_power hv_power_se hv_univ hv_univ_se hv_achiev hv_achiev_se
    ##   <chr+lbl>          <dbl>       <dbl>   <dbl>      <dbl>     <dbl>        <dbl>
    ## 1 BE [Belgium]       -1.14      0.0295   0.605     0.0189    -0.437       0.0302
    ## 2 GB [United Kin…    -1.20      0.0316   0.810     0.0248    -0.525       0.0355
    ## 3 SI [Slovenia]      -1.13      0.0263   0.522     0.0157    -0.145       0.0215

``` r
#oder mit cascade

data_weight_srvyr %>% 
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  cascade(mean_power = survey_mean(hv_power, na.rm = TRUE), 
          mean_univ = survey_mean(hv_univ, na.rm = TRUE), 
          mean_achiev = survey_mean(hv_achiev, na.rm = TRUE))
```

    ## # A tibble: 4 × 7
    ##   cntry              mean_power mean_power_se mean_univ mean_univ_se mean_achiev
    ##   <chr+lbl>               <dbl>         <dbl>     <dbl>        <dbl>       <dbl>
    ## 1 BE [Belgium]            -1.14        0.0295     0.605       0.0189      -0.437
    ## 2 GB [United Kingdo…      -1.20        0.0316     0.810       0.0248      -0.525
    ## 3 SI [Slovenia]           -1.13        0.0263     0.522       0.0157      -0.145
    ## 4 <NA>                    -1.19        0.0265     0.773       0.0206      -0.502
    ## # ℹ 1 more variable: mean_achiev_se <dbl>

In `across(...)` geben wir wie im `lapply()`-Befehl (in dem Skript noch
nicht behandelt) die Variablen an die wir in einem Befehl einsetzen
möchten. Dabei werden zu erst die Variablen als Vektor mit `c(...)`
angegeben und dann der auszuführende Befehl `survey_mean()` mit `~`
davor. Die Stelle an der wir die Variablen einsetzen wollen wird wieder
mit dem Platzhalter `.` markiert.

## Berechnung des Konfidenzintervalls

Die Berechnung des Konfidenzintervalls funktioniert mit den selben
Befehlen die zuvor verwendet wurden. In `survey_mean()` wird lediglich
die Option `survey_mean(..., vartype = "ci")` ergänzt. `ci` steht hier
stellvertretend für Konfidenzintervall.

Mit der zusätzlichen Option `survey_mean(..., level = ...)` können wir
zudem die Grenzen des Konfidenzintervalls festlegen.

**Wichtig:**  
Bei der Berechnung des **Konfidenzintervalls** werden bei `svymean()`
und `survey_mean()` unterschiedliche Annahmen bezüglich der
Freiheitsgrade angenommen (die Freiheitsgrade werden durch
unterschiedliche Stichprobendesigns beeinflusst). Bei `svymean()` wird
von einer Normalverteilung und bei `survey_mean()` von einer
studentischen t-Verteilung (angepasst an das Design) ausgegangen. Aus
diesem Grund können sich die Ergebnisse zwischen den beiden Funktionen
unterscheiden. Will man mit `survey_mean()` das gleiche Ergebnis wie bei
`svymean()`, so ergänzt man die Option `survey_mean(..., df = INF)`.

``` r
data_weight_srvyr %>% 
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  summarise(across(c("hv_power", "hv_univ", "hv_achiev"), 
                   ~survey_mean(.,na.rm = TRUE, vartype = "ci")))
```

    ## # A tibble: 3 × 10
    ##   cntry       hv_power hv_power_low hv_power_upp hv_univ hv_univ_low hv_univ_upp
    ##   <chr+lbl>      <dbl>        <dbl>        <dbl>   <dbl>       <dbl>       <dbl>
    ## 1 BE [Belgiu…    -1.14        -1.20        -1.08   0.605       0.568       0.642
    ## 2 GB [United…    -1.20        -1.26        -1.14   0.810       0.762       0.859
    ## 3 SI [Sloven…    -1.13        -1.18        -1.08   0.522       0.492       0.553
    ## # ℹ 3 more variables: hv_achiev <dbl>, hv_achiev_low <dbl>, hv_achiev_upp <dbl>

``` r
#Anpassung des Konfidenzintervalls auf 2,5% und 97,5%

data_weight_srvyr %>% 
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  summarise(across(c("hv_power", "hv_univ", "hv_achiev"), 
                   ~survey_mean(.,na.rm = TRUE, vartype = "ci", level = 0.975)))
```

    ## # A tibble: 3 × 10
    ##   cntry       hv_power hv_power_low hv_power_upp hv_univ hv_univ_low hv_univ_upp
    ##   <chr+lbl>      <dbl>        <dbl>        <dbl>   <dbl>       <dbl>       <dbl>
    ## 1 BE [Belgiu…    -1.14        -1.21        -1.08   0.605       0.563       0.648
    ## 2 GB [United…    -1.20        -1.27        -1.13   0.810       0.755       0.866
    ## 3 SI [Sloven…    -1.13        -1.19        -1.07   0.522       0.487       0.558
    ## # ℹ 3 more variables: hv_achiev <dbl>, hv_achiev_low <dbl>, hv_achiev_upp <dbl>

## Berechnung Varianz und Quantile

``` r
data_weight_srvyr %>% 
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  cascade(mean_power = survey_mean(hv_power, na.rm = TRUE),
          var_power = survey_var(hv_power, na.rm = TRUE),
          quan_power = survey_quantile(hv_power, quantiles = c(0.25, 0.5, 0.75), na.rm = TRUE))
```

    ## # A tibble: 4 × 11
    ##   cntry           mean_power mean_power_se var_power var_power_se quan_power_q25
    ##   <chr+lbl>            <dbl>         <dbl>     <dbl>        <dbl>          <dbl>
    ## 1 BE [Belgium]         -1.14        0.0295     0.713       0.0352          -1.67
    ## 2 GB [United Kin…      -1.20        0.0316     0.701       0.0339          -1.76
    ## 3 SI [Slovenia]        -1.13        0.0263     0.641       0.0283          -1.64
    ## 4 <NA>                 -1.19        0.0265     0.701       0.0284          -1.74
    ## # ℹ 5 more variables: quan_power_q50 <dbl>, quan_power_q75 <dbl>,
    ## #   quan_power_q25_se <dbl>, quan_power_q50_se <dbl>, quan_power_q75_se <dbl>

## QQ-Plot

Die Gewichtung hat auch einen Einfluss auf die Verteilungsfunktion.
Demnach empfiehlt es sich je nach Situation ebenso einen Blick darauf zu
werfen. Die Erstellung des QQ-Plots ist mit dem Befehl `svyqqmath()` des
*survey*-Paketes möglich. Wichtig ist zu beachten das wir jetzt mit dem
gewichteten Datensatz `data_weight_survey`, anstelle von
`data_weight_srvyr`, arbeiten.

Im folgenden ein Vergleich zwichen gewichteten und ungewichteten Daten
(Zuerst ungewichtet, dann gewichtet)

``` r
qqnorm(data$hv_power)
```

![download](https://github.com/user-attachments/assets/4b00f94c-c1fd-49cd-952b-ddf99d8550a6)


``` r
svyqqmath(~hv_power, design=data_weigth_survey)
```

![download](https://github.com/user-attachments/assets/8215dd08-027a-4759-ab63-5552de677a79)


# Absolute und relative Häufigkeit mit `frq()`

Für die Berechnung der gewichteten Häufigkeiten können wir die bereits
bekannte Funktion `frq()` verwenden. Dafür ergänzen wir einfach die
Opiton `frq(..., weights = ...)`.  
Beachte hier wieder die Unterschiedung der Gewichte in ESS10 und ESS11!

``` r
data %>%
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  frq(lrscale, weights = anweight, out = "viewer")
```

<table style="border-collapse:collapse; border:none;">
<caption style="font-weight: bold; text-align:left;">
Placement on left right scale (lrscale)
<span style="font-weight: normal; font-style: italic">\<numeric\></span><br><span style="font-weight: normal;"><em>grouped
by:</em><br>BE</span>
</caption>
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align:left;text-align:left; ">
val
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: left;">
label
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
frq
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
raw.prc
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
valid.prc
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
cum.prc
</th>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Left
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
30
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3.28
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3.28
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3.28
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
18
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1.97
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1.97
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.25
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
54
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.90
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.90
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
11.15
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
85
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.29
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.29
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
20.44
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
82
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8.96
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8.96
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
29.40
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
324
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
35.41
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
35.41
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
64.81
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
98
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
10.71
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
10.71
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
75.52
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
112
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
12.24
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
12.24
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
87.76
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
70
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.65
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.65
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
95.41
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
17
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1.86
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1.86
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
97.27
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
10
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Right
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
25
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.73
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.73
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
77
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Refusal
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
88
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Don’t know
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
99
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
No answer
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; border-bottom: 1px solid; ">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: left;">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
NA
</td>
</tr>
<tr>
<td colspan="7" style="font-style:italic; border-top:double black; text-align:right;">
total N=915 · valid N=915 · x̄=5.10 · σ=2.09
</td>
</tr>
</table>
<p>
 
</p>
<table style="border-collapse:collapse; border:none;">
<caption style="font-weight: bold; text-align:left;">
Placement on left right scale (lrscale)
<span style="font-weight: normal; font-style: italic">\<numeric\></span><br><span style="font-weight: normal;"><em>grouped
by:</em><br>GB</span>
</caption>
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align:left;text-align:left; ">
val
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: left;">
label
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
frq
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
raw.prc
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
valid.prc
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
cum.prc
</th>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Left
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
213
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4.11
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4.11
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4.11
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
110
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.12
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.12
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
6.24
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
377
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.28
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.28
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
13.51
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
714
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
13.78
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
13.78
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
27.30
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
481
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.29
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.29
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
36.58
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1742
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
33.63
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
33.63
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
70.21
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
533
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
10.29
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
10.29
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
80.50
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
496
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.58
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.58
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
90.08
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
293
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.66
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.66
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
95.73
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
81
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1.56
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1.56
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
97.30
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
10
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Right
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
140
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.70
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.70
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
77
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Refusal
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
88
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Don’t know
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
99
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
No answer
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; border-bottom: 1px solid; ">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: left;">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
NA
</td>
</tr>
<tr>
<td colspan="7" style="font-style:italic; border-top:double black; text-align:right;">
total N=5180 · valid N=5180 · x̄=4.78 · σ=2.13
</td>
</tr>
</table>
<p>
 
</p>
<table style="border-collapse:collapse; border:none;">
<caption style="font-weight: bold; text-align:left;">
Placement on left right scale (lrscale)
<span style="font-weight: normal; font-style: italic">\<numeric\></span><br><span style="font-weight: normal;"><em>grouped
by:</em><br>SI</span>
</caption>
<tr>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align:left;text-align:left; ">
val
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: left;">
label
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
frq
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
raw.prc
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
valid.prc
</th>
<th style="border-top: double; text-align:center; font-style:italic; font-weight:normal; padding:0.2cm; border-bottom:1px solid black; text-align: right;">
cum.prc
</th>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Left
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
11
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.14
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.14
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
7.14
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.60
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.60
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.74
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.19
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.19
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
14.94
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
13
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8.44
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8.44
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
23.38
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.84
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.84
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
29.22
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
69
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
44.81
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
44.81
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
74.03
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.84
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.84
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
79.87
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.19
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.19
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
85.06
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
8
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.84
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.84
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
90.91
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
9
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.60
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2.60
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
93.51
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
10
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Right
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
10
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
6.49
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
6.49
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
77
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Refusal
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
88
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Don’t know
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
99
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
No answer
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; border-bottom: 1px solid; ">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: left;">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
NA
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
NA
</td>
</tr>
<tr>
<td colspan="7" style="font-style:italic; border-top:double black; text-align:right;">
total N=154 · valid N=154 · x̄=4.93 · σ=2.41
</td>
</tr>
</table>

# Deskriptive Statistiken mit *Summarytools*

Mit *summarytools* können wir ähnlich wie mit dem `describe()`-Befehl
des *psych*-Paketes die relevantesten deskriptiven Statistiken mit einem
Befehl ausgeben lassen. Dabei lässt sich dieser gut mit *dplyr*
verknüpfen.

Wie folgt ein Beispiel:

**Beachte:**

Der Befehl `descr()` kommt sowohl in dem *sjmisc*, als auch in dem
*summarytools*-Paket vor. Es kann demnach in manchen Situationen nötig
sein, dass vor dem ausführen entweder die Pakete *sjmisc* und *sjPlot*
deaktiviert werden müssen oder dass Paket vor dem auszuführenden Befehl
ergänzt wird. Dies ist möglich mit

    detach("package:sjPlot", unload = TRUE)
    detach("package:sjmisc", unload = TRUE)

oder mit

    summarytools::descr(...)

Je nach dem welches Paket ihr zuletzt aktiviert habt, wird es auf den
einen oder anderen Befehl zurückgreifen

``` r
#Häufigkeitstabelle
data %>%
  filter(cntry %in% c("GB", "BE", "SI")) %>%
  group_by(cntry) %>%
  freq(lrscale, weights = anweight)
```

    ## Weighted Frequencies  
    ## lrscale  
    ## Label: Placement on left right scale  
    ## Type: Numeric  
    ## Weights: anweight  
    ## Group: cntry = BE  
    ## 
    ##                 Freq   % Valid   % Valid Cum.   % Total   % Total Cum.
    ## ----------- -------- --------- -------------- --------- --------------
    ##           0    29.80      3.26           3.26      3.09           3.09
    ##           1    17.52      1.92           5.18      1.82           4.91
    ##           2    53.92      5.90          11.07      5.60          10.51
    ##           3    85.36      9.34          20.41      8.86          19.38
    ##           4    82.14      8.99          29.40      8.53          27.91
    ##           5   324.18     35.46          64.86     33.67          61.57
    ##           6    97.73     10.69          75.55     10.15          71.72
    ##           7   111.72     12.22          87.77     11.60          83.32
    ##           8    70.29      7.69          95.46      7.30          90.62
    ##           9    16.89      1.85          97.31      1.75          92.38
    ##          10    24.59      2.69         100.00      2.55          94.93
    ##        <NA>    48.81                               5.07         100.00
    ##       Total   962.94    100.00         100.00    100.00         100.00
    ## 
    ## Group: cntry = GB  
    ## 
    ##                  Freq   % Valid   % Valid Cum.   % Total   % Total Cum.
    ## ----------- --------- --------- -------------- --------- --------------
    ##           0    213.31      4.12           4.12      3.87           3.87
    ##           1    109.69      2.12           6.23      1.99           5.86
    ##           2    377.47      7.29          13.52      6.85          12.72
    ##           3    713.85     13.78          27.30     12.96          25.67
    ##           4    481.50      9.29          36.59      8.74          34.42
    ##           5   1742.27     33.63          70.22     31.63          66.04
    ##           6    532.94     10.29          80.50      9.67          75.72
    ##           7    495.89      9.57          90.07      9.00          84.72
    ##           8    292.81      5.65          95.73      5.32          90.04
    ##           9     81.33      1.57          97.30      1.48          91.51
    ##          10    140.11      2.70         100.00      2.54          94.06
    ##        <NA>    327.40                               5.94         100.00
    ##       Total   5508.56    100.00         100.00    100.00         100.00
    ## 
    ## Group: cntry = SI  
    ## 
    ##                 Freq   % Valid   % Valid Cum.   % Total   % Total Cum.
    ## ----------- -------- --------- -------------- --------- --------------
    ##           0    11.07      7.19           7.19      6.18           6.18
    ##           1     3.50      2.28           9.47      1.96           8.13
    ##           2     7.52      4.89          14.36      4.20          12.33
    ##           3    13.12      8.53          22.89      7.32          19.65
    ##           4     9.44      6.14          29.03      5.27          24.93
    ##           5    69.17     44.97          73.99     38.62          63.54
    ##           6     9.08      5.90          79.89      5.07          68.61
    ##           7     8.31      5.41          85.30      4.64          73.25
    ##           8     8.83      5.74          91.04      4.93          78.18
    ##           9     4.19      2.72          93.76      2.34          80.52
    ##          10     9.59      6.24         100.00      5.36          85.88
    ##        <NA>    25.30                              14.12         100.00
    ##       Total   179.12    100.00         100.00    100.00         100.00

``` r
#Deskriptive Analyse mit einer Variable
data %>%
  descr(hv_selfd, weights = .$anweight)
```

    ## Weighted Descriptive Statistics  
    ## hv_selfd  
    ## Weights: .anweight  
    ## N: 37611  
    ## 
    ##                   hv_selfd
    ## --------------- ----------
    ##            Mean       0.35
    ##         Std.Dev       0.78
    ##             Min      -4.44
    ##          Median       0.36
    ##             Max       3.95
    ##             MAD       0.74
    ##              CV       2.21
    ##         N.Valid   26250.10
    ##       Pct.Valid      99.26

``` r
#Deskriptive Analyse mit mehreren Variablen unter verschiedenen Bedingungen

data %>%
  filter(cntry %in% c("GB", "IT", "BE")) %>%
  group_by(cntry) %>%
  select(hv_selfd, hv_power, hv_univ, anweight) %>%
  group_map(~summarytools::descr(., weights = .$anweight))
```

    ## Adding missing grouping variables: `cntry`
    ## x must either be a summarytools object created with freq(), descr(), or a list
    ## of summarytools objects created using by()

Bei der Ausgabe mehrerer Variablen fällt auf, dass es auch immer die
deskriptiven Statistiken des Gewichtungsparameters ausgibt. Dies kann
leider nicht verhindert werden (beziehungsweise nicht ohne den Code zu
verkomplizieren).

Ebenso müssen wir in Kombination des Befehles `descr()` und `group_by()`
noch `group_map()` einarbeiten. Dies führt dazu das wir die Länder nach
ihrer Reihenfolge im Datensatz (alphabetisch) ausgegeben bekommen.
