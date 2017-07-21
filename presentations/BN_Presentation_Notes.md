Bayesian Network_Presentation_Notes
========================================================
author: Kirsten Dorans
date: July 20, 2017
autosize: true
css: oss.css

Bayesian Decision Network Definition
========================================================

- This is an ugly presentation with some info I have learned about Bayesian Decision Networks
- Probabilistic graphical model (a type of statistical model) 
- Represents a set of random variables and their conditional dependencies via a directed acyclic graph


Key Benefits of Bayesian Decision Network
========================================================

From <https://www.r-bloggers.com/bayesian-network-in-r-introduction/>
- It is easy to exploit expert knowledge in BN models. 
- BN models have been found to be very robust in the sense of i) noisy data, ii) missing data and iii) sparse data. 
- Unlike many machine learning models (including Artificial Neural Network), which usually appear as a “black box,” all the parameters in BNs have an understandable semantic interpretation. 
          
          
Creating Custom Fitted Bayesian Networks
========================================================

- Think we are using hybrid approach (expert-driven for structure and data driven for parameters)

From <http://www.bnlearn.com/examples/custom/>

3 main approaches:
- Data-driven approach, learning it from a data set using bn.fit() and a network structure (in a bn object) as illustrated here;
- An expert-driven approach, in which both the network structure and the parameters are specified by the user;
- A hybrid approach combining the above.


Example: Lizards
========================================================






















```
Error in library(bnlearn) : there is no package called 'bnlearn'
```
