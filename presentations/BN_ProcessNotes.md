Developing a BN using pre and post impolementation of restoration activities in Tamba Bay
========================================================
author: Varela, Patricia
date: July 23, 2017
autosize: true
css: oss.css
output: html_document

Description (what)
========================================================
This is an overall description of the BN model used for the workshop synthesis.
Includes: 
* Nodes description
* BN Model's attributes
* Training BN
* Definition of CPTs
* Applied R code using manual and fitted relationships of collected data.

The Propossed Model - The Fireworks Model
========================================================


The Proposed Model - The Test Model
========================================================
A simplified version of the Fireworks model was developed to learn the mechanism of the BN modeling using the collected data during the synthesis workshop.

```r


```




Qualitative attributes on BN's variables
========================================================
* Conditional probability tables represent the cause and effect relationship of the model's variables 
* Qualitative classification of their attributes. 

```r
library(readr)
NodeTypes = read.csv("~/NCEAS/Model/NodeClasses.csv")
NodeTypesTB = data.frame(NodeTypes)
View(NodeTypesTB) #Got to figure out how to include the table in presentation from the script
print(NodeTypesTB)

```



Training CPTs
========================================================
Data Fomat: classified observations

```r
DataFormat = read.csv("~/NCEAS/oss2017_synthesis/data-raw/TestData1.csv") 
print(head(DataFormat))


```


Training CPTs
========================================================

```r
data <- data.frame(DataFormat)
View(data)


```


But how much less gross??
========================================================
![](prop_pres-figure/network.png)

Benefits
=============

* A general and flexible framework that can be applied to unique locations and is not limited by data availability
* Explicit quantification of uncertainty and model updates with new data
* More focused restoration towards specific regional issues
* Improved ability to predict outcomes of proposed restoration projects

