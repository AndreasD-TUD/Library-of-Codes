Darstellung von Daten
================
Andreas Deim
2024-12-01

- [Pakete Laden](#pakete-laden)
- [Grafische Darsrellung](#grafische-darsrellung)

## Pakete Laden

``` r
library(haven)
library(sur)
library(ggplot2)
library(dplyr)
library(car)
library(tibble)
```

Datensatz einlesen (Wenn nötig)

``` r
data <- read_sav("ESS11_HV.sav") 
```

## Grafische Darsrellung

### Boxplot

Ein **Boxplot** (oder Box-and-Whisker-Plot) zeigt auf einen Blick
zentrale Tendenzen und Streuungen von Daten. Die wichtigsten Elemente
eines Boxplots sind:

1.  **Box**:

    - Die Box repräsentiert den Bereich zwischen dem 1. Quartil (Q1,
      unteres Viertel) und dem 3. Quartil (Q3, oberes Viertel).

    - Die Linie in der Box zeigt den Median (den mittleren Wert) an.

2.  **Whisker (Fühler)**:

    - Die Whisker zeigen die Datenbereiche außerhalb der Box bis zu den
      maximalen bzw. minimalen Werten innerhalb eines bestimmten
      Bereichs (typisch: 1,5-facher Interquartilsabstand, IQR).

3.  **Ausreißer**:

    - Werte, die außerhalb der Whisker liegen, werden als Punkte oder
      Sterne markiert.

Die Darstellung eines Boxplots ist über den Befehl `boxplot()` möglich.
Im folgenden erstmal ohne weitere Beschreibungen für die Human Values
Universalism, Power und Security.

``` r
data %>%
  select(hv_univ) %>%
  boxplot()
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-3-1.jpeg)<!-- -->

Wenn wir mehrer Variablen gelichzeitig dargestellt haben möchten so
ergänzen wir sich einfach in `select()`.

Desweiteren können wir noch Beschriftungen hinzufügen.

Für den besseren Überblick kann die Anpassung der Optionen auf mehreren
Zeilen erfolgen. Wichtig hierbei ist es nicht zu vergessen die Kommas
zwischen diesen zu setzten und am Ende den Befehl mit einer geschlossen
Klammer abzuschließen.

``` r
data %>%
  select(hv_univ, hv_power, hv_secur) %>%
  boxplot(.,
    xlab = "Human Values",
    ylab = "Wert",
    main = "Boxplot HV"
  )
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-4-1.jpeg)<!-- -->

… oder auch Farben der TU Dresden
(<https://tu-dresden.de/tu-dresden/kontakte-services/cd>)

``` r
data %>%
  select(hv_univ, hv_power, hv_secur) %>%
  boxplot(.,
    xlab = "Human Values",
    ylab = "Wert",
    main = "Boxplot HV",
    col = c("#0069b4", "#e0318a", "#00305D")
  )
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-5-1.jpeg)<!-- -->

Es gibt bei der Darstellung vielfältige Möglichkeiten, welche alle unter
der Hilfeseite `?boxplot()` eingesehen werden können.

**Ausblick ggplot2:**

Desweiteren kann man auch komplexere Grafiken mit *ggplot2* erstellen,
welche in manchen Fällen etwas mehr Vorarbeit erfordert.

1.  **Datensatz:** Zu Beginn muss der Datensatz definiert werden. Dies
    geschieht mit dem Befehl `ggplot(Datensatz, aes())`

2.  **Ästhetik (aes)**: Dann folgt die Eingabe der Variablen, die wir im
    Datensatz verwenden wollen. Zusätzlich können hier designerische
    Eigenschaften (z. B. Achsen, Farben, Formen) angepasst werden.
    `ggplot(Datensatz, aes(x, y, weiteres))`

3.  **Geometrie (geom)**: Bestimmt den Typ der Grafik, z. B. Punkte
    (`geom_point`), Linien (`geom_line`), Balken (`geom_bar`). Dies wird
    nach dem `ggplot()`-Befehl mit einem `+` ergänzt. Wenn nötig können
    mehrere Grafiken überlagert werden.
    `ggplot(Datensatz, aes(x, y, weiteres)) + geom_line() + geom_point()`

4.  **Facetten**: Ermöglicht die Unterteilung in mehrere Diagramme
    basierend auf einer oder mehreren Variablen. Dies wird ebenso mit
    einem `+` ergänzt `... + facet_grid()`

5.  **Weiteres:** Es gibt darüber noch viele weiter Option. Diese finden
    sich anschaulich zusammengefasst auf dem Cheat Sheet von ggplot2

``` r
a <- data %>%
  select(hv_univ) %>%
  mutate(HV = rep("Universalism", length(.))) %>%
  rename(HV_Value = hv_univ)

b <- data %>%
  select(hv_power) %>%
  mutate(HV = rep("Power", length(.))) %>%
  rename(HV_Value = hv_power)

c <- data %>%
  select(hv_secur) %>%
  mutate(HV = rep("Security", length(.))) %>%
  rename(HV_Value = hv_secur)

bpdata <- bind_rows(a,b,c)

ggplot(bpdata, aes(x = HV, y = HV_Value)) +
geom_boxplot()
```

    ## Warning: Removed 994 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-6-1.jpeg)<!-- -->

Für die Darstellung des selben Boxplots lohnt sich dieser Aufwand eher
weniger. Spannender wird es allerdings, wenn wir die Verteilung zum
Beispiel nach Ländern differenz betrachten wollen.

``` r
data %>%
  filter(cntry %in% c("BE", "CZ", "HU", "NL", "FR", "GB")) %>%
  ggplot(., aes(x = cntry, y = hv_secur)) +
  geom_boxplot()
```

    ## Warning: Removed 157 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-7-1.jpeg)<!-- -->

Für den gleichen Fall können wir ebenso eine Violin-Grafik ausgeben
lassen. Sie gibt uns eine detailiertere Ansicht der Verteilung.

``` r
data %>%
  filter(cntry %in% c("BE", "CZ", "HU", "NL", "FR", "GB")) %>%
  ggplot(., aes(x = cntry, y = hv_secur)) +
  geom_violin()
```

    ## Warning: Removed 157 rows containing non-finite outside the scale range
    ## (`stat_ydensity()`).

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-8-1.jpeg)<!-- -->

Auch hier können vielfältige grafische Anpassungen vorgenommen werden,
auf die allerdings nicht weiter eingegangen wird.

### QQ-Plot

Das **QQ-Plot (Quantile-Quantile-Plot)** verwenden wir, um zu
überprüfen, ob eine Menge von Daten einer bestimmten theoretischen
Verteilung folgt. In unserem Fall der Normalverteilung.

Um einen QQ-Plot zu erstellen gibt es verschiedene Möglichkeiten. Zuerst
mit den Standardpaket *stats,* dass nicht zusätzlich heruntergeldaen
werden muss.

``` r
data %>%
  select(hv_univ) %>%
  deframe() %>%
  qqnorm()

data %>%
  select(hv_univ) %>%
  deframe() %>%
  qqline()
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-9-1.jpeg)<!-- -->

``` r
#Oder auch einfacherer ohne dplyr

qqnorm(data$hv_univ)
qqline(data$hv_univ)
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-9-2.jpeg)<!-- -->

Mit dem Befehl `deframe()` des *tibble*-Paketes transformieren wir den
ausgewählten Datensatz in eine Liste, damit die Daten für den
nachfolgenden Befehl lesbar werden.

Dann gibt es da auch die Möglichkeit das Paket *car* zu verwenden mit
dem Befehl `qqPlot()` (großes P!). Hier bekommen wir direkt das lineare
Modell mit seiner Abweichung mitgeliefert. Das ist relativ praktisch, da
wir den Befehl `qqline()` nicht erneut aufrufen müssen.

Im folgenden wird neben der Variable `hv_univ` auch `eisced`
dargestellt. Beim ersteren handelt es sich um eine kontinuierliche und
beim zweiten um eine diskrete Variable.

Bei der Betrachtung der Bildungsabschlüsse ist noch zu beachten dass der
Wert 55 (steht für “Other”) entfernt werden muss, da es die Grafik
verzerrt. Dies wird mit `filter(eisced != 55)` (Behalte alles außer 55)
gemacht.

``` r
data %>%
  select(hv_univ) %>%
  deframe() %>%
  qqPlot()
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-10-1.jpeg)<!-- -->

    ## [1] 14762 13514

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>% 
  deframe() %>%
  qqPlot()
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-10-2.jpeg)<!-- -->

    ## [1] 172 219

Und zu letzt nochmal die Veranschaulichung mit *ggplot2.*

``` r
ggplot(data, aes(sample = hv_univ)) +
  geom_qq() +
  geom_qq_line()
```

    ## Warning: Removed 320 rows containing non-finite outside the scale range
    ## (`stat_qq()`).

    ## Warning: Removed 320 rows containing non-finite outside the scale range
    ## (`stat_qq_line()`).

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-11-1.jpeg)<!-- -->

``` r
data %>%
  filter(eisced != 55) %>%
  ggplot(., aes(sample = eisced)) +
  geom_qq() +
  geom_qq_line()
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-11-2.jpeg)<!-- -->

Alle Grafiken können wie bei den Boxplots grafisch angepasst werden.

### Histogram

Das Histogramm gibt und einen schönen Überblick über die Verteilung.
Auch hier werden wieder verschiedene Möglichkeiten aufgezeigt.

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist()
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-12-1.jpeg)<!-- -->

Wenn wir den Standard-Befehl `hist()` verwenden müssen wir noch einige
Anpassungen vornehmen, damit die Grafik besser interpretierbar wird.
Zentral ist hierbei die Option `hist(..., breaks = ...)` die wir
Anpassen müssen.

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist(., breaks = "Scott")
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-13-1.jpeg)<!-- -->

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist(., breaks = seq(0.5,7.5,1))
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-13-2.jpeg)<!-- -->

Mit dem Befehl `seq()` (Sequenz) geben wir einen Vektor vor, der von 0,5
bis 7,5 mit jeweils einem Abstand von 1 läuft. Wir verwenden diesen
Befehl um für `breaks` die genaue Position vorzugeben wo die Balken
eingefügt werden sollen.

Es kann relevant sein sich anstatt der absoluten Häufigkeit die relative
Häufigkeit auf der y-Achse anzeigen zu lassen. Dies ist möglich indem
wir die Option `hist(..., freq = FALSE)` setzen.

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist(.,breaks = seq(0.5,7.5,1),freq = FALSE)
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-14-1.jpeg)<!-- -->

Wollen wir noch die Beschreibung und Farben anpassen so können wir das
wie folgt machen.

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist(.,
       breaks = seq(0.5,7.5,1),
       freq = FALSE,
       main = "Bildung im ESS11",
       xlab = "Bildungsgrad",
       ylab = "relative Häufigkeit",
       col = "#0069b4")
```

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-15-1.jpeg)<!-- -->

Farben und Beschriftung können hier auch hinzugefügt werden –\>
`?hist()`.

Und nun nochmal das ganze mit ***ggplot2***

``` r
data %>%
  filter(eisced != 55) %>%
  ggplot(., aes(eisced)) +
  geom_histogram()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-16-1.jpeg)<!-- -->

Auch hier können wir wieder verschiedene Anpassungen vornehmen.

``` r
data %>%
  filter(eisced != 55) %>%
  ggplot(., aes(x = eisced, y = ..density..)) +
  geom_histogram(center = 0, 
                 binwidth = 1, 
                 fill="#0069b4",
                 color = "black")
```

    ## Warning: The dot-dot notation (`..density..`) was deprecated in ggplot2 3.4.0.
    ## ℹ Please use `after_stat(density)` instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-17-1.jpeg)<!-- -->

Spannender ist die Verwendung von ggplot bei kontinuierlichen Daten,
hier kann es allerdings schnell komplexer werden.

``` r
data %>%
  ggplot(., aes(x = hv_univ, y = ..density..)) +
  geom_histogram(center = 0,binwidth = 0.1, fill="#0069b4", color = "black", alpha=0.8) +
  stat_density(fill="#e0318a", color="black", alpha=0.3)
```

    ## Warning: Removed 320 rows containing non-finite outside the scale range
    ## (`stat_bin()`).

    ## Warning: Removed 320 rows containing non-finite outside the scale range
    ## (`stat_density()`).

![](Darstellung-von-Daten_files/figure-gfm/unnamed-chunk-18-1.jpeg)<!-- -->

### Speichern von Grafiken

Das Speichern von Grafiken erfolgt über verschiedene Möglichkeiten. Am
einfachsten ist die Verwendung des Befehles `png()` (andere Dateiformate
wie jpeg oder bmp auch möglich).

Bei der Verwendung dieses Befehls muss beachtet werden, dass dieser
ausgeführt wird bevor der Graph geplottet wird und nach dem plotten mit
`dev.off()` geschlossen wird.

Die Grafik wird, sofern in der Namensbezeichnung nicht anders angegeben,
immer in dem Arbeitspfad abgespeichert.

``` r
png("Bildungsverteilung.png", width = 1280, height = 720, pointsize = 20)

data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist(.,
       breaks = seq(0.5,7.5,1),
       freq = FALSE,
       main = "Bildung im ESS11",
       xlab = "Bildungsgrad",
       ylab = "relative Häufigkeit",
       col = "#0069b4")

dev.off()
```

Der einfachheitshalber geben wir nur den Namen der Datei an
`"Bildungsverteilung.png"` ,  
die Breite und Höhe des Bildes `width = 1280, height = 720`  
und die größe des Textes `pointsize = 20`.

Je nach größe des Bildes muss auch die Textgröße angepasst werden.
