library(bnlearn)
library(readr)
rm(list=ls())
#Method 1: Manual definition of CPTs:
#Create marginal probability tables manually
cptHR <- matrix(c(1, 0), ncol = 2, dimnames = list(NULL, c("PRE", "POST")))
cptWT <- matrix(c(1, 0), ncol = 2, dimnames = list(NULL, c("PRE", "POST")))
cptSal <- (c(0.533, 0.289, 0.178, 0.667, 0.155, 0.178, 0.4, 0.422, 0.178, 0.533, 0.289, 0.178))
dim(cptSal) <- c(3, 2, 2)
dimnames(cptSal) <- list("Sal" = c("LOW", "MOD", "HIGH"), "HR" =  c("PRE", "POST"), "WT" = c("PRE", "POST"))
cptChl <- (c(0.542, 0.25, 0.208, 0.308, 0.538, 0.154, 0.286, 0, 0.714, 0.633, 0.267, 0.1, 0.429, 0.142, 0.429, 0.286, 0.428, 0.286, 0.444, 0.389, 0.167, 0.526, 0.316, 0.158, 0.375, 0.375, 0.25, 0.708, 0.25, 0.042, 0.231, 0.692, 0.077, 0.25, 0.375, 0.375))
dim(cptChl) <- c(3, 3, 2, 2)
dimnames(cptChl) <- list("Chl" = c("LOW", "MOD", "HIGH"), "Sal" = c("LOW", "MOD", "HIGH"), "HR" =  c("PRE", "POST"), "WT" = c("PRE", "POST"))
##Create Network
net = model2network("[HR][WT][Sal|HR:WT][Chl|HR:WT:Sal]")
plot(net)
##Assign CPTs to Network
dfit = custom.fit(net, dist = list(HR = cptHR, WT = cptWT, Sal = cptSal, Chl = cptChl))
dfit
#Get inferences
set.seed(1) 
cpquery(dfit, event = (Chl=="LOW"), evidence= (HR=="PRE"))

#Method 2: Using training data to define CPTs:
rm(list=ls())
##Load training data
TestData2 <- read_csv("~/NCEAS/TestData2.csv")
View(TestData2)
#Preparing the format of training data
HR<-as.factor(TestData2$HR)
WT<-as.factor(TestData2$WT)
Sal<-as.factor(TestData2$Sal)
Chl<-as.factor(TestData2$Chl)
bn_test <-data.frame(HR, WT, Sal, Chl)
#Create Network
net = model2network("[HR][WT][Sal|HR:WT][Chl|HR:WT:Sal]")
plot(net)
#Creating CPTs from data
fittedBN <- bn.fit(net, data=bn_test)
print(fittedBN$Chl)
#Get inferences
cpquery(fittedBN, event = (Chl=="LOW"), evidence= (HR=="PRE"))
