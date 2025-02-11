Mehrebenen Analyse
================
Andreas Deim
11 Februar, 2025

- [Verwendete neue Befehle](#verwendete-neue-befehle)
- [Pakete installieren (falls
  notwendig)](#pakete-installieren-falls-notwendig)
- [Pakete Laden](#pakete-laden)
- [Mehrebenenanalyse](#mehrebenenanalyse)
  - [Null-Modell](#null-modell)
  - [ICC](#icc)
  - [Random Intercepts, Fixed Slopes](#random-intercepts-fixed-slopes)
  - [Random Intercepts, Random Slopes](#random-intercepts-random-slopes)
  - [Modellgüte](#modellgüte)

# Verwendete neue Befehle

------------------------------------------------------------------------

`lmer()` = lineares Mehrebenen-Regressionsmodel erstellen (lme4)  
`screenreg()` = Regressionsmodell in verschiedenen Formaten ausgeben
lassen (texreg)  
`ranef()` = Randem Effekts ausgeben lassen (lme4)  
`icc()` = Intraclass Korrelationskoeffizient berechnen lassen
(performance)  
`plot_model()` = Regressionsmodell ploten (sjPlot)  
`anova()` = Varianzanalyse

------------------------------------------------------------------------

# Pakete installieren (falls notwendig)

``` r
install.packages("lme4")
install.packages("multilevel")
install.packages("texreg")
install.packages("performance")
```

# Pakete Laden

``` r
library(haven)  
library(ggplot2)  
library(dplyr)  
library(tibble)
library(lme4)
library(multilevel)
library(texreg)
library(performance)
library(sjPlot)
```

Datensatz einlesen (Wenn nötig)

``` r
data <- read_sav("ESS10_HV.sav") 
```

# Mehrebenenanalyse

## Null-Modell

Um zuerst feststellen ob es sich überhaupt lohnt eine Multilevelanalyse
zu durchzuführen lässt sich das Null-Modell zu Rate ziehen. Mit diesem
können wir im Weiteren die intraclass correlation berechnen, um
festzustellen welcher Varianzanteil unseres Modelles durch die höhere
Ebene (in unserem Fall: Länderebene) erklärt wird.

Um eine Mehrebenen-Analyse durchzuführen benötigen wir zu aller erst die
Pakete *lme4* und *multilevel*. Mit Hilfe dieser Pakete können wir die
Funktion `lmer()` nutzen.  
Für die Generierung unseres Null-Modells verwenden wir eine ähnliche
Schreibweise, wie wir sie bei der linearen oder multiplen Regression
kennen gelernt haben. Zusätzlich wird nun noch in Klammern die
unabhängige Variable auf der höheren Ebene und mit einem `|` die höhere
Ebene als solches ergänzt. Da wir in einem Mull-Modell keine
unabhängigen Variablen angeben reduziert sich der Inhalt unserer Klammer
auf `(1|cntry)`.

Mit `summary()` können wir uns wie gewohnt die Ergebnisse unseres
Modells ausgeben lassen. Zusätzlich dazu haben wir die Möglichkeit mit
`screenreg()` eine schönere Übersicht zu erhalten, welche wir uns mit
`htmlreg()` als separates Dokument abspeichern zu können, um sie in
einen Bericht ansehnlicher einzupflegen.

``` r
model1 <- data %>%   
  filter(cntry %in% c("GB","BG", "GR", "NL", "BE", "CH", "PT", "HU", "IT", "SK")) %>%
  lmer(trstsci ~ 1 + (1|cntry), data= ., weights = anweight) 
summary(model1)
```

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: trstsci ~ 1 + (1 | cntry)
    ##    Data: .
    ## Weights: anweight
    ## 
    ## REML criterion at convergence: 89834.2
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -15.7474  -0.4056   0.1235   0.5242   5.8952 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev.
    ##  cntry    (Intercept) 0.1632   0.4039  
    ##  Residual             3.9173   1.9792  
    ## Number of obs: 18396, groups:  cntry, 10
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error t value
    ## (Intercept)   7.0545     0.1294   54.52

``` r
screenreg(model1)
```

    ## 
    ## =====================================
    ##                         Model 1      
    ## -------------------------------------
    ## (Intercept)                  7.05 ***
    ##                             (0.13)   
    ## -------------------------------------
    ## AIC                      89840.24    
    ## BIC                      89863.70    
    ## Log Likelihood          -44917.12    
    ## Num. obs.                18396       
    ## Num. groups: cntry          10       
    ## Var: cntry (Intercept)       0.16    
    ## Var: Residual                3.92    
    ## =====================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05

``` r
#htmlreg(model1, file = "Multilevel_Nullmodel.html")
```

## ICC

Die intraclass correlation gibt uns den Anteil der Varianzerklärung an,
welcher durch die höhere Ebene erklärt wird.  
Diese können wir händisch aus den Werten des zuvor entwickelten Modelles
berechnen mit der Formel:

$$
ICC = \frac{\sigma^2_{\text{between}}}{\sigma^2_{\text{between}} + \sigma^2_{\text{within}}}
$$

In unserem Beispiel wäre dies:

$$
ICC = \frac{\text{var:cntry}}{\text{var:cntry} + \text{var:Residual}} = \frac{0.16}{0.16 + 3.92} = 0.039
$$

Mit diesem Ergebnis können wir vermuten, dass unsere abhängige Variable
nur geringfügig durch die Ländervariable beeinflusst wird. Die
Gruppenunterscheidung kann nahezu vernachlässigt werden.

Alternativ lässt sich mit Hilfe des Paketes *performance* und dem Befehl
`icc()` ebenso die intraclass correlation berechnen.

``` r
icc(model1)
```

    ## # Intraclass Correlation Coefficient
    ## 
    ##     Adjusted ICC: 0.040
    ##   Unadjusted ICC: 0.040

## Random Intercepts, Fixed Slopes

In der Mehrebenenanalyse könenn wir je nachdem Unterscheiden ob unsere
höhere Ebene einen statischen oder dynamischen Einfluss haben soll. Im
ersteren Fall reden wir von Random Intercepts und Fixed Slopes. Dies
bedeutet das mein Intercept in jeder Gruppe varieren kann aber der
Regressionsparameter der unabhängigen Variablen immer der gleiche
bleibt. Egal ob wir Deutschland oder Frankreich betrachten, der Einfluss
des allgemeinen Vertrauens in Menschen wirkt sich überall gleich auf das
Vertrauen in Wissenschaftler:innen aus.

Im folgenden das Beispiel.

1.  Mit dem Befehl `plot_model()` des Paketes *sjPlot* können wir uns
    die varierenden Grafisch anzeigen und mit dem Befehl `ranef()` auch
    direkt als Zahl ausgeben lassen.

``` r
model2 <- data %>%   
  filter(cntry %in% c("GB","BG", "GR", "NL", "BE", "CH", "PT", "HU", "IT", "SK")) %>%
  filter(!is.na(ppltrst)) %>%
  lmer(trstsci ~ ppltrst + (1|cntry), data= ., weights = anweight)

plot_model(model2, type = "re", show.values = TRUE, value.offset = .4)
```

![download](https://github.com/user-attachments/assets/e3116abd-c8f6-4909-a1d8-ef48082fdc99)


``` r
ranef(model2)
```

    ## $cntry
    ##     (Intercept)
    ## BE  0.002398657
    ## BG -0.308491037
    ## CH -0.137582074
    ## GB  0.161332663
    ## GR  0.385254559
    ## HU -0.363480209
    ## IT  0.022597002
    ## NL  0.023393235
    ## PT  0.667502393
    ## SK -0.452925188
    ## 
    ## with conditional variances for "cntry"

``` r
screenreg(c(model1, model2))
```

    ## 
    ## ====================================================
    ##                         Model 1        Model 2      
    ## ----------------------------------------------------
    ## (Intercept)                  7.05 ***       5.99 ***
    ##                             (0.13)         (0.12)   
    ## ppltrst                                     0.22 ***
    ##                                            (0.01)   
    ## ----------------------------------------------------
    ## AIC                      89840.24       88658.57    
    ## BIC                      89863.70       88689.84    
    ## Log Likelihood          -44917.12      -44325.28    
    ## Num. obs.                18396          18362       
    ## Num. groups: cntry          10             10       
    ## Var: cntry (Intercept)       0.16           0.12    
    ## Var: Residual                3.92           3.71    
    ## ====================================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05

## Random Intercepts, Random Slopes

Sofern die Notwendigkeit besteht können wir ebenso noch zulassen, dass
die unabhängigen Variablen auf der höheren Ebene einen unterschiedlichen
Einfluss haben.

Im folgenden könnten wir annehmen, dass die dass das Vertrauen in
Menschen in jedem Land einen anderen Einfluss auf das Vertrauen in
Wissenschaftler:innen hat.

**Wichtig** ist es an dieser Stelle die unabhägigen Variablen zu
zentralisieren.  
Dies machen wir einfach in der Zeile
`mutate(ppltrst = scale(ppltrst, scale = FALSE)) %>%`

``` r
model3 <- data %>%   
  filter(cntry %in% c("GB","BG", "GR", "NL", "BE", "CH", "PT", "HU", "IT", "SK")) %>%
  filter(!is.na(ppltrst)) %>%
  mutate(ppltrst = scale(ppltrst, scale = FALSE)) %>%
  lmer(trstsci ~ ppltrst + (ppltrst|cntry), data= ., weights = anweight)

plot_model(model3, type = "re", show.values = TRUE, value.offset = .4)
```

![download](https://github.com/user-attachments/assets/24d55f43-2ebf-4c29-9991-4806b8ccc537)


``` r
ranef(model3)
```

    ## $cntry
    ##     (Intercept)      ppltrst
    ## BE -0.005817822  0.029171438
    ## BG -0.268397058  0.032702435
    ## CH -0.119887092 -0.002286753
    ## GB  0.133123626  0.054767549
    ## GR  0.369718643 -0.092518653
    ## HU -0.339120366 -0.120694203
    ## IT  0.038558828 -0.029657050
    ## NL -0.060901469  0.059107197
    ## PT  0.638656754 -0.038432744
    ## SK -0.385934044  0.107840783
    ## 
    ## with conditional variances for "cntry"

``` r
screenreg(c(model1, model2, model3))
```

    ## 
    ## ===========================================================================
    ##                                 Model 1        Model 2        Model 3      
    ## ---------------------------------------------------------------------------
    ## (Intercept)                          7.05 ***       5.99 ***       7.01 ***
    ##                                     (0.13)         (0.12)         (0.11)   
    ## ppltrst                                             0.22 ***       0.21 ***
    ##                                                    (0.01)         (0.03)   
    ## ---------------------------------------------------------------------------
    ## AIC                              89840.24       88658.57       88603.54    
    ## BIC                              89863.70       88689.84       88650.45    
    ## Log Likelihood                  -44917.12      -44325.28      -44295.77    
    ## Num. obs.                        18396          18362          18362       
    ## Num. groups: cntry                  10             10             10       
    ## Var: cntry (Intercept)               0.16           0.12           0.11    
    ## Var: Residual                        3.92           3.71           3.69    
    ## Var: cntry ppltrst                                                 0.01    
    ## Cov: cntry (Intercept) ppltrst                                    -0.01    
    ## ===========================================================================
    ## *** p < 0.001; ** p < 0.01; * p < 0.05

## Modellgüte

Ob sich ein Modell verbessert hat lässt sich vor allem an den Werten AIC
und BIC ablesen. Je kleiner diese sind desto besser.

Genauer können wir eine Verbesserung des Modells allerdings mit dem
Befehl `anova()` nachvollziehen. Ist der unterschied zwischen den
Modellen signifikant, so können wir von einer Modellverbesserung reden
und das komplexere Modell annehmen.

Da hinter jedem Model die selbe Anzahl an Personen stehen muss, müssen
wir noch unser `model1` anpassen. Hier wurden bis dato auch die Personen
berücksichtigt, die keine Angaben zu `ppltrst` gemacht haben.

``` r
model1 <- data %>%   
  filter(cntry %in% c("GB","BG", "GR", "NL", "BE", "CH", "PT", "HU", "IT", "SK")) %>%
  filter(!is.na(ppltrst)) %>%
  lmer(trstsci ~ 1 + (1|cntry), data= ., weights = anweight) 


anova(model1, model2, model3)
```

    ## refitting model(s) with ML (instead of REML)

    ## Data: .
    ## Models:
    ## model1: trstsci ~ 1 + (1 | cntry)
    ## model2: trstsci ~ ppltrst + (1 | cntry)
    ## model3: trstsci ~ ppltrst + (ppltrst | cntry)
    ##        npar   AIC   BIC logLik deviance   Chisq Df Pr(>Chisq)    
    ## model1    3 89649 89672 -44821    89643                          
    ## model2    4 88648 88679 -44320    88640 1002.72  1  < 2.2e-16 ***
    ## model3    6 88595 88642 -44292    88583   56.64  2   5.02e-13 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
