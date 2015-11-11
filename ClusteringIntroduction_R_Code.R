#Christy Casey
#2015-08-25
#
setwd("C:\\Your_Working_Directory_Here")

#The 3 objects being made are donuts/scones/pizza
#To give the items some spread on a graph they are  centered around a value
#Random sampling gives the variation 

Donuts_Total <- c(4.9,5,5.1)
#The total diameter of the donuts with a 0.1 error margin
Donuts_Hole <- c(0.9,1,1.1)
#The diameter of the hole of the donuts with a 0.1 error margin
NumberOfDonuts <- 12
#the number of donuts present
Donuts_Total_Sample <- sample(Donuts_Total,NumberOfDonuts,replace=T) 
#From the "Donuts_Total" take a number equal to "NumberOfDonuts", and place
#into the vector "Donuts_Total_Sample". replace = T allows the same value to 
#be picked more than once
Donuts_Hole_Sample <- sample(Donuts_Hole,NumberOfDonuts,replace=T) 
#The same procedure as above, but with the diameter of the hole as opposed
#to total diameter

Scone_Total <- c(2.9,3,3.1)
Scone_Hole <- c(0)
#There should be no hole in a scone, hence the value is simply zero
NumberOfScones <- 20
Scone_Total_Sample <- sample(Scone_Total,NumberOfScones,replace=T) 
Scone_Hole_Sample <- sample(Scone_Hole,NumberOfScones,replace=T)
#same as the donuts just with the scones

Pizza_Total <- c(9.9,10,10.1)
Pizza_Hole <- c(0)
NumberOfPizza <- 10
Pizza_Total_Sample <- sample(Pizza_Total,NumberOfPizza,replace=T) 
Pizza_Hole_Sample <- sample(Pizza_Hole,NumberOfPizza,replace=T)
#Again no change in methodology just another item

DataFrameOfValues <- as.data.frame(matrix(nrow=sum(NumberOfDonuts,NumberOfScones,NumberOfPizza)))
#create a martix with a number of rows equal to the total number of donuts/scones/pizzas
#convert to a dataframe using the "as.data.frame". And call this "DataFrameOfValues"
DataFrameOfValues[,'Total_Diameter'] <- c(Donuts_Total_Sample,Scone_Total_Sample,Pizza_Total_Sample)
#Create a new column called 'Total_Diameter". Add the samples obtain early to this col
DataFrameOfValues[,'Hole_Diameter'] <- c(Donuts_Hole_Sample,Scone_Hole_Sample,Pizza_Hole_Sample)
#Same as above but with the diameter of hole as opposed to total diameter
DataFrameOfValues <- DataFrameOfValues[,-1]
#remove the empty column form the creatation of the dataframe


plot(DataFrameOfValues)


#add in a 12 inch pizza

Large_Pizza_Total <- c(11.9,12,12.1)
Large_Pizza_Hole <- c(0)
NumberOfLarge_Pizza <- 5
Large_Pizza_Total_Sample <- sample(Large_Pizza_Total,NumberOfLarge_Pizza,replace=T) 
Large_Pizza_Hole_Sample <- sample(Large_Pizza_Hole,NumberOfLarge_Pizza,replace=T)


Small_Pizza_Total <- c(7.9,8,8.1)
Small_Pizza_Hole <- c(0)
NumberOfSmall_Pizza <- 5
Small_Pizza_Total_Sample <- sample(Small_Pizza_Total,NumberOfSmall_Pizza,replace=T) 
Small_Pizza_Hole_Sample <- sample(Small_Pizza_Hole,NumberOfSmall_Pizza,replace=T)


NewDataFrame <- DataFrameOfValues
for (i in 1:5){
  #5 here being the number of large pizza to be added to the data
  NewRow <- c(Large_Pizza_Total_Sample[i],Large_Pizza_Hole_Sample[i])
  #NewRow is a temporary variable which changes on each iteration
  NewDataFrame <- rbind(NewDataFrame,NewRow)
  #rbind adds the "NewRow" to the bottom of the data frame.
}

for (i in 1:5){
  NewRow <- c(Small_Pizza_Total_Sample[i],Small_Pizza_Hole_Sample[i])
  NewDataFrame <- rbind(NewDataFrame,NewRow)
}

plot(NewDataFrame)

NewDataFrame

#Name each of the data points, for visual presentation on graphs
DonutNames <-c()
for (i in 1:NumberOfDonuts){
DonutNames <- c(DonutNames,paste('Donut Number ',i,sep=''))
}
SconeNames <-c()
for (i in 1:NumberOfScones){
  SconeNames <- c(SconeNames,paste('Scone Number ',i,sep=''))
}
PizzaNames <-c()
for (i in 1:NumberOfPizza){
  PizzaNames <- c(PizzaNames,paste('Pizza Number ',i,sep=''))
}
Large_PizzaNames <-c()
for (i in 1:NumberOfLarge_Pizza){
  Large_PizzaNames <- c(Large_PizzaNames,paste('Large_Pizza Number ',i,sep=''))
}
Small_PizzaNames <-c()
for (i in 1:NumberOfSmall_Pizza){
  Small_PizzaNames <- c(Small_PizzaNames,paste('Small_Pizza Number ',i,sep=''))
}

RowNames <- c(DonutNames,SconeNames,PizzaNames,Large_PizzaNames,Small_PizzaNames)
#The order here is the same as the data was added to the data frame. This is imporant

rownames(NewDataFrame) <- RowNames
#Rename the rows by the RowNames made above

NewData_dist <- dist(NewDataFrame,diag = 'euclidean')
#Create a distance matrix

HeirarchicalClust_UPGMA <- (hclust(NewData_dist,method = 'average'))
#Cluster the distance matrix with average linkage method

plot(HeirarchicalClust_UPGMA)
#plot this average linkage tree

#save(list=ls(),file='IntroductionGraphs.Rdata')

HeirarchicalClust_ward <- (hclust(NewData_dist,method = 'ward.D'))
#again only the method of clustering changes
plot(HeirarchicalClust_ward)


HeirarchicalClust_ward2 <- (hclust(NewData_dist,method = 'ward.D2'))
plot(HeirarchicalClust_ward2)

HeirarchicalClust_single <- (hclust(NewData_dist,method = 'single'))
#The distnace matrix is already created, so the new clustering only changes the method
#by which the clustering is determined
plot(HeirarchicalClust_single)
#plots the clustering produced by the single linkage


Single_Method_Tree <- cutree(HeirarchicalClust_single,3)
Single_Method_Tree[Single_Method_Tree==1]



hclust()

library(fpc)
library(cluster)
Silhouette_k_3 <- silhouette(cutree(HeirarchicalClust_single,3),dist = NewData_dist)

??silhouette


VectorOfSilScores <- c()
for (k in 2:30){
  Silhouette_k <- silhouette(cutree(HeirarchicalClust_single,k),dist = NewData_dist)
  VectorOfSilScores <- c(VectorOfSilScores,mean(Silhouette_k[,'sil_width']))
  print(paste('Average silhouette score for ',k,' clusters is ',mean(Silhouette_k[,'sil_width']),sep=''))
}
plot(cbind(2:30,VectorOfSilScores))


VectorOfSilScores <- c()
for (k in 2:30){
  Silhouette_k <- silhouette(cutree(HeirarchicalClust_ward,k),dist = NewData_dist)
  VectorOfSilScores <- c(VectorOfSilScores,mean(Silhouette_k[,'sil_width']))
  print(paste('Average silhouette score for ',k,' clusters is ',mean(Silhouette_k[,'sil_width']),sep=''))
}
NumberOfClusters <- c(2:30)
plot(cbind(NumberOfClusters,VectorOfSilScores))

VectorOfSilScores <- c()
for (k in 2:30){
  Silhouette_k <- silhouette(cutree(HeirarchicalClust_UPGMA,k),dist = NewData_dist)
  VectorOfSilScores <- c(VectorOfSilScores,mean(Silhouette_k[,'sil_width']))
  print(paste('Average silhouette score for ',k,' clusters is ',mean(Silhouette_k[,'sil_width']),sep=''))
}
plot(cbind(2:30,VectorOfSilScores))


mean(Silhouette_k_3[,'sil_width'])

Single_Linkage_3_Clusters <- cutree(HeirarchicalClust_single,3)

plot(silhouette(Single_Linkage_3_Clusters,dist = NewData_dist)
  ,  nmax = 80, cex.names = 0.5)
for (k in 5:7){
  Single_Linkage_Clusters <- cutree(HeirarchicalClust_single,k)
  print(paste('cluster k size ',k,sep=''))
  for (clust in 1:k){
    print(Single_Linkage_Clusters[Single_Linkage_Clusters==clust])}}



clusGap(x = as.matrix(NewData_dist),K.max = 20,B = 10,FUNcluster = kmeans, verbose = interactive())











SampleGapStat <- clusGap(as.matrix(NewData_dist),kmeans,10,B=100,verbose=interactive())

xy <- as.matrix(NewData_dist)
title <- "Raw data"
par(mfrow=c(1,1))
#for (i in 1:2) {
gap <- SampleGapStat
k <- maxSE(gap$Tab[, "gap"], gap$Tab[, "SE.sim"], method="Tibs2001SEmax")
fit <- kmeans(xy, k)
pch <- ifelse(fit$cluster==1,24,16); col <- ifelse(fit$cluster==1,"Red", "Black")
plot(gap, main=paste("Gap stats,", title))
abline(v=k, lty=3, lwd=2, col="Blue")
xy <- apply(xy, 2, scale)
title <- "Standardized data"#}










library(mclust)
# Run the function to see how many clusters
# it finds to be optimal, set it to search for
# at least 1 model and up 20.

d_clust_g_50 <- Mclust(as.matrix(NewData_dist), G=1:50)
m.best <- dim(d_clust_g_50$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
plot(d_clust_g_50)

d_clust_g_40 <- Mclust(as.matrix(NewData_dist), G=1:40)
m.best <- dim(d_clust_g_40$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")


d_clust_g_30 <- Mclust(as.matrix(NewData_dist), G=1:30)
m.best <- dim(d_clust_g_30$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")


d_clust_g_20 <- Mclust(as.matrix(NewData_dist), G=1:20)
m.best <- dim(d_clust_g_20$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")


d_clust_g_10 <- Mclust(as.matrix(NewData_dist), G=1:10)
m.best <- dim(d_clust_g_10$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")






m.best <- dim(d_clust_g_10$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
m.best <- dim(d_clust_g_20$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
m.best <- dim(d_clust_g_30$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
m.best <- dim(d_clust_g_40$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
m.best <- dim(d_clust_g_50$z)[2]
cat("model-based optimal number of clusters:", m.best, "\n")
