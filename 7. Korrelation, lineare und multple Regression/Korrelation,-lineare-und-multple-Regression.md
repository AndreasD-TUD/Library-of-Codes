Korrelation, lineare und multiple Regression
================
Andreas Deim
11 Februar, 2025

- [Verwendete neue Befehle](#verwendete-neue-befehle)
- [Pakete installieren](#pakete-installieren)
- [Pakete Laden](#pakete-laden)
- [Kovarianz](#kovarianz)
- [Scatterplot (Punktwolke)](#scatterplot-punktwolke)
- [Korrelation](#korrelation)
  - [1. Pearson-Kovarianz (Lineare
    Korrelation)](#1-pearson-kovarianz-lineare-korrelation)
  - [2. Kendall’s Tau
    (Rangkorrelation)](#2-kendalls-tau-rangkorrelation)
  - [3. Spearman’s Rho
    (Rangkorrelation)](#3-spearmans-rho-rangkorrelation)
  - [Zusammenfassung der
    Unterschiede](#zusammenfassung-der-unterschiede)
- [Lineare Regression](#lineare-regression)
  - [Interpretation](#interpretation)
- [Multiple Lineare Regression](#multiple-lineare-regression)
  - [Polung der Variablen
    (Wiederholung)](#polung-der-variablen-wiederholung)
  - [Zentrierung der Variable](#zentrierung-der-variable)
  - [Multiple Regression](#multiple-regression)
  - [Interaktionseffekt](#interaktionseffekt)
  - [Überprüfung der Vorraussetzung](#überprüfung-der-vorraussetzung)

# Verwendete neue Befehle

------------------------------------------------------------------------

`cov()` = Kovarianz berechnen  
`plot()` = Punktewolke, QQPlot, … generieren. Abhängig von Input  
`cor()` = Korrelation berechnen  
`lm()` = lineares Regressionsmodel erstellen  
`sumary()` = Regressionsmodel zusammenfassen  
`lm.beta()` = Beta-Koeffizienten eines Modells berechnen (lm.beta)  
`scale()` = Variable standardisieren und/oder zentrieren  
`ggPredict()` = Regressionsmodell ploten (predict3d)  
`vif()` = VIF berechnen (car)  
`raintest()` = Rainbowtest durchführen (lmtest)

------------------------------------------------------------------------

# Pakete installieren

``` r
install.packages("predict3d")
install.packages("labelled")
install.packages("lmtest")
install.packages("lm.beta")
```

# Pakete Laden

``` r
library(haven) 
library(ggplot2)
library(dplyr)
library(lm.beta)
library(predict3d)
library(car)
library(labelled)
library(lmtest)
library(sjmisc)
library(sjPlot)
```

Datensatz einlesen (Wenn nötig)

``` r
data <- read_sav("ESS10_HV.sav") 
```

# Kovarianz

Die **Kovarianz** ist ein Maß, das beschreibt, wie zwei Variablen
zusammenhängen. Sie zeigt, ob und wie stark die Abweichungen einer
Variable von ihrem Mittelwert mit den Abweichungen einer anderen
Variable von ihrem Mittelwert korrelieren.

**Definition  
**Die Kovarianz wird berechnet als der Durchschnitt der Produkte der
Abweichungen zweier Variablen von ihren Mittelwerten. Mathematisch
ausgedrückt:

$$
\text{Cov}(X, Y) = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{n}
$$

- $X$, $Y$: Zwei Variablen  
- $x_i$, $y_i$: Werte der Variablen  
- $\bar{x}$, $\bar{y}$: Mittelwerte der Variablen  
- $n$: Anzahl der Datenpunkte

**Interpretation**

- **Positive Kovarianz**: Wenn eine Variable steigt, steigt die andere
  auch (direkter Zusammenhang).

- **Negative Kovarianz**: Wenn eine Variable steigt, sinkt die andere
  (inverser Zusammenhang).

- **Nahe null**: Es besteht kein linearer Zusammenhang zwischen den
  Variablen.

**Beachte**

Die Kovarianz ist **unskaliert**, d.h., ihre Werte hängen von den
Einheiten der Variablen ab. Damit zeigt sie nur die Richtung der
Beziehung, aber nicht deren Stärke.

Im folgenden ein Beispiel zur Berechnung der Kovarianz mit dem Befehl
`cov()`:

``` r
data %>%
  filter(cntry == "GB") %>%
  select(hv_power, lrscale) %>%
  cov(., use = "pairwise.complete.obs")
```

    ##           hv_power  lrscale
    ## hv_power 0.7092728 0.092914
    ## lrscale  0.0929140 4.685491

``` r
data %>%
  filter(cntry == "SI") %>%
  select(hv_power, lrscale, trstprl, psppsgva, freehms) %>%
  cov(., use = "pairwise.complete.obs")
```

    ##            hv_power   lrscale     trstprl   psppsgva     freehms
    ## hv_power 0.64266668 0.1151610  0.05712796 0.02221182  0.07164236
    ## lrscale  0.11516103 5.8364699  1.30680873 0.37713324  0.62091966
    ## trstprl  0.05712796 1.3068087  5.86919001 0.80017819 -0.04917830
    ## psppsgva 0.02221182 0.3771332  0.80017819 0.66279979  0.03908154
    ## freehms  0.07164236 0.6209197 -0.04917830 0.03908154  1.03440438

Für die Berechnung der Kovarianz können wir fast vollständig auf die
bekannte Struktur mit *dplyr* zurückgreifen. Dabei haben wir die
Möglichkeit mehrere Variablen gleichzeitig zu betrachten, allerdings
immer nur für ein Land.

Mit der Option `cov(..., use = "pairwise.complete.obs")` geben wir an,
dass wir nur Paare in die Berechnung einbeziehen wollen, in denen kein
`NA` vorkommt. Alternativ können wir an der Stelle `"everythink"`,
`"all.obs"`, `"complete.obs"` oder `"na.or.complete"`.

Im Ergebnis erhalten wir eine an der Diagonale gespiegelte Matrix. Dabei
reicht es aus wenn wir die obere rechte Hälfte oder untere linke Hälfte
betrachten. Auf der Diagonale wurde die Kovarianz der Variable mit sich
selbst berechnet. Aus dem Ergebnis können wir beispielsweise sehen, dass
`hv_power` und `lrscale` negativ in Großbritanien zusammenhängen. Das
bedeutet, dass bei einem geringeren `lrscale`-Wert (links) ein höherer
`hv_power`-Wert erwartet wird.

# Scatterplot (Punktwolke)

Um sich einen ersten Eindruck über die Beziehung zweier Variablen zu
verschaffen, kann es helfen sich diese Beziehung grafisch ausgeben zu
lassen.

``` r
data %>%
  filter(cntry == "GB") %>%
  select(lrscale, freehms) %>%
  plot()
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
data %>%
  filter(cntry == "GB") %>%
  select(lrscale, hv_power) %>%
  plot()
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

``` r
data %>%
  filter(cntry == "GB") %>%
  select(hv_power, hv_univ) %>%
  plot()
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-5-3.png)<!-- -->

Wie wir sehen, können wir zwischen den Werten `hv_power` und `hv_univ`
andeutungsweise einen negativen Zusammenhang vermuten. Zwischen den
Variablen `hv_power` und `lrscale`, sowie zwischen `lrscale` und
`freehms` ist dies schon schwieriger zu beurteilen. Um auch diese für
diskrete Variablen interpretierbar zu machen müssen wir die Grafik
anpassen.

Im folgenden werden verschiedene Möglichkeiten gezeigt:

``` r
data %>%
  filter(cntry == "GB") %>%
  filter(!is.na(lrscale) & !is.na(freehms)) %>%
  select(lrscale, freehms) %>%
  plot(, cex=log(xyTable(.)$number))
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
data %>%
  filter(cntry == "GB") %>%
  filter(!is.na(lrscale) & !is.na(freehms)) %>%
  ggplot(., aes(x=as.factor(lrscale), y=freehms)) + 
  geom_boxplot()
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

``` r
data %>%
  filter(cntry %in% c("GB", "BG", "CZ", "SI", "HU", "FR")) %>%
  filter(!is.na(lrscale) & !is.na(freehms)) %>%
  ggplot(., aes(x=as.factor(lrscale), y=freehms, fill=cntry)) + 
  geom_boxplot() +
  facet_wrap(~cntry)
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-6-3.png)<!-- -->

``` r
data %>%
  filter(cntry %in% c("BG")) %>%
  filter(!is.na(lrscale) & !is.na(freehms)) %>%
  ggplot(., aes(x=as.factor(lrscale), y=freehms, fill = cntry)) + 
  geom_violin()
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-6-4.png)<!-- -->

# Korrelation

Da die Kovarianz allein schwer interpretierbar ist, da unskaliert. Um
sie zu normieren, wird die **Korrelation** verwendet, die als
dimensionslose Version der Kovarianz gilt:

## 1. Pearson-Kovarianz (Lineare Korrelation)

- **Definition**: Misst den Grad des **linearen Zusammenhangs** zwischen
  zwei Variablen.

- **Mathematische Grundlage**:

- Berechnet die Kovarianz der Variablen, normiert durch deren
  Standardabweichungen.

$$r = \frac{\text{Cov}(X, Y)}{\sigma_X \cdot \sigma_Y}$$

Dabei sind:

$\sigma_X$: Standardabweichung von (X)  
$\sigma_Y$: Standardabweichung von (Y)

- **Voraussetzungen**:

  - Die Beziehung zwischen den Variablen muss linear sein.

  - Die Daten sollten metrisch und normalverteilt sein.

- **Empfindlichkeit**:

  - Stark empfindlich gegenüber Ausreißern, da diese den Mittelwert und
    die Standardabweichung beeinflussen.

``` r
data %>%
  filter(cntry == "GB") %>%
  select(hv_power, hv_univ, lrscale, freehms) %>%
  cor(., use = "pairwise.complete.obs", method = "pearson")
```

    ##             hv_power    hv_univ     lrscale     freehms
    ## hv_power  1.00000000 -0.3991957  0.05147274  0.08623522
    ## hv_univ  -0.39919575  1.0000000 -0.21555028 -0.25053583
    ## lrscale   0.05147274 -0.2155503  1.00000000  0.24398150
    ## freehms   0.08623522 -0.2505358  0.24398150  1.00000000

## 2. Kendall’s Tau (Rangkorrelation)

- **Definition**: Misst die **monotone Beziehung** zwischen zwei
  Variablen anhand von Rangpaaren

  - Monoton = das Vorliegen einer “je mehr desto mehr”- bzw. einer “je
    mehr desto weniger”- Beziehung

- **Mathematische Grundlage**:

  - Betrachtet Paare von Beobachtungen $(x_i, y_i)$ und $(x_j, y_j)$:

    - **Konkordante Paare**: Wenn $x_i$ \> $x_j$ und $y_i$ \> $y_j$
      (oder $x_i$ \< $x_j$ und $y_i$ \< $y_j$).

    - **Diskordante Paare**: Wenn $x_i$ \> $x_j$ und $y_i$ \< $y_j$
      (oder umgekehrt).

$$τ = \frac{\text{Anzahl konkordanter Paare} - \text{Anzahl diskordanter Paare}}{\binom{n}{2}}$$

- **Voraussetzungen**:

  - Keine spezifischen Annahmen über Verteilung oder Linearität.

- **Empfindlichkeit**:

  - Robuster gegenüber Ausreißern und nichtlinearer Datenstruktur als
    Pearson.

  - Besser für kleinere Datensätze geeignet.

``` r
data %>%
  filter(cntry == "SI") %>%
  select(hv_power, hv_univ, lrscale, freehms) %>%
  cor(., use = "pairwise.complete.obs", method = "kendall")
```

    ##             hv_power    hv_univ     lrscale     freehms
    ## hv_power  1.00000000 -0.2589370  0.03532442  0.07541225
    ## hv_univ  -0.25893705  1.0000000 -0.10477230 -0.11537305
    ## lrscale   0.03532442 -0.1047723  1.00000000  0.21779045
    ## freehms   0.07541225 -0.1153730  0.21779045  1.00000000

## 3. Spearman’s Rho (Rangkorrelation)

- **Definition**: Misst die Stärke und Richtung eines **monotonen
  Zusammenhangs** durch Ränge.

- **Mathematische Grundlage**:

  - Zunächst werden die Daten in Ränge umgewandelt.

  - Pearson-Korrelation wird auf der Basis Rangdaten berechnet:

  $$r_s = 1 - \frac{6 \sum (R_i-S_i)^2}{n(n^2 - 1)}$$

  (Vereinfachte Formel unter der Annahme weniger Bedingungen)

  - $R_i$: Rang von $x_i$.

  - $S_i$: Rang on $y_i$

  - $n$: Anzahl der Beobachtungen.

- **Voraussetzungen**:

  - Keine Normalverteilung erforderlich.

  - Misst monotone, nicht unbedingt lineare Beziehungen.

- **Empfindlichkeit**:

  - Weniger anfällig für Ausreißer als Pearson.

  - Kann monotone, aber nicht-lineare Zusammenhänge besser erkennen als
    Pearson.

``` r
data %>%
  filter(cntry == "SI") %>%
  select(hv_power, hv_univ, lrscale, freehms, eisced) %>%
  cor(., use = "pairwise.complete.obs", method = "spearman")
```

    ##             hv_power     hv_univ     lrscale     freehms      eisced
    ## hv_power  1.00000000 -0.37882642  0.04759819  0.09694861 -0.07549582
    ## hv_univ  -0.37882642  1.00000000 -0.14112056 -0.15024860  0.07029439
    ## lrscale   0.04759819 -0.14112056  1.00000000  0.25977646 -0.17390240
    ## freehms   0.09694861 -0.15024860  0.25977646  1.00000000 -0.25074748
    ## eisced   -0.07549582  0.07029439 -0.17390240 -0.25074748  1.00000000

## Zusammenfassung der Unterschiede

| Merkmal | **Pearson** | **Kendall** | **Spearman** |
|----|----|----|----|
| **Typ der Beziehung** | Linear | Monoton | Monoton |
| **Datenanforderung** | Metrisch, normalverteilt | Beliebige Verteilung, ordinal/metrisch | Beliebige Verteilung, ordinal/metrisch |
| **Empfindlichkeit** | Empfindlich gegenüber Ausreißern | Robust gegenüber Ausreißern | Weniger empfindlich als Pearson |
| **Skalierung** | Rohdaten | Ränge | Ränge |
| **Geeignet für** | Lineare Beziehungen | Kleine Datensätze, monotone Trends | Monotone Trends, große Datensätze |

Jeder Koeffizient hat seinen spezifischen Anwendungsbereich, je nach
Struktur und Eigenschaften der Daten.

# Lineare Regression

Um eine lineare Regression durchzuführen und die Ergebnisse
interpretieren zu können, müssen wir uns zu Beginn ein lineares Model
mit dem Befehl `lm()` entwickeln. Dies erfolgt mit einer ganz bestimmten
Schreibweise, welche unter `?formula` genauer betrachtet werden kann.

Zu Beginn definieren wir dabei erstmal wer von wem abhängt. Dies erfolgt
mit dem `~`-Zeichen. Zuerst wird die abhängige Variable und dann die
unabhängige(n) Variable(n) definiert. Im folgenden Beispiel mit
`hv_power ~ hv_univ`.  
Mit dem `summary`-Befehl lassen wir uns die Modelergebnisse ausgeben.

Mit der Option `lm(..., weights = ...)` setzen wir wieder den
Gewichtungsfaktor, der bei der Analyse berücksichtigt werden soll.

Abschließend lassen wir uns noch die standardisierten Beta-Koeffizienten
mit dem Befehl `lm.beta()` des gleichnamigen *lm.beta*-Paketes ausgeben
ausgeben, mit welchen wir die Skaleneffekte reduzieren. Die
Skaleneffekte beschreiben die unterschiedliche Ausprägung eines Items,
bedingt durch unterschiedlich viele Antwortmöglichkeiten und ebenso
verschiedener Verteilungsfunktionen der Variablen. Mit dem
Beta-Koeffizienten können wir die Regressionsparameter miteinander
vergleichen.

``` r
model <- data %>%
  filter(cntry == "GB") %>%
  lm(hv_power ~ hv_univ, data= ., weights = anweight)

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ hv_univ, data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.9403 -1.0457 -0.1261  0.9027  7.9245 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -0.77617    0.03520  -22.05   <2e-16 ***
    ## hv_univ     -0.52448    0.03334  -15.73   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.663 on 1138 degrees of freedom
    ##   (9 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.1786, Adjusted R-squared:  0.1779 
    ## F-statistic: 247.5 on 1 and 1138 DF,  p-value: < 2.2e-16

``` r
lm.beta(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ hv_univ, data = ., weights = anweight)
    ## 
    ## Standardized Coefficients::
    ## (Intercept)     hv_univ 
    ##          NA  -0.4226345

## Interpretation

### 1. Call

`Call: lm(formula = hv_power ~ hv_univ, data = ., weights = anweight)`

- Zeigt die Formel, die für das Modell verwendet wurde:

  - **`hv_power ~ hv_univ`**: `hv_power` ist die abhängige Variable,
    `hv_univ` ist die unabhängige Variable.

  - **`weights = anweight`**: Das Modell wurde mit Gewichtungen
    (`anweight`) angepasst, wodurch einige Datenpunkte mehr Gewicht
    erhalten.

### 2. Gewichtete Residuen

`Weighted Residuals:`

- Beschreibt die Verteilung der **gewichteten Residuen**:

  - Residuen sind die Differenzen zwischen den tatsächlichen Werten der
    abhängigen Variable (`hv_power`) und den vorhergesagten Werten des
    Modells.

  - Die Statistik zeigt:

    - **Min**: Kleinster Residualwert (-7.9245).

    - **1Q, Median, 3Q**: Quartile der Residuen.

    - **Max**: Größter Residualwert (6.9403).

  - Eine symmetrische Verteilung der Residuen um 0 deutet auf eine gute
    Modellanpassung hin.

### 3. Koeffizenten

`Coefficients:`

- **Schätzungen der Modellparameter (`Estimate`):**

  - **(Intercept)**: Die geschätzte Konstante (an der die y-Achse
    geschnitten wird, wenn `hv_univ` = 0) ist 0.77617.

  - **`hv_univ`**: Der geschätzte Koeffizient ist −0.52448, was
    bedeutet, dass mit jeder Einheitserhöhung in `hv_univ` die abhängige
    Variable (`hv_power`) um 0.52448 Einheiten abnimmt (negativer
    Zusammenhang).

- **Standardfehler (`Std. Error`):**

  - Zeigt die Unsicherheit in den geschätzten Parametern.

  - **(Intercept)**: Standardfehler beträgt 0.03520.

  - **`hv_univ`**: Standardfehler beträgt 0.03334.

- **t-Wert:**

  - Gibt an, wie stark sich der geschätzte Koeffizient vom Nullwert
    (kein Effekt) unterscheidet.

  - Berechnet als: $t = \frac{\text{Estimate}}{\text{Std. Error}}$​

    - **(Intercept)**: $t = 22.05$.

    - **`hv_univ`**: $t=−15.73$.

- **p-Wert (`Pr(>|t|)`):**

  - Gibt die Wahrscheinlichkeit an, den beobachteten t-Wert (oder
    extremer) unter der Annahme zu erhalten, dass der wahre Koeffizient
    Null ist.

  - **`<2e-16`**: Sehr kleiner p-Wert (fast 0), daher ist der Effekt
    statistisch signifikant.

  - **Signifikanzcodes (`***`)**: Zeigen die Stärke der statistischen
    Signifikanz:

    - `***`: p \< 0.001 (sehr signifikant).

### **4. Residual standard error**

`Residual standard error: 1.663 on 1138 degrees of freedom   (9 Beobachtungen als fehlend gelöscht)`

- Beschreibt die Streuung der Residuen:

  - **1.663**: Die durchschnittliche Abweichung der tatsächlichen Werte
    von den vorhergesagten Werten.

  - **1138 degrees of freedom**: Freiheitsgrade des Modells, berechnet
    als: $Freiheitsgrade=n−p$

    - $n=1149$ (Gesamtanzahl der Beobachtungen).

    - $p=2$ (Anzahl der geschätzten Parameter: Achsenabschnitt + 1
      Koeffizient).

    - 9 Beobachtungen wurden wegen fehlender Werte ausgeschlossen.

### **5. Multiple R-squared und Adjusted R-squared**

`Multiple R-squared:  0.1786, Adjusted R-squared:  0.1779`

- **Multiple R-squared**:

  - Misst den Anteil der Varianz in der abhängigen Variable, der durch
    das Modell erklärt wird.

  - 17,86% der Varianz in `hv_power` werden durch `hv_univ` erklärt.

- **Adjusted R-squared**:

  - Berücksichtigt die Anzahl der Variablen im Modell und die
    Freiheitsgrade.

  - **0.1779**: Minimal kleiner als das R-squared, was auf eine geringe
    Modellkomplexität hinweist.

### **6. F-Statistic**

`F-statistic: 247.5 on 1 and 1138 DF,  p-value: < 2.2e-16`

- **F-Statistik**:

  - Testet, ob das Modell insgesamt signifikant besser ist als ein
    Modell ohne Prädiktoren.

  - Berechnet als:
    $F = \frac{\text{Regression Mean Square}}{\text{Residual Mean Square}}$

  - **247.5**: Ein hoher F-Wert zeigt, dass das Modell signifikant ist.

- **p-Wert (`<2.2e-16`)**:

  - Der p-Wert für den F-Test ist nahezu 0, was bedeutet, dass das
    Modell signifikant ist.

### 7. Standardisierte Koefizienten

`Standardized Coefficients::`

- **hv_univ**: −0.4226345.

  - Nach Standardisierung zeigt der Koeffizient die Stärke und Richtung
    des Effekts von **hv_univ** auf **hv_power**, unabhängig von deren
    Messskalen.

  - Interpretation: Ein Standardabweichungsanstieg in **hv_univ** führt
    zu einem Rückgang von 0.4226345 Standardabweichungen in
    **hv_power**.

# Multiple Lineare Regression

## Polung der Variablen (Wiederholung)

Um die Ergebnisse der multiplen linearen Regression besser und leichter
interpretieren zu können, kann es hilfreich sein, wenn alle unabhängigen
Variablen dieselbe Polung besitzen. Dies erfolgt mit dem Befehl
`recode()` . In diesem Befehl geben wir zuerst die Variable an, die
umkodiert werden soll und dann die Werte, sowie die neu zugeordneten
Werte , welche ersetzt werden sollen. Zum Beispiel `'1' = 5`. Dabei wird
der zuersetzende Wert zuerst angegeben, hier noch mit dem Zusatz `''`.

Um die Variable in unseren Datensatz einzuspeichern verwenden wir den
Befehl `mutate()`.

``` r
frq(data$freehms)
```

    ## Gays and lesbians free to live life as they wish (x) <numeric> 
    ## # total N=37611 valid N=36726 mean=2.19 sd=1.20
    ## 
    ## Value |                      Label |     N | Raw % | Valid % | Cum. %
    ## ---------------------------------------------------------------------
    ##     1 |             Agree strongly | 12649 | 33.63 |   34.44 |  34.44
    ##     2 |                      Agree | 12655 | 33.65 |   34.46 |  68.90
    ##     3 | Neither agree nor disagree |  5799 | 15.42 |   15.79 |  84.69
    ##     4 |                   Disagree |  2990 |  7.95 |    8.14 |  92.83
    ##     5 |          Disagree strongly |  2633 |  7.00 |    7.17 | 100.00
    ##     7 |                    Refusal |     0 |  0.00 |    0.00 | 100.00
    ##     8 |                 Don't know |     0 |  0.00 |    0.00 | 100.00
    ##     9 |                  No answer |     0 |  0.00 |    0.00 | 100.00
    ##  <NA> |                       <NA> |   885 |  2.35 |    <NA> |   <NA>

``` r
data <- data %>%
  mutate(freehms = dplyr::recode(freehms, '1' = 5, '2' = 4, '3' = 3, '4' = 2, '5' = 1)) %>%
  set_value_labels(freehms = c("Agree strongly" = 5, 
                               "Agree" = 4, 
                               "Neither agree nor disagree" = 3, 
                               "Disagree"= 2, 
                               "Disagree strongly" = 1))
frq(data$freehms)
```

    ## Gays and lesbians free to live life as they wish (x) <numeric> 
    ## # total N=37611 valid N=36726 mean=3.81 sd=1.20
    ## 
    ## Value |                      Label |     N | Raw % | Valid % | Cum. %
    ## ---------------------------------------------------------------------
    ##     1 |          Disagree strongly |  2633 |  7.00 |    7.17 |   7.17
    ##     2 |                   Disagree |  2990 |  7.95 |    8.14 |  15.31
    ##     3 | Neither agree nor disagree |  5799 | 15.42 |   15.79 |  31.10
    ##     4 |                      Agree | 12655 | 33.65 |   34.46 |  65.56
    ##     5 |             Agree strongly | 12649 | 33.63 |   34.44 | 100.00
    ##  <NA> |                       <NA> |   885 |  2.35 |    <NA> |   <NA>

## Zentrierung der Variable

Sollen bei einer multiplen Regression auch Interaktionseffekte
berücksichtigt werden, so bietet es sich an die unabhängigen Variablen
auf ihren Mittelwert zu zentrieren, um einer multikoliniearität
vorzubeugen, welche mit der Hinzunahme eben jener Interaktionseffekte
steigt.  
Dies ist relativ leicht mit dem Befehl `scale()` möglich. Dieser Befehl
ermöglicht die Zentrierung und Standardisierung der Varianz. Da wir die
Variabeln nur zentrieren wollen, ergänzen wir in `scale()` noch die
Option `scale(..., scale = FALSE)`.

``` r
data <- data %>%
  mutate(freehms = scale(freehms, scale = FALSE))
```

## Multiple Regression

Die Multiple lineare Regression funktioniert analog zu der einfachen
linearen Regression. Im Unterschied zu vorher geben wir weiter
unabhängige Variablen mit dem `+`-Zeichen an.

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  lm(hv_power ~ hv_univ + lrscale + freehms + pplfair, data= ., weights = anweight)  

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ hv_univ + lrscale + freehms + pplfair, 
    ##     data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.3838 -1.0388 -0.1047  0.9306  7.7719 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -0.845860   0.102675  -8.238  5.1e-16 ***
    ## hv_univ     -0.546717   0.036041 -15.169  < 2e-16 ***
    ## lrscale     -0.009444   0.011393  -0.829   0.4074    
    ## freehms      0.084945   0.033826   2.511   0.0122 *  
    ## pplfair      0.012582   0.012101   1.040   0.2987    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.653 on 1063 degrees of freedom
    ##   (81 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.1819, Adjusted R-squared:  0.1789 
    ## F-statistic:  59.1 on 4 and 1063 DF,  p-value: < 2.2e-16

``` r
lm.beta(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ hv_univ + lrscale + freehms + pplfair, 
    ##     data = ., weights = anweight)
    ## 
    ## Standardized Coefficients::
    ## (Intercept)     hv_univ     lrscale     freehms     pplfair 
    ##          NA -0.44436717 -0.02426105  0.07333814  0.02898807

``` r
model <- data %>%   
  filter(cntry %in% c("GB","BG", "IT")) %>%
  lm(hv_power ~ hv_univ + lrscale + freehms + pplfair + cntry, data= ., weights = anweight)  

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ hv_univ + lrscale + freehms + pplfair + 
    ##     cntry, data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -7.1954 -0.3557  0.0148  0.3668  7.9261 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -0.472287   0.056572  -8.348  < 2e-16 ***
    ## hv_univ     -0.577128   0.017093 -33.763  < 2e-16 ***
    ## lrscale     -0.007904   0.004638  -1.704   0.0884 .  
    ## freehms     -0.021413   0.012305  -1.740   0.0819 .  
    ## pplfair      0.006879   0.005152   1.335   0.1819    
    ## cntryGB     -0.247266   0.049373  -5.008 5.67e-07 ***
    ## cntryIT      0.199867   0.047665   4.193 2.80e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.9742 on 5285 degrees of freedom
    ##   (1215 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.3138, Adjusted R-squared:  0.313 
    ## F-statistic: 402.7 on 6 and 5285 DF,  p-value: < 2.2e-16

``` r
lm.beta(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ hv_univ + lrscale + freehms + pplfair + 
    ##     cntry, data = ., weights = anweight)
    ## 
    ## Standardized Coefficients::
    ## (Intercept)     hv_univ     lrscale     freehms     pplfair     cntryGB 
    ##          NA -0.42810637 -0.02015009 -0.02230466  0.01584615 -0.13949779 
    ##     cntryIT 
    ##  0.11096263

``` r
data %>%
  filter(cntry == "GB") %>%
  filter(eisced != 55) %>%
  select(trstsci, ppltrst, eisced) %>%
  cor(., use = "pairwise.complete.obs", method = "pearson")
```

    ##           trstsci   ppltrst    eisced
    ## trstsci 1.0000000 0.2488569 0.1769604
    ## ppltrst 0.2488569 1.0000000 0.2227382
    ## eisced  0.1769604 0.2227382 1.0000000

Im Ergebnis sehen wir kaum eine Verbesserung unseres Modelles im
Vergleich zu der vorherigen Regression (siehe adjusted-R²). Dies liegt
daran, dass die unabhängigen Variablen, die noch angefügt wurden, kaum
zu der Beeinflussung von `hv_power` beitragen. Zu sehen ist das auch an
den jeweiligen Signifikanzstatistiken. So besitzt lediglich `freehms`
als neue Variable eine Verbindung zu der abhängigen Variable.

Bei der multiplen Regression sollte immer abgeschätzt werden, ob es aus
theoretischer Sicht Sinn macht eine unabhängige Variable mit
einzubeziehen. Nach dem Einbezug sollte zudem die Modellgüte
(adjusted-R²) hinterfragt werden. Mit diesen Werten können im weiteren
die ersten Hypothesen überprüft werden.

## Interaktionseffekt

Der Interaktionseffekt beschreibt inwieweit mehrere unabhängige
Variablen zusammengenommen auf die abhängige Variable wirken. Bisher
betrachteten wir in der multiplen Regression immer folgende Formel:

$$
Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p + \epsilon
$$

$\beta$ = Einfluss einer unabhängigen Variable  
$X$ = unabhängige Variable  
$\epsilon$ = Fehler, nicht erklärbarer Einfluss

Wollen wir nun eine Interaktion zwischen zwei unabhängigen Variablen
betrachten, so ändert sich die Formel zu:

$$
Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \beta_3 (X_1*X_2) + \cdots + \beta_p X_p + \epsilon
$$

$\beta_3 (X_1*X_2)$ = Interaktionsterm

Der Interkationsterm ergibt sich einfach aus der Multiplikation zwischen
$X_1$ und $X_2$

Um einen Interaktioneffekt zu berücksichtigen verwenden wir das
Multiplaktionzeichen `*` wenn wir das Model generieren. Ob man einen
Interaktionseffekt in das eigene Model einbaut oder nicht sollte
zunächst aus theoretischen Überlegungen erfolgen.

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  lm(hv_power ~ lrscale * freehms, data= ., weights = anweight)  

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ lrscale * freehms, data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.1414 -1.1828 -0.0998  0.9451  8.4582 
    ## 
    ## Coefficients:
    ##                 Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)     -1.38514    0.10335 -13.403   <2e-16 ***
    ## lrscale          0.03578    0.01745   2.051   0.0405 *  
    ## freehms          0.06511    0.09621   0.677   0.4987    
    ## lrscale:freehms -0.01419    0.01673  -0.848   0.3964    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.822 on 1065 degrees of freedom
    ##   (80 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.005259,   Adjusted R-squared:  0.002457 
    ## F-statistic: 1.877 on 3 and 1065 DF,  p-value: 0.1317

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  lm(hv_power ~ lrscale * freehms, data= ., weights = anweight)  

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = hv_power ~ lrscale * freehms, data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.1414 -1.1828 -0.0998  0.9451  8.4582 
    ## 
    ## Coefficients:
    ##                 Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)     -1.38514    0.10335 -13.403   <2e-16 ***
    ## lrscale          0.03578    0.01745   2.051   0.0405 *  
    ## freehms          0.06511    0.09621   0.677   0.4987    
    ## lrscale:freehms -0.01419    0.01673  -0.848   0.3964    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.822 on 1065 degrees of freedom
    ##   (80 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.005259,   Adjusted R-squared:  0.002457 
    ## F-statistic: 1.877 on 3 and 1065 DF,  p-value: 0.1317

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  filter(eisced != 55) %>%
  lm(trstsci ~ ppltrst + eisced, data= ., weights = anweight)  

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = trstsci ~ ppltrst + eisced, data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -26.5664  -2.0190   0.5446   2.5620  15.9466 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  5.46214    0.19627  27.830  < 2e-16 ***
    ## ppltrst      0.23196    0.02955   7.849 9.87e-15 ***
    ## eisced       0.13962    0.02986   4.676 3.28e-06 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.382 on 1107 degrees of freedom
    ##   (11 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.08524,    Adjusted R-squared:  0.08359 
    ## F-statistic: 51.58 on 2 and 1107 DF,  p-value: < 2.2e-16

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  filter(eisced != 55) %>%
  lm(trstsci ~ ppltrst * eisced, data= ., weights = anweight)  

summary(model)
```

    ## 
    ## Call:
    ## lm(formula = trstsci ~ ppltrst * eisced, data = ., weights = anweight)
    ## 
    ## Weighted Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -26.5031  -2.0000   0.4728   2.5514  16.3779 
    ## 
    ## Coefficients:
    ##                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)     4.84611    0.37014  13.093  < 2e-16 ***
    ## ppltrst         0.35111    0.06752   5.200 2.37e-07 ***
    ## eisced          0.28764    0.08112   3.546 0.000408 ***
    ## ppltrst:eisced -0.02753    0.01403  -1.962 0.050014 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.376 on 1106 degrees of freedom
    ##   (11 Beobachtungen als fehlend gelöscht)
    ## Multiple R-squared:  0.08841,    Adjusted R-squared:  0.08594 
    ## F-statistic: 35.76 on 3 and 1106 DF,  p-value: < 2.2e-16

Mit dem Paket *predict3d* können wir uns die Regression auch grafisch
ausgeben lassen.

Eine Interpretation dieser Grafik kann sich sehr schwer gestalten, es
muss berücksichtigt werden, dass versucht wird einen dreidimensionalen
Raum in einem zweidimensionalen Raum darzustellen.

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  filter(eisced != 55) %>%
  lm(trstsci ~ ppltrst + eisced, data= ., weights = anweight)  

ggPredict(model, show.point = FALSE, modx.values = seq(1,7,1), colorn = 7)
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  filter(eisced != 55) %>%
  lm(trstsci ~ ppltrst * eisced, data= ., weights = anweight)  

ggPredict(model, show.point = FALSE, modx.values = seq(1,7,1))
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-16-2.png)<!-- -->

``` r
model <- data %>%   
  filter(cntry == "GB") %>%
  filter(eisced != 55) %>%
  lm(trstsci ~ eisced * ppltrst, data= ., weights = anweight)  

ggPredict(model, show.point = FALSE, modx.values = seq(1,10,1))
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-16-3.png)<!-- -->

## Überprüfung der Vorraussetzung

**Überprüfung der Multikolinearität:**  
Für die Überprüfung der Multikolinieartät verwenden wir die Funktion
`vif()` des *car*-Paketes. Eine wichtige Orientierung bietet hier der
Wert 10. Sind die Wert größer als 10, so ist dies ein Anzeichen für
Multikolinearität.

``` r
vif(model)
```

    ## there are higher-order terms (interactions) in this model
    ## consider setting type = 'predictor'; see ?vif

    ##         eisced        ppltrst eisced:ppltrst 
    ##       7.735074       5.469411      14.373217

**Überprüfung der Linearität:**  
Um die Linearität zu Überprüfen können wir uns die Boxplots zur Hilfe
nehmen. Sie geben uns eine gute Möglichkeit zu veranschaulichen in
welchen Zusammenhang eine unabhängie zur abhängigen Variable steht. Dies
haben wir schon im Skript zu Darstellung von Daten gemacht.

``` r
data %>%
  filter(cntry %in% c("BE", "CZ", "HU", "NL", "FR", "GB")) %>%
  filter(!is.na(ppltrst)) %>%
  filter(!is.na(trstsci)) %>%
  ggplot(., aes(x = as.factor(ppltrst), y = trstsci)) +
  geom_boxplot()
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

Alternativ kann man hier auch auf den Rainbow Test zurückgreifen:

``` r
data %>%
  filter(cntry %in% c("BE", "CZ", "HU", "NL", "FR", "GB")) %>%
  filter(!is.na(ppltrst)) %>%
  filter(!is.na(trstsci)) %>%
  raintest(trstsci ~ ppltrst, data = .)
```

    ## 
    ##  Rainbow test
    ## 
    ## data:  trstsci ~ ppltrst
    ## Rain = 0.61562, df1 = 2852, df2 = 2850, p-value = 1

**Prüfung Varianzhomogenität und Normalverteilung der Residuen:**  
Für diese Überprüfung verwenden wir einfach den Befehl `plot()`.

``` r
plot(model)
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-20-2.png)<!-- -->![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-20-3.png)<!-- -->![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-20-4.png)<!-- -->

``` r
hist(model$residuals, breaks = seq(round(min(model$residuals), digits = 0)-0.5, round(max(model$residuals), digits = 0)+0.5, 1))
```

![](Korrelation,-lineare-und-multple-Regression_files/figure-gfm/unnamed-chunk-20-5.png)<!-- -->
