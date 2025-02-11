Statistische Signifikanztests
================
Andreas Deim
11 Februar, 2025

- [Verwendete neue Befehle](#verwendete-neue-befehle)
- [Pakete laden](#pakete-laden)
- [Verteilungstests](#verteilungstests)
  - [Kolmogorov-Smirnov-Test](#kolmogorov-smirnov-test)
  - [Shapiro-Wilk-Test](#shapiro-wilk-test)
  - [X²-Anpassungstest
    (Chi-Quadrat-Anpassungstest)](#x²-anpassungstest-chi-quadrat-anpassungstest)
- [Mittelwertvergleich](#mittelwertvergleich)
  - [T-Test](#t-test)

# Verwendete neue Befehle

------------------------------------------------------------------------

`ks.test()` = Kolmogorov-Smirnov-Test  
`shapiro.test()` =Shapiro-Wilk-Test  
`chisq.test()` = X²-Anpassungstest

------------------------------------------------------------------------

# Pakete laden

``` r
library(haven)
library(dplyr)
library(tibble)
```

Datensatz einlesen (Wenn nötig)

``` r
data <- read_sav("ESS10_HV.sav") 
```

# Verteilungstests

## Kolmogorov-Smirnov-Test

Der K-S-Anpassungstest überprüft Annahmen über die Verteilung einer
Variable. In unserem Fall wollen wir schauen ob eine Variable
normalverteilt ist. Dieses Überprüfung ist erforderlich, da bei der
Verletzung der Normalverteilung einige Barrieren bei der
Ergebnisinterpretation entstehen und demnach Anpassungen notwendig sein
können.

``` r
data %>%
  select(hv_univ) %>%
  deframe()%>%
  ks.test(.,
          "pnorm",
          mean = mean(., na.rm = T),
          sd = sd(.,na.rm = T))
```

    ## Warning in ks.test.default(., "pnorm", mean = mean(., na.rm = T), sd = sd(., :
    ## für den Komogorov-Smirnov-Test sollten keine Bindungen vorhanden sein

    ## 
    ##  Asymptotic one-sample Kolmogorov-Smirnov test
    ## 
    ## data:  .
    ## D = 0.023537, p-value < 2.2e-16
    ## alternative hypothesis: two-sided

## Shapiro-Wilk-Test

Nur für kleine Stichprobengrößen geeignet. Test auf Normalverteilung.

``` r
data %>%
  filter(cntry == "GB") %>%
  select(hv_univ) %>%
  deframe()%>%
  shapiro.test()
```

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  .
    ## W = 0.99498, p-value = 0.0007667

## X²-Anpassungstest (Chi-Quadrat-Anpassungstest)

Test auf Gleichverteilung

``` r
data %>%
  select(hv_univ) %>%
  deframe() %>%
  chisq.test(abs(.))
```

    ## Warning in chisq.test(., abs(.)): Chi-Quadrat-Approximation kann inkorrekt sein

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  . and abs(.)
    ## X-squared = 20139735, df = 412874, p-value < 2.2e-16

# Mittelwertvergleich

## T-Test
