Pres_PV
========================================================
author: Patricia Varela
date: 
autosize: true

Bayesian Networks
========================================================

* Graphical modeling method based on influence diagrams.
* Represents the cause and effect dependencies of a process.
* Nodes are probability distributions and connectors are dependencies.
* Used for decision making and artificial intelligence. 

$$P\left(H \mid E\right) = \frac{P\left(E \mid H\right) \cdot P\left(H \right)}{P \left(E\right)}$$

***
<div align="center">
<img src="final_pres-figure/GenericBN.jpg" style="width: 1000px;">
</div>

Bayesian Networks
========================================================

<div align="center">
<img src="final_pres-figure/MathBN.jpg" style="width: 3000px;">
</div>

```{}
library(bnlearn)
net = model2network("[X1][X2][Xn][X_Child|X1:X2:Xn]")
```

***
<div align="center">
<img src="final_pres-figure/BN_comp_example.jpg" style="width: 1000px;">
</div>


Training Conditional Probability Tables
========================================================

<div align="center">
<img src="final_pres-figure/CPT_From_Data.jpg" style="width: 1000px;">
</div>

Results Small Model
========================================================
<div align="center">
<img src="final_pres-figure/SmallBNGeNIe.jpg" style="width: 1000px;">
</div>


Results Small Model
========================================================

Salinity
<div align="center">
<img src="final_pres-figure/Salinity.jpg" style="width: 3000px;">
</div>

***

Chlorophyll
<div align="center">
<img src="final_pres-figure/Chlorophyll.jpg" style="width: 3000px;">
</div>
