
<insertHTML:[columns.html]

Use of prior knowledge to inform restoration projects in estuaries of GOM
========================================================
date: July 28, 2017
autosize: true
css: oss.css


```r
# randomize author order
aut <- c('Marcus Beck', 'Kirsten Dorans', 'Jessica Renee Henkel', 'Kathryn Ireland', 'Ed Sherwood', 'Patricia Varela') %>% 
  sample %>% 
  paste(collapse = ', ') %>% 
  cat('By', .)
```

```
<<<<<<< Updated upstream
By Kathryn Ireland, Jessica Renee Henkel, Marcus Beck, Patricia Varela, Ed Sherwood, Kirsten Dorans
=======
By Kirsten Dorans, Patricia Varela, Kathryn Ireland, Jessica Renee Henkel, Ed Sherwood, Marcus Beck
>>>>>>> Stashed changes
```
  
Deepwater Horizon Settlement Agreement
========================================================
<img src="prop_pres-figure/consent.jpg" alt="Drawing" style="width: 2000px;"/>

Over $10B in Potential Restoration Activities
========================================================
<img src="final_pres-figure/RESTORE_Funding_chart.jpg" alt="Drawing" style="width: 800px;"/>

Cumulative Effects of Restoration Activities?
========================================================
<img src="final_pres-figure/firework.png" alt="Drawing" style="width: 2000px;"/>


* Vision to make it portable
* Why Bayesian networks

Benefits
=============

* A general and flexible framework that can be applied to unique locations and is not limited by data availability
* Explicit quantification of uncertainty and model updates with new data
* More focused restoration towards specific regional issues
* Improved ability to predict outcomes of proposed restoration projects


A Network
========================================================

















```
Error in file(con, "rb") : cannot open the connection
```
<<<<<<< Updated upstream

Data plyring
========================================================
transition: none

What do the data look like? For **one** water quality station matched to **many**
restoration sites...

WQ and restoration sites: **Temporal match**, **before/after**, **slice**
<div align="center">
<img src="final_pres-figure/tmplo3.jpg" style="width: 2000px;">
</div>


```
# A tibble: 4 x 4
   stat     hab     wtr     cval
  <int>  <fctr>  <fctr>    <dbl>
1     7 hab_aft wtr_aft 8.154229
2     7 hab_aft wtr_bef 8.192459
3     7 hab_bef wtr_aft 8.201730
4     7 hab_bef wtr_bef 8.239960
```

Data plyring
========================================================
transition: none

What do the data look like? For **many** water quality stations matched to **many**
restoration sites...

```
# A tibble: 20 x 4
    stat     hab     wtr      cval
   <int>  <fctr>  <fctr>     <dbl>
 1     6 hab_aft wtr_aft  8.903273
 2     6 hab_aft wtr_bef 11.720206
 3     6 hab_bef wtr_aft 11.902951
 4     6 hab_bef wtr_bef 14.719883
 5     7 hab_aft wtr_aft  8.154229
 6     7 hab_aft wtr_bef  8.192459
 7     7 hab_bef wtr_aft  8.201730
 8     7 hab_bef wtr_bef  8.239960
 9     8 hab_aft wtr_aft 19.867100
10     8 hab_aft wtr_bef 17.444274
11     8 hab_bef wtr_aft 17.331973
12     8 hab_bef wtr_bef 14.909147
13     9 hab_aft wtr_aft  9.030021
14     9 hab_aft wtr_bef  8.621069
15     9 hab_bef wtr_aft  8.398558
16     9 hab_bef wtr_bef  7.989606
17    11 hab_aft wtr_aft  6.576058
18    11 hab_aft wtr_bef  6.727664
19    11 hab_bef wtr_aft  8.112902
20    11 hab_bef wtr_bef  8.264508
```

Data plyring
========================================================
transition: none


What do the data look like? For **many** water quality stations matched to **many**
restoration sites...
<div align="center">
<img src="final_pres-figure/chldst1.jpg" style="width: 2000px;">
</div>

Data plyring
========================================================
transition: none

What do the data look like? For **many** water quality stations matched to **many**
restoration sites...
<div align="center">
<img src="final_pres-figure/chldst2.jpg" style="width: 2000px;">
</div>

Data plyring
========================================================
transition: none

What do the data look like? For **many** water quality stations matched to **many**
restoration sites...
<div align="center">
<img src="final_pres-figure/chldst3.jpg" style="width: 2000px;">
</div>

Data plyring
========================================================
incremental: true

* In other words, what is the **conditional distribution** of chlorophyll given **restoration type** and **before/after** effect?  

* Similar to a **two-way** ANOVA...

$$ Chl \sim\ f\left(Water \space\ treatment \times Habitat \space\ restoration\right)$$

* This can be extrapolated to additional 'treatments', or a **three-way** ANOVA

$$ Chl \sim\ f\left(Water \space\ treatment \times Habitat \space\ restoration \times Salinity \right)$$

Data plyring
========================================================
Conditional distributions on **two-levels**:

<div align="center">
<img src="final_pres-figure/chldst3.jpg" style="width: 2000px;">
</div>

Data plyring
========================================================
transition: none


Conditional distributions on **three-levels**:

<div align="center">
<img src="final_pres-figure/chlsaldst1.jpg" style="width: 2200px;">
</div>

Data plyring
========================================================
transition: none

Conditional distributions on **three-levels**:

<div align="center">
<img src="final_pres-figure/chlsaldst2.jpg" style="width: 2200px;">
</div>

Data plyring
========================================================
transition: none

Conditional distributions on **three-levels**:

<div align="center">
<img src="final_pres-figure/chlsaldst3.jpg" style="width: 2200px;">
</div>

Data plyring
========================================================

* **Water quality** (chlorophyll) responds to **restoration** with varying effects by **salinity**
* In the **frequentist** framework - mean chlorophyll varies given treatment
* In the **Bayesian** framework - probability of an event depends on occurrence of other events 

Bayesian Network
========================================================
Patricia
* Specifics of BN
* Outcomes/interpretation/applications

Conclusion
========================================================
* Next steps (all)
=======
>>>>>>> Stashed changes
