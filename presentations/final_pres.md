
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
  paste(collapse = ', ')

cat('By', aut)
```

```
By Kathryn Ireland, Patricia Varela, Jessica Renee Henkel, Ed Sherwood, Marcus Beck, Kirsten Dorans
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

Tampa Bay was gross
========================================================
<img src="prop_pres-figure/TB_Dead_Fish.jpg" alt="Drawing" style="width: 400px;"/>

<img src="prop_pres-figure/TB_Algae.png" alt="Drawing" style="width: 400px;"/>

Tampa Bay is not as gross
========================================================
![](prop_pres-figure/tb.jpg)

Tampa Bay is not as gross
========================================================
<img src="prop_pres-figure/TB_Sunset.jpg" alt="Drawing" style="width: 800px;"/>

But how much less gross??
========================================================
![](prop_pres-figure/tampa_bay_restoration.jpg)

But how much less gross??
========================================================
![](prop_pres-figure/network.png)
Ed 
* Tampa Bay Background

Tampa Bay Data Sources
========================================================
incremental: false

<div align="center">
<img src="final_pres-figure/Fig3_EPHC_Sample_Sites.png">
</div>

***
* Rich WQ Monitoring Datatset (1974-)
      * Chlorophyll, salinity, dissolved oxygen, etc.
      * Depth-integrated
      * QAQC
* Time series, monthly step - ~500 obs. per site

Tampa Bay Restoration Sites
===============

<div align="center">
<img src="final_pres-figure/restmap.tif" style="width: 1000px;">
</div>

***
* Restoration sites in Tampa Bay, watershed
      * Habitat Establishment
      * Habitat Enhancement
      * Habitat Protection
      * Stormwater Controls
      * Point Source Controls
* 571 projects, 1971 - 2016


Workflow
========================================================
Kirsten/Katie
* Model diagram
* Merging restoration diagram

Data plyring
========================================================
incremental: true

* Can we identify a change in water quality from restoration?
* What data do we have?
* Can we *plyr* the data to identify a signal?
* Can we *plyr* the data as input to a BN?

Data plyring
========================================================
incremental: false


Water quality stations and restoration sites
<div align="center">
<img src="final_pres-figure/clomap1.tif" style="width: 1000px;">
</div>

***

* Can we *plyr* the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?

Data plyring
========================================================
incremental: false

Water quality stations and restoration sites
<div align="center">
<img src="final_pres-figure/clomap2.tif" style="width: 1000px;">
</div>

***

* Can we *plyr* the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of site type?

Data plyring
========================================================
incremental: false

Water quality stations and restoration sites
<div align="center">
<img src="final_pres-figure/clomap3.tif" style="width: 1000px;">
</div>

***

* Can we *plyr* the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of site type?
* Consider distance of sites from water quality stations?

Data plyring
========================================================
incremental: false

Water quality stations and restoration sites
<div align="center">
<img src="final_pres-figure/clomap4.tif" style="width: 1000px;">
</div>

***

* Can we *plyr* the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of site type?
* Consider distance of sites from water quality stations?
* Consider a cumulative effect?

Data plyring
========================================================
incremental: false

Water quality stations and restoration sites
<div align="center">
<img src="final_pres-figure/clomap5.tif" style="width: 1000px;">
</div>

***

* Can we *plyr* the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of site type?
* Consider distance of sites from water quality stations?
* Consider a cumulative effect?

Bayesian Network
========================================================
Patricia
* Specifics of BN
* Outcomes/interpretation/applications

Conclusion
========================================================
* Next steps (all)
