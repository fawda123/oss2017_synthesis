
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
```
By Ed Sherwood, Patricia Varela, Marcus Beck, Kathryn Ireland, Kirsten Dorans, Jessica Renee Henkel
  
Deepwater Horizon Settlement Agreement
========================================================
<img src="prop_pres-figure/consent.jpg" alt="Drawing" style="width: 2000px;"/>

Over $10B in Potential Restoration Activities
========================================================
<div class="img-with-text">
    <img src="final_pres-figure/RESTORE_Funding_chart.jpg" />
    <p><font size = "3">Graphic: eli-ocean.org</font></p>
</div>

Cumulative Effects of Restoration Activities?
========================================================
* Despite considerable **investments** in aquatic ecosystem restoration, consistent and comprehensive **effectiveness evaluation** continues to elude practitioners at geographic scales. (Diefenderfer et al. 2016)


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
* <https://fawda123.github.io/oss2017_synthesis/presentations/final_pres-figure/bayes_network.html>


Tampa Bay was gross
========================================================
<div align="center">
<div align="left">
<img src="prop_pres-figure/TB_Dead_Fish.jpg" alt="Drawing" style="width: 600px;"/>
</div>
***

<div align="right">
<img src="prop_pres-figure/TB_Algae.png" alt="Drawing" style="width: 600px;"/>
</div>
</div>

Tampa Bay is a lot better now
========================================================
<div align="center">
<div align="left">
<img src="final_pres-figure/pre_rest_sh.jpg" alt="Drawing" style="width: 800px;"/>
</div>
***

<div align="right">
<img src="final_pres-figure/post_rest_sh.jpg" alt="Drawing" style="width: 800px;"/>
</div>
</div>

But how much less gross??
========================================================
![](prop_pres-figure/tampa_bay_restoration.jpg)


Water Quality Monitoring in Tampa Bay 
========================================================
incremental: false
<div align="center">
<img src="final_pres-figure/Fig3_EPHC_Sample_Sites.png">
</div>

***
* Rich WQ Monitoring Datatset (1974-)
      * 45 Stations in TB
      * Chlorophyll, salinity, dissolved oxygen, etc.
      * Depth-integrated
      * QAQC
* Time series, monthly step - ~500 obs. per site
* Available as an EXCEL spreadsheet <ftp://ftp.epchc.org>

Tampa Bay "Restoration" Sites: Various Sources of Info
===============
incremental: false

* "Softer" Restoration -> Local ordinances (e.g. ferilizer restrictions), Education, etc.
* "Soft" Restoration -> Habitat Creation, Enhancement and Management/Protection Measures
* "Hard" Restoration -> Stormwater BMPs, Point Source Reductions through Time, Regulations

Tampa Bay Restoration Site Info: First Source
===============
incremental: false

<div align="center">
<img src="final_pres-figure/water_atlas.png">
</div>

***
* Tracking "traditional" restoration sites since ~1990s
* Include habitat creation, enhancement and acquisitions
* <http://http://maps.wateratlas.usf.edu/tampabay/>

Tampa Bay Restoration Site Info: Second Source
===============
incremental: false

<div astyle="position: relative;">
<img src="final_pres-figure/apdb.png"style="position: absolute;"/>
  <span id="overlay_img"><img src="final_pres-figure/apdb_form.png"/></span>
</div>

***
* Tracking "traditional" restoration sites since ~1990s
* Include habitat creation, enhancement and acquisitions
* <http://apdb.tbeptech.org>

Other Option
==============

<div align="center">
<img src="final_pres-figure/restmap.jpg" style="width: 1000px;">
</div>

***
* Restoration sites in Tampa Bay, watershed
      * Habitat Establishment
      * Habitat Enhancement
      * Habitat Protection
      * Stormwater Controls
      * Point Source Controls
* 571 projects, 1971 - 2016

Overall Workflow
========================================================
<img src="final_pres-figure/WorkflowOverall.png" alt="Drawing" style="width: 2500px;"/>


Developing Restoration Dataset
========================================================
<img src="final_pres-figure/restoration_activities.png" alt="Drawing" style="width: 2500px;"/>

Developing Restoration Dataset
========================================================
* Water Treatment Projects
  * Two Raw Datasets: <http://apdb.tbeptech.org>
    * Descriptions of All WT Projects
    * Names/location of Completed WT Projects
  * dplyr:  combine dataset (*left_join*), subset (*filter*) to subbasins of interest, find WT projects not listed as complete for further investigation (*anti-join*)
  

```
# A tibble: 6 x 19
  HeaderID                                 Project_Name      Bay_Segment
     <int>                                        <chr>            <chr>
1        8     Delany Creek Wetland Restoration Project Hillsborough Bay
2       10               Cone Ranch Restoration Project Hillsborough Bay
3       11       29th or 30th Street Outfall/ Mckay Bay Hillsborough Bay
4       14              Palma Ceia Area Stormwater Pond Hillsborough Bay
5       15                North Tampa Pond Enlargements Hillsborough Bay
6       19 East Lake (Alum) Stormwater Retrofit Project Hillsborough Bay
# ... with 16 more variables: Lead_Entity <chr>, Completion_Date <int>,
#   TP_Reduction_lbs_yr <dbl>, TN_Reduction_lbs_yr <dbl>,
#   TSS_Reduction_lbs_yr <int>, ProjectName <chr>,
#   OngoingInitiation <int>, DiscontinuedDate <int>, CompletionDate <int>,
#   ActualProjectCost <chr>, FundingSource <chr>,
#   ProjectDescriptionText <chr>, NonPointProject <int>,
#   PointProject <int>, ProjectLatitude <dbl>, ProjectLongitude <dbl>
```


Developing Restoration Dataset
========================================================
* Water Treatment Projects
  * Manual categorization of WT projects by technique = Categorized WT Projects

  * Broad classification: 5 unique WT project activities

```
[1] "Nonpoint_Source"       "Habitat_Enhancement"   "Habitat_Establishment"
[4] "Habitat_Protection"    "Point_Source"         
```

Developing Restoration Dataset
========================================================
* Water Treatment Projects
  * Finer classification: 26 unique WT project technologies

```
 [1] "BMP_Wetland_Treatment"  "Hydrologic_Restoration"
 [3] "BMP_Baffle_Box"         "BMP_Stormwater_Pond"   
 [5] "FW_Wetlands"            "BMP_Management"        
 [7] "Acquisition"            "BMP_On_Site"           
 [9] "PS_Treatment"           "Mangroves"             
[11] "Send_to_WWTP"           "BMP_Alum_Treatment"    
[13] "BMP_Treatment_Train"    "Uplands"               
[15] "Dredging"               "Education"             
[17] "Increase_Reuse"         "Management"            
[19] "Atmospheric_Deposition" "Protection_Management" 
[21] "Regulation"             "Exotic_Control"        
[23] "Saltmarsh"              "BMP_CDS_Unit"          
[25] "BMP_Agricultural"       "Street_Sweeping"       
```

Developing Restoration Dataset
========================================================
* Habitat Restoration Projects
  * Raw dataset: <http://http://maps.wateratlas.usf.edu/tampabay/>
  * Manual categorization of Habitat Restoration projects by technique = Categorized Habitation Restoration Projects
  * Broad classification: 3 unique WT project activities

```
[1] "Habitat_Enhancement"   "Habitat_Establishment" "Habitat_Protection"   
```

Developing Restoration Dataset
========================================================
* Habitat Restoration Projects  
  * Finer classification: 9 unique habitat restoration technologies

```
[1] "Hydrologic_Restoration" "Exotic_Control"        
[3] "FW_Wetlands"            "Mangroves"             
[5] "Saltmarsh"              "Protection_Management" 
[7] "Seagrass_Habitat"       "Oyster_Habitat"        
[9] "Acquisition"           
```

Developing Restoration Dataset
========================================================
* Merge the WT Projects with the Habitat Restoration Projects
   * *filter* on lat/lon, separate into tables of activity location vs tables of activity & technology, combine WT/Habitat location tables, combine WT/Habitat descriptive tables
  * All Restoration Activities
    * 5 types of project activities

```
[1] "HABITAT_ENHANCEMENT"   "HABITAT_ESTABLISHMENT" "HABITAT_PROTECTION"   
[4] "NONPOINT_SOURCE"       "POINT_SOURCE"         
```
 
Developing Restoration Dataset
========================================================
* 28 types of project technologies

    

```
 [1] "HYDROLOGIC_RESTORATION" "EXOTIC_CONTROL"        
 [3] "FW_WETLANDS"            "MANGROVES"             
 [5] "SALTMARSH"              "PROTECTION_MANAGEMENT" 
 [7] "SEAGRASS_HABITAT"       "OYSTER_HABITAT"        
 [9] "ACQUISITION"            "BMP_WETLAND_TREATMENT" 
[11] "BMP_BAFFLE_BOX"         "BMP_STORMWATER_POND"   
[13] "BMP_MANAGEMENT"         "BMP_ON_SITE"           
[15] "PS_TREATMENT"           "SEND_TO_WWTP"          
[17] "BMP_ALUM_TREATMENT"     "BMP_TREATMENT_TRAIN"   
[19] "UPLANDS"                "DREDGING"              
[21] "EDUCATION"              "INCREASE_REUSE"        
[23] "MANAGEMENT"             "ATMOSPHERIC_DEPOSITION"
[25] "REGULATION"             "BMP_CDS_UNIT"          
[27] "BMP_AGRICULTURAL"       "STREET_SWEEPING"       
```



Data plyring
========================================================
incremental: true

* Can we identify a change in water quality from restoration?
* What data do we have?
* Can we plyr the data to identify a signal?
* Can we plyr the data as input to a BN?

Data plyring
========================================================
incremental: false
transition: none


WQ and restoration sites
<div align="center">
<img src="final_pres-figure/clomap1.jpg" style="width: 1000px;">
</div>

***

* Can we plyr the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?

Data plyring
========================================================
incremental: false
transition: none

WQ and restoration sites
<div align="center">
<img src="final_pres-figure/clomap2.jpg" style="width: 1000px;">
</div>

***

* Can we plyr the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of restoration **site type**?

Data plyring
========================================================
incremental: false
transition: none

WQ and restoration sites
<div align="center">
<img src="final_pres-figure/clomap3.jpg" style="width: 1000px;">
</div>

***

* Can we plyr the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of restoration **site type**?
* Consider **distance** of sites from water quality stations?

Data plyring
========================================================
incremental: false
transition: none

WQ and restoration sites
<div align="center">
<img src="final_pres-figure/clomap4.jpg" style="width: 1000px;">
</div>

***

* Can we plyr the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of restoration **site type**?
* Consider **distance** of sites from water quality stations?
* Consider a **cumulative effect**?

Data plyring
========================================================
incremental: false
transition: none

WQ and restoration sites
<div align="center">
<img src="final_pres-figure/clomap5.jpg" style="width: 1000px;">
</div>

***

* Can we plyr the data to identify a signal?
* How can continuous water quality be linked to discrete restoration activites?
* Consider an effect of restoration **site type**?
* Consider **distance** of sites from water quality stations?
* Consider a **cumulative effect**?

Data plyring
========================================================
transition: none


WQ and restoration sites: **Spatial match**

<div align="center">
<img src="final_pres-figure/ptplo.jpg" style="width: 150px;">
</div>

Data plyring
========================================================
transition: none

WQ and restoration sites: **Spatial match**
<div align="center">
<img src="final_pres-figure/ptplo.jpg" style="width: 150px;">
</div>

WQ and restoration sites: **Temporal match**
<div align="center">
<img src="final_pres-figure/tmplo1.jpg" style="width: 2000px;">
</div>

Data plyring
========================================================
transition: none

WQ and restoration sites: **Spatial match**
<div align="center">
<img src="final_pres-figure/ptplo.jpg" style="width: 150px;">
</div>

WQ and restoration sites: **Temporal match**, **before/after**
<div align="center">
<img src="final_pres-figure/tmplo2.jpg" style="width: 2000px;">
</div>

Data plyring
========================================================
transition: none

WQ and restoration sites: **Spatial match**
<div align="center">
<img src="final_pres-figure/ptplo.jpg" style="width: 150px;">
</div>

WQ and restoration sites: **Temporal match**, **before/after**, **slice**
<div align="center">
<img src="final_pres-figure/tmplo3.jpg" style="width: 2000px;">
</div>

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
# A tibble: 4 x 3
# Groups:   stat [1]
   stat     cmb     cval
  <int>   <chr>    <dbl>
1     7 hab_aft 8.255185
2     7 hab_bef 8.350187
3     7 wtr_aft 8.053273
4     7 wtr_bef 8.129733
```

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

What do the data look like? For **many** water quality station matched to **many**
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


What do the data look like? For **many** water quality station matched to **many**
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
<img src="final_pres-figure/chldst1.jpg" style="width: 2000px;">
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

Bayesian Network
========================================================
incremental: true

* **Water quality** (chlorophyll) responds to **restoration** with varying effects by **salinity**
* In the **frequentist** framework - mean chlorophyll varies given treatment

$$ Chl \sim\ f\left(Water \space\ treatment \times Habitat \space\ restoration \times Salinity \right)$$

* In the **Bayesian** framework - probability of an event depends on occurrence of other events 

$$P\left(Chl \mid Event\right) = \frac{P\left(Event \mid Chl\right) \cdot P\left(Chl \right)}{P \left(Event\right)}$$

Bayesian Network
========================================================

What is the probability of low/medium/high chlorophyll given other events?

* Do water quality conditions differ by **restoration type**?
* Does it differ by **salinity** as a natural covariate?
* Is the change in agreement with expectation?

BN lets us evaluate **potential outcomes** based on **conditional distributions**

Conclusion
========================================================
* Next steps (all)

Acknowledgments
========================================================


<div align="center">
<img src="final_pres-figure/hex.png" style="width: 300px;">
</div>

