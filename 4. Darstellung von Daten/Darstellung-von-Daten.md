Darstellung von Daten
================
Andreas Deim
10 Februar, 2025

- [Verwendete neue Befehle](#verwendete-neue-befehle)
- [Pakete Laden](#pakete-laden)
- [Grafische Darsrellung](#grafische-darsrellung)
  - [Boxplot](#boxplot)
  - [Ausblick ggplot2:](#ausblick-ggplot2)
  - [QQ-Plot](#qq-plot)
  - [Histogram](#histogram)
  - [Speichern von Grafiken](#speichern-von-grafiken)

# Verwendete neue Befehle

------------------------------------------------------------------------

`boxplot()` = Boxplot generieren  
`rename()` = Variable umbenennen (dplyr)  
`ggplot()` = Eine Grafik mit ggplot2 erzeugen (ggplot2)  
`aes()` = Grafische Parameter festlegen (ggplot2)  
`geom_boxplot()` = Boxplot generieren (ggplot2)  
`geom_violine()` = Violinplot generieren (ggplot2)  
`facet_wrap()` = Mehrere Plots nach Gruppen ausgeben lassen (ggplot2)  
`deframe()` = Datenformat von dplyr auflösen (tibble)  
`qqnorm()` = QQPlot ausgeben lassen  
`qqline()` = Linie im QQPlot hinzufügen  
`qqPlot()` = QQPlot mit Linie ausgeben lassen (großes “P”, car)  
`geom_qq()` = QQPlot ausgeben lassen (ggplot2)  
`geom_qq_line()` = inie im QQPlot hinzufügen (ggplot2)  
`hist()` = Histogram generieren  
`geom_histogram()` = Histogram generieren (ggplot2)  
`png()` = Speichern von Grafiken im png-Format  
`dev.off()` = `png()` Befehl schließen und die generierte Grafik
speichern

------------------------------------------------------------------------

# Pakete Laden

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
data <- read_sav("ESS10_HV.sav") 
```

# Grafische Darsrellung

## Boxplot

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

![download](https://github.com/user-attachments/assets/61adac9d-9dfa-4d66-919d-9a718dadc007)


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

![download](https://github.com/user-attachments/assets/fd0e53c1-3e88-4b25-aaee-b8121f0c5225)

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

![download](https://github.com/user-attachments/assets/7355ba76-48f1-49d3-8919-82ccc8fd46af)


Es gibt bei der Darstellung vielfältige Möglichkeiten, welche alle unter
der Hilfeseite `?boxplot()` eingesehen werden können.

## Ausblick ggplot2:

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

    ## Warning: Removed 828 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).
    
![download](https://github.com/user-attachments/assets/fa7acb89-1c89-4051-aa0d-6aa84b2b8dad)


Für die Darstellung des selben Boxplots lohnt sich dieser Aufwand eher
weniger. Spannender wird es allerdings, wenn wir die Verteilung zum
Beispiel nach Ländern differenz betrachten wollen.

``` r
data %>%
  filter(cntry %in% c("BE", "CZ", "HU", "NL", "FR", "GB")) %>%
  ggplot(., aes(x = cntry, y = hv_secur)) +
  geom_boxplot()
```

    ## Warning: Removed 90 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).
    
![download](https://github.com/user-attachments/assets/e9015dc0-b0be-4254-ba79-fae99aa16f4d)


Für den gleichen Fall können wir ebenso eine Violin-Grafik ausgeben
lassen. Sie gibt uns eine detailiertere Ansicht der Verteilung.

``` r
data %>%
  filter(cntry %in% c("BE", "CZ", "HU", "NL", "FR", "GB")) %>%
  ggplot(., aes(x = cntry, y = hv_secur)) +
  geom_violin()
```

    ## Warning: Removed 90 rows containing non-finite outside the scale range
    ## (`stat_ydensity()`).
    
![download](https://github.com/user-attachments/assets/2ccf7194-7326-4a89-9e26-81b92551eb37)


Auch hier können vielfältige grafische Anpassungen vorgenommen werden,
auf die allerdings nicht weiter eingegangen wird.

``` r
data %>%
  filter(cntry %in% c("BE", "GB")) %>%
  filter(!is.na(domicil)) %>%
  ggplot(., aes(x=as.factor(domicil), y=hv_trad, fill=cntry)) + 
    geom_boxplot()
```

    ## Warning: Removed 12 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).
    
![download](https://github.com/user-attachments/assets/fe113942-ce9f-437d-847f-a8747393ba5d)


``` r
data %>%
  filter(cntry %in% c("BE", "GB")) %>%
  filter(!is.na(domicil)) %>%
  ggplot(., aes(x=as.factor(domicil), y=hv_trad, fill=cntry)) + 
    geom_boxplot() +
    facet_wrap(~cntry)
```

    ## Warning: Removed 12 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).
    
![download](https://github.com/user-attachments/assets/e575674f-a2ee-4508-8291-17ce240669b9)


## QQ-Plot

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

![download](https://github.com/user-attachments/assets/60af2afd-2ba3-4f47-b1a9-2fb37678159f)


``` r
#Oder auch einfacherer ohne dplyr

qqnorm(data$hv_univ)
qqline(data$hv_univ)
```

![download](https://github.com/user-attachments/assets/34185365-229c-408a-9bef-c5281f92667f)


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

![download](https://github.com/user-attachments/assets/e00dee85-baeb-4503-9aa9-fe58b129c6d0)


    ## [1]  6499 14974

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>% 
  deframe() %>%
  qqPlot()
```

![download](https://github.com/user-attachments/assets/fc2dab82-78fd-4025-929a-109937c0c572)


    ## [1]  1 11

Und zu letzt nochmal die Veranschaulichung mit *ggplot2.*

``` r
ggplot(data, aes(sample = hv_univ)) +
  geom_qq() +
  geom_qq_line()
```

    ## Warning: Removed 246 rows containing non-finite outside the scale range
    ## (`stat_qq()`).

    ## Warning: Removed 246 rows containing non-finite outside the scale range
    ## (`stat_qq_line()`).
    
![download](https://github.com/user-attachments/assets/5e5b2515-e6cd-4749-a0dd-a7d2e1dd16ea)


``` r
data %>%
  filter(eisced != 55) %>%
  ggplot(., aes(sample = eisced)) +
  geom_qq() +
  geom_qq_line()
```

![download](https://github.com/user-attachments/assets/5b4de38d-94f6-4f1c-bee1-067fd2e2c20a)


Alle Grafiken können wie bei den Boxplots grafisch angepasst werden.

## Histogram

Das Histogramm gibt und einen schönen Überblick über die Verteilung.
Auch hier werden wieder verschiedene Möglichkeiten aufgezeigt.

``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist()
```

![download](https://github.com/user-attachments/assets/aaf32ed1-6cd1-4dce-8e7e-af2ccd274e2e)


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

![download](https://github.com/user-attachments/assets/0908a0e4-53fc-41df-840c-6a12c04d6a01)


``` r
data %>%
  select(eisced) %>%
  filter(eisced != 55) %>%
  deframe() %>%
  hist(., breaks = seq(0.5,7.5,1))
```

![download](https://github.com/user-attachments/assets/714857fd-0494-4299-89ff-87ddf83eed50)


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

![download](https://github.com/user-attachments/assets/a149929a-9f5f-4fe9-88f3-2aa4aa49813e)


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

![download](https://github.com/user-attachments/assets/ab79f4cf-17f1-442d-9c82-b7a9e880e582)


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
    
![download](https://github.com/user-attachments/assets/02469abc-d349-4ff9-8680-0faf6f3abcdd)


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
    
![download](https://github.com/user-attachments/assets/9528e72e-1bce-4fc7-8d7e-553662dcb29d)


Spannender ist die Verwendung von ggplot bei kontinuierlichen Daten,
hier kann es allerdings schnell komplexer werden.

``` r
data %>%
  ggplot(., aes(x = hv_univ, y = ..density..)) +
  geom_histogram(center = 0,binwidth = 0.1, fill="#0069b4", color = "black", alpha=0.8) +
  stat_density(fill="#e0318a", color="black", alpha=0.3)
```

    ## Warning: Removed 246 rows containing non-finite outside the scale range
    ## (`stat_bin()`).

    ## Warning: Removed 246 rows containing non-finite outside the scale range
    ## (`stat_density()`).
    
![download](https://github.com/user-attachments/assets/c92f96f0-9cfd-4ef8-92e8-c555ea899910)


## Speichern von Grafiken

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
