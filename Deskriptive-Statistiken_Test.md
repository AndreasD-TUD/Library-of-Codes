Deskriptive Statistiken
================
Andreas Deim
2024-12-01

- [Pakete Laden](#pakete-laden)
- [Datensatz laden](#datensatz-laden)
- [Deskriptive Analyse](#deskriptive-analyse)

## Pakete Laden

``` r
#Falls nicht Installiert, dann mit install.pakages("...") installieren
install.packages("sjmisc")
install.packages ("sjPlot")
```

``` r
library(haven)
library(dplyr)
library(tidyr)
library(psych)
library(sjmisc)
library(sjPlot)
```

## Datensatz laden

Unseren Datensatz nennen wir der einfachheitshalber `data`.

``` r
data<-read_spss(file = "ESS10.sav")
```

## Deskriptive Analyse

### Exkurs: Human Values nach Schwartz

Eine Besonderheit bei den Human Values ist, dass diese je nach Anwendung
noch auf den individuellen Mittelwert zentriert werden müssen. Stellen
wir uns vor, zwei Personen besitzen bei Universalismus den selben Wert
von 3, allerdings gibt Person A bei allen anderen Human Values
niedrigere Werte und Person B höhere Werte an.Somit steht Universalismus
bei beiden Personen in einem anderen Kontext, auch wenn es den selben
Wert besitzt. Mit der Zentrierung wollen wir die individuelle
Priorsierung der Befragten berücksichtigen.

Referenz: Schwartz, S. (2007). Value orientations: measurement,
antecedents and consequences across nations. In *Measuring Attitudes
Cross-Nationally* (pp. 169-203). SAGE Publications, Ltd,
<https://doi.org/10.4135/9781849209458>

Zuerst müssen wir alle 10 Werteausprägungen erster Ordnung errechnen und
dann den Mittelwert aller Items von den Werteausprägungen abziehen.
Anschließen fügen wir die Werte dem Datensatz hinzu.

**Achtung:** Die folgenden Berechnungen können viel Zeit in Anspruch
nehmen. Alternativ kann von Opal der bereits abgeänderte Datensatz
“ESS10_HV.sav” eingeladen werden

``` r
# Erste Schritt Berechnung des gesamten Mittelwerts den wir dann abziehen wollen

data <- data %>%
  rowwise() %>%
  mutate(hv_mean = mean(c(ipcrtiv, imprich, ipeqopt, ipshabt, impsafe, impdiff, ipfrule, ipudrst, ipmodst, ipgdtim, impfree, iphlppl, ipsuces, ipstrgv, ipadvnt, ipbhprp, iprspot, iplylfr, impenv, imptrad, impfun), na.rm = T))

#Zweiter Schritt Entwicklung der Wertauspärgung 1. Ordnung

#1. Self-Direction
data <- data %>%
  rowwise() %>%
  mutate(hv_selfd = mean(c(ipcrtiv, impfree), na.rm = T) - hv_mean)

#2. Power
data <- data %>%
  rowwise() %>%
  mutate(hv_power = mean(c(imprich, iprspot), na.rm = T) - hv_mean)

#3. Universalism
data <- data %>%
  rowwise() %>%
  mutate(hv_univ = mean(c(ipeqopt, ipudrst, impenv), na.rm = T) - hv_mean)

#4. Achievement
data <- data %>%
  rowwise() %>%
  mutate(hv_achiev = mean(c(ipshabt, ipsuces), na.rm = T) - hv_mean)

#5. Security
data <- data %>%
  rowwise() %>%
  mutate(hv_secur = mean(c(impsafe, ipstrgv), na.rm = T) - hv_mean)

#6. Stimulation
data <- data %>%
  rowwise() %>%
  mutate(hv_stim = mean(c(impdiff, ipadvnt), na.rm = T) - hv_mean)

#7. Conformity
data <- data %>%
  rowwise() %>%
  mutate(hv_conf = mean(c(ipfrule, ipbhprp), na.rm = T) - hv_mean)

#8. Tradition
data <- data %>%
  rowwise() %>%
  mutate(hv_trad = mean(c(ipmodst, imptrad), na.rm = T) - hv_mean)

#9. Hedonism
data <- data %>%
  rowwise() %>%
  mutate(hv_hedon = mean(c(ipgdtim, impfun), na.rm = T) - hv_mean)

#10. Benevolence
data <- data %>%
  rowwise() %>%
  mutate(hv_benev = mean(c(iphlppl, iplylfr), na.rm = T) - hv_mean)
```

Damit können nun die Werteausprägungen für die weitere Berechnung
verwendet werden.

### Häufigkeiten

Einen ersten schönen Überblick erhalten wir mit dem *sjmisc*-Paket. Der
Befehl `frq()` gibt uns zuerst die Häufigkeiten aus der einzelnen
Wertausprägungen aus.

Mit der Option `frq(..., out = "viewer")` geben wir an, dass wir die
Ergebnisse in einer Tabelle im Fenster viewer (unten rechts) ausgegeben
haben wollen.

``` r
frq(data$wrclmch, out = "viewer")
```

<table style="border-collapse:collapse; border:none;">
<caption style="font-weight: bold; text-align:left;">
How worried about climate change (x)
<span style="font-weight: normal; font-style: italic">\<numeric\></span>
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
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not at all worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1580
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4.20
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4.28
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
4.28
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not very worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5367
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
14.27
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
14.52
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
18.80
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Somewhat worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
16206
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
43.09
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
43.85
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
62.65
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Very worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
10620
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
28.24
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
28.74
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
91.38
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Extremely worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3184
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8.47
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8.62
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not applicable
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
7
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
8
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
9
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
654
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
1.74
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
total N=37611 · valid N=36957 · x̄=3.23 · σ=0.95
</td>
</tr>
</table>

In der Tabelle werden Spaltenweise von links nach rechts der numerische
Wert der Wertausprägung, die Bezeichnung der Wertausprägung, die
absolute Häufigkeit (Anzahl der Häufigkeit), die relative Häufigkeit (NA
berücksichtig), die relative Häufigkeit (NA vernachlässigt) und die
kumulierte relative Häufigkeit (NA vernachlässigt) dargestellt.

Unterhalb der Tabelle werden zudem die gesamte Anzahl der befragten
Personen (mit und ohne Berücksichtigung der NA), der Mittelwert und die
Standardabweichung angezeigt.

Wenn wir nun die Werte nach bestimmten Gruppen oder Ländern ausgegeben
benötigen, so können wir uns wieder dem `filter()` Befehl aus *dplyr*
bemächtigen.

``` r
data %>%
  filter(cntry == "GB") %>%
  frq(wrclmch, out = "viewer")
```

<table style="border-collapse:collapse; border:none;">
<caption style="font-weight: bold; text-align:left;">
How worried about climate change (wrclmch)
<span style="font-weight: normal; font-style: italic">\<numeric\></span>
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
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not at all worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
58
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.05
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.08
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
5.08
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not very worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
135
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
11.75
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
11.82
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
16.90
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Somewhat worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
461
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
40.12
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
40.37
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
57.27
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Very worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
346
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
30.11
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
30.30
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
87.57
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Extremely worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
142
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
12.36
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
12.43
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not applicable
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
7
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
8
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
9
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
7
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
0.61
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
total N=1149 · valid N=1142 · x̄=3.33 · σ=1.01
</td>
</tr>
</table>

``` r
#oder

data %>%
  filter(gndr == 2) %>%
  frq(wrclmch, out = "viewer")
```

<table style="border-collapse:collapse; border:none;">
<caption style="font-weight: bold; text-align:left;">
How worried about climate change (wrclmch)
<span style="font-weight: normal; font-style: italic">\<numeric\></span>
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
1
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not at all worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
658
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3.27
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3.32
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
3.32
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
2
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not very worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
2449
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
12.16
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
12.37
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
15.70
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
3
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Somewhat worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
8667
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
43.02
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
43.79
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
59.49
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
4
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Very worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
6127
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
30.41
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
30.96
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
90.45
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
5
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Extremely worried
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
1891
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.39
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
9.55
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: right;">
100.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left;text-align:left; ">
6
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; text-align: left;">
Not applicable
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
7
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
8
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
9
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
356
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center; border-bottom: 1px solid; text-align: right;">
1.77
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
total N=20148 · valid N=19792 · x̄=3.31 · σ=0.92
</td>
</tr>
</table>

### Mittelwert, Standardabweichung und mehr

Nachdem wir uns die Häufigkeiten angeschaut haben, möchten wir uns nun
die weiteren deskriptiven Statistiken anschauen. Dafür verwenden wir den
Befehl `describe()` des *psych*-Paketes

``` r
describe(data$wrclmch, na.rm = T)
```

    ##    vars     n mean   sd median trimmed  mad min max range  skew kurtosis se
    ## X1    1 36957 3.23 0.95      3    3.23 1.48   1   5     4 -0.16    -0.09  0

Wir erhalten von links nach rechts:

vars = Itemnummer  
n = Anzahl gültiger Werte  
mean = Mittelwert  
sd = Standardabweichung  
median = Median  
trimmed = getrimmter Mittelwert (Grenze bei 0.1)  
mad = mittlere absolute Abweichung vom Median  
min = Minimum  
max = Maximum  
skew = Schiefe der Verteilung  
kurtosis = Kurtosis (Wölbung der Verteilung)  
se =Standardfehler der Verteilung

Wenn wir nach Gruppen eine Analyse haben möchten so können wir entweder
mit `select()` oder mit `describeBy()` arbeiten.

``` r
describeBy(data$wrclmch, data$cntry, mat = T, na.rm = T)
```

    ##      item group1 vars    n     mean        sd median  trimmed    mad min max
    ## X11     1     BE    1 1339 3.315907 0.9396479      3 3.315907 1.4826   1   5
    ## X12     2     BG    1 2638 3.114102 0.9299825      3 3.114102 1.4826   1   5
    ## X13     3     CH    1 1511 3.318994 0.8945178      3 3.318994 1.4826   1   5
    ## X14     4     CZ    1 2394 3.153300 1.1175646      3 3.153300 1.4826   1   5
    ## X15     5     EE    1 1536 2.992188 0.9052529      3 2.992188 0.0000   1   5
    ## X16     6     FI    1 1574 3.190597 0.8380725      3 3.190597 1.4826   1   5
    ## X17     7     FR    1 1970 3.276650 0.9165888      3 3.276650 1.4826   1   5
    ## X18     8     GB    1 1142 3.331874 1.0062120      3 3.331874 1.4826   1   5
    ## X19     9     GR    1 2736 3.198099 0.9345355      3 3.198099 1.4826   1   5
    ## X110   10     HR    1 1583 3.402401 1.0239456      3 3.402401 1.4826   1   5
    ## X111   11     HU    1 1826 3.381161 0.7829386      3 3.381161 1.4826   1   5
    ## X112   12     IE    1 1717 3.085614 0.9913421      3 3.085614 1.4826   1   5
    ## X113   13     IS    1  901 3.049945 0.9467796      3 3.049945 1.4826   1   5
    ## X114   14     IT    1 2592 3.241127 0.8956122      3 3.241127 1.4826   1   5
    ## X115   15     LT    1 1603 3.188397 0.9744246      3 3.188397 1.4826   1   5
    ## X116   16     ME    1 1220 3.093443 0.9418479      3 3.093443 0.0000   1   5
    ## X117   17     MK    1 1391 3.312006 1.0088064      3 3.312006 1.4826   1   5
    ## X118   18     NL    1 1464 3.308743 0.9133505      3 3.308743 1.4826   1   5
    ## X119   19     NO    1 1409 3.208659 0.8547388      3 3.208659 1.4826   1   5
    ## X120   20     PT    1 1812 3.539735 0.8505493      4 3.539735 1.4826   1   5
    ## X121   21     SI    1 1249 3.485188 0.8706283      4 3.485188 1.4826   1   5
    ## X122   22     SK    1 1350 2.854815 0.9398294      3 2.854815 1.4826   1   5
    ##      range        skew    kurtosis         se
    ## X11      4 -0.19518004 -0.06447899 0.02567881
    ## X12      4 -0.23640502  0.15086774 0.01810662
    ## X13      4 -0.13621270 -0.14229041 0.02301213
    ## X14      4 -0.07605708 -0.74897966 0.02284076
    ## X15      4 -0.15842265  0.20299048 0.02309800
    ## X16      4 -0.19495285  0.20010127 0.02112415
    ## X17      4  0.03188160 -0.11156930 0.02065102
    ## X18      4 -0.26551587 -0.16924596 0.02977532
    ## X19      4  0.07307025 -0.34913370 0.01786643
    ## X110     4 -0.25684417 -0.18382472 0.02573573
    ## X111     4 -0.21263522  0.38471896 0.01832219
    ## X112     4 -0.12507373 -0.13177620 0.02392425
    ## X113     4 -0.31908176 -0.14122861 0.03154180
    ## X114     4 -0.08846933 -0.07252973 0.01759148
    ## X115     4 -0.26999199 -0.01506920 0.02433781
    ## X116     4 -0.09234495  0.26495113 0.02696503
    ## X117     4 -0.27472607 -0.21777437 0.02704857
    ## X118     4 -0.21650349  0.00246730 0.02387080
    ## X119     4 -0.29631364  0.27667731 0.02277078
    ## X120     4 -0.21013367  0.07076122 0.01998115
    ## X121     4 -0.34405196  0.22875765 0.02463494
    ## X122     4  0.23299729 -0.28046173 0.02557892

Mit dem Befehl
`describe.by(data$wrclmch, data$cntry, mat = T, na.rm = T)` lassen wir
uns alle deskriptiven Statistiken zu jedem Land separat ausgeben. Dabei
geben wir zuerst die Variable an, die berechnet und dann die Variable,
nach der gruppiert werden soll. Mit `mat = T` geben wir an, dass wir das
Ergebnis in einer tabellarischen Form ausgegeben haben wollen.

``` r
data %>%
  filter(cntry %in% c("GB", "BE", "IT")) %>%
  group_by(cntry) %>%
  summarise(describe(wrclmch, na.rm = T))
```

    ## # A tibble: 3 × 14
    ##   cntry            vars     n  mean    sd median trimmed   mad   min   max range
    ##   <chr+lbl>       <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1 BE [Belgium]        1  1339  3.32 0.940      3    3.32  1.48     1     5     4
    ## 2 GB [United Kin…     1  1142  3.33 1.01       3    3.33  1.48     1     5     4
    ## 3 IT [Italy]          1  2592  3.24 0.896      3    3.24  1.48     1     5     4
    ## # ℹ 3 more variables: skew <dbl>, kurtosis <dbl>, se <dbl>

### Alternative Einzelberechnungen

Wollen wir die deskriptiven Statistiken einzeln Berechnen, so können wir
folgende Befehle verwenden:

**Anzahl**

``` r
data %>% ungroup() %>% summarize(length(wrclmch))
```

    ## # A tibble: 1 × 1
    ##   `length(wrclmch)`
    ##               <int>
    ## 1             37611

**Mittelwert**

``` r
data %>% ungroup() %>% summarize(mean(wrclmch, na.rm = T))
```

    ## # A tibble: 1 × 1
    ##   `mean(wrclmch, na.rm = T)`
    ##                        <dbl>
    ## 1                       3.23

**Standardabweichung**

``` r
data %>% ungroup() %>% summarize(sd(wrclmch, na.rm = T))
```

    ## # A tibble: 1 × 1
    ##   `sd(wrclmch, na.rm = T)`
    ##                      <dbl>
    ## 1                    0.946

**Varianz**

``` r
data %>% ungroup() %>% summarize(var(wrclmch, na.rm = T))
```

    ## # A tibble: 1 × 1
    ##   `var(wrclmch, na.rm = T)`
    ##                       <dbl>
    ## 1                     0.896

**Median**

``` r
data %>% ungroup() %>% summarize(median(wrclmch, na.rm = T))
```

    ## # A tibble: 1 × 1
    ##   `median(wrclmch, na.rm = T)`
    ##                          <dbl>
    ## 1                            3

**Häufigkeitstabelle**

``` r
data %>% select(wrclmch) %>% table(., useNA = "ifany")
```

    ## wrclmch
    ##     1     2     3     4     5  <NA> 
    ##  1580  5367 16206 10620  3184   654

**Quantile und Percentile**

``` r
data %>% ungroup() %>% summarize(quantile(wrclmch,probs = seq(0.25, 1, 0.25), na.rm = T)) #Beginn bei 25%
```

    ## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
    ## dplyr 1.1.0.
    ## ℹ Please use `reframe()` instead.
    ## ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()`
    ##   always returns an ungrouped data frame and adjust accordingly.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

    ## # A tibble: 4 × 1
    ##   `quantile(wrclmch, probs = seq(0.25, 1, 0.25), na.rm = T)`
    ##                                                        <dbl>
    ## 1                                                          3
    ## 2                                                          3
    ## 3                                                          4
    ## 4                                                          5

``` r
data %>% ungroup() %>% summarize(quantile(wrclmch,probs = seq(0.1, 1, 0.1), na.rm = T)) #Beginn bei 10%
```

    ## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
    ## dplyr 1.1.0.
    ## ℹ Please use `reframe()` instead.
    ## ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()`
    ##   always returns an ungrouped data frame and adjust accordingly.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

    ## # A tibble: 10 × 1
    ##    `quantile(wrclmch, probs = seq(0.1, 1, 0.1), na.rm = T)`
    ##                                                       <dbl>
    ##  1                                                        2
    ##  2                                                        3
    ##  3                                                        3
    ##  4                                                        3
    ##  5                                                        3
    ##  6                                                        3
    ##  7                                                        4
    ##  8                                                        4
    ##  9                                                        4
    ## 10                                                        5

Min, Max und Range

``` r
data %>% ungroup() %>% summarize(min(wrclmch, na.rm = T))
```

    ## # A tibble: 1 × 1
    ##   `min(wrclmch, na.rm = T)`
    ##   <dbl+lbl>                
    ## 1 1 [Not at all worried]

``` r
data %>% ungroup() %>% summarize(max(wrclmch, na.rm = T))
```

    ## # A tibble: 1 × 1
    ##   `max(wrclmch, na.rm = T)`
    ##   <dbl+lbl>                
    ## 1 5 [Extremely worried]

``` r
data %>% ungroup() %>% summarize(range(wrclmch, na.rm = T))
```

    ## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in
    ## dplyr 1.1.0.
    ## ℹ Please use `reframe()` instead.
    ## ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()`
    ##   always returns an ungrouped data frame and adjust accordingly.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

    ## # A tibble: 2 × 1
    ##   `range(wrclmch, na.rm = T)`
    ##   <dbl+lbl>                  
    ## 1 1 [Not at all worried]     
    ## 2 5 [Extremely worried]
