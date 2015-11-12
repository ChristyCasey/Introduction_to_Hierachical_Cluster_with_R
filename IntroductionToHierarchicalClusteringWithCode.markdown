#Introduction to hierarchical clustering with R


##**Sample Data**

Clustering is a technique for classifying data. It is most easily considered using the traditional Cartesian graph. To quickly demonstrate my point I would like to propose a hypothetical scenario. A factory produces an unknown number of different circular objects. Measurements are available for two aspects of these objects. The total diameter of the object, and the diameter of this central hole. Below is a table of the contrived data;

Total diameter | Central hole diameter | Number of objects
---------------|-----------------------|------------------
5 inches | 1 inches | 12
10 inches | 0 inches | 10
3 inches | 0 inches | 20

*Table 1; a table of hypothetical values, solely for demonstration purposes.*

```{r}
#For anybody unfamiliar, code will appear in this format
#while a pound-sign/hash-tag preceding a scentence dictates it is comment about the code within R

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
#From the 'Donuts_Total' take a number equal to 'NumberOfDonuts', and place
#into the vector 'Donuts_Total_Sample'. replace = T allows the same value to 
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
```

```{r}
#Create a dataframe to hold these values

DataFrameOfValues <- as.data.frame(matrix(nrow=sum(NumberOfDonuts,NumberOfScones,NumberOfPizza)))
#create a martix with a number of rows equal to the total number of donuts/scones/pizzas
#convert to a dataframe using the 'as.data.frame'. And call this 'DataFrameOfValues'
DataFrameOfValues[,'Total_Diameter'] <- c(Donuts_Total_Sample,Scone_Total_Sample,Pizza_Total_Sample)
#Create a new column called 'Total_Diameter'. Add the samples obtain early to this col
DataFrameOfValues[,'Hole_Diameter'] <- c(Donuts_Hole_Sample,Scone_Hole_Sample,Pizza_Hole_Sample)
#Same as above but with the diameter of hole as opposed to total diameter
DataFrameOfValues <- DataFrameOfValues[,-1]
#remove the empty column form the creatation of the dataframe


#This data can be plotted to produce a graph like figure 1
#Although may look slightly different due to the random nature of the resampling

plot(DataFrameOfValues)
```

![Figure 1](Images/image001.png?raw=true)

*Figure 1; For the graph a margin of error of 0.1 was introduced in the data. This was primarily to avoid all the points being stacked on each other, while still keeping the clustering quite tight.*

When viewing the data of this two variables on a Cartesian plot we see groups of datum. Those groups are clusters of the data. From this I spectate that there is 3 distinct clusters. Each of these is actually a food. The foods are donuts, pizza, and scones, respective to order in the table. An argument could also be made for the classification of the datum into two distinct clusters, those who have and do not have a hole. However I would argue that the resulting cluster of pizza and scones is a poor cluster, as it entire overlaps the donut cluster in one axis.
Using these measurements, it is now possible to classify new data and sort them according to the attributes they possess. So if an item, which was made incorrectly, and had a total diameter of 2 inches was found, it could be either a scone or a donut, by examining the diameter of the central it should become clear into which category to place it.  Another example would be the variety in pizza sizes. The size would likely differ enough from the other objects in order for the pizza of a new size to be grouped with the current pizza cluster. With enough pizza differing in size, new cluster may be formed, allowing the sub-classification of pizzas into small, medium, and large for instance.

```{r}
#To create a less 'obvious' cluster, the pizza group is expanded
# so as it now includes large medium (already present) and small pizzas

#add in the large (12 inch) pizza

Large_Pizza_Total <- c(11.9,12,12.1)
Large_Pizza_Hole <- c(0)
NumberOfLarge_Pizza <- 5
Large_Pizza_Total_Sample <- sample(Large_Pizza_Total,NumberOfLarge_Pizza,replace=T) 
Large_Pizza_Hole_Sample <- sample(Large_Pizza_Hole,NumberOfLarge_Pizza,replace=T)

#add in the small (9 inch) pizza
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
  #rbind adds the 'NewRow' to the bottom of the data frame.
}

for (i in 1:5){
  #same thing for the small pizzas
  NewRow <- c(Small_Pizza_Total_Sample[i],Small_Pizza_Hole_Sample[i])
  NewDataFrame <- rbind(NewDataFrame,NewRow)
}

plot(NewDataFrame) #produces figure 2
```


![Figure 2](Images/image002.png?raw=true)

*Figure 2; New values were added, this were the small pizza, centred around 8 inches, and the large pizza centred around 12 inches.*

##**Clustering the data**

Hierarchical clustering methods are able to make use a distance matrix to categorise which data is closest to which. The most commonly used measure for this is the Euclidean distance, or the square Euclidean distance, which as the name suggests is the same as the prior, merely squared. This distance allows the expression of points which span multiple dimensions in a single dimension. Where each point has a distance to all other points. The set of these distances is the called the distance matrix. The hierarchical clustering builds its clusters based on the relation of the points to each other using this as its reference. 

To save on the number of computations needed the demonstration of the distance matrix creation, only the values from the original table, and not the ones with the margin of error included. The method of calculating the distance between two points is the Euclidean distance. 

![*Equation 1*](Images/image003.png?raw=true)

As there is only two variables in the example being used here the equation will only expand to n=2 in the calculations shown. The distance between a point and itself will be zero. On the distance matrix table this lies on the diagonal. To begin with this distance is filled in first.
The distances that need to be calculated are Donut-Scones Donut-Pizza, and Scones-Pizza

Donut-Scones;

![*Calculation 1;* ](Images/image006.png?raw=true)

= 2.236

Donut-Pizza;

![*Calculation 2;*](Images/image007.png?raw=true)

 = 5.099

Scone-Pizza; 

![*Calculation 3;* ](Images/image009.png?raw=true)

= 7

Using these values the rest of the distance matrix is made


Dist. Matrix | Donut | Scones | Pizza
-------|-------|--------|-------
Donut | 0 | |
Scones | 2.236 | 0 |
Pizza | 5.099 | 7 | 0

*Table 2; the completed distance matrix. Note the zero values along the diagonal.*

If this were to be clustered the using the UPGMA method the average of the distances would be taken for 2 objects to be paired. The ones which are selected are those that are already the closest. In the above table it would be Pizza-Scones. The distance they are to the other objects in the table are removed, and replaced by a profile. This is the average of the distance to the other object, in this case Donuts. The example distance matrix is shown below.


Dist. Matrix | Donut | Scones/Pizza
-------|-------|---------
Donut | 0 |	
Scones/Pizza | 3.6675 | 0

*Table 3; a distance matrix after a profile had been created.*

This is of course just for demonstration stake. As stated earlier the 3 clusters for this data appears to be the best fit. As such there is no need to include this amalgamation. Using a function in R, which follows the same procedure as outline here, was applied to the expanded dataset. Including the small and large pizzas. The method of producing the profiles was the 'average' or UPGMA (Unweighted Pair Group Method with Arithmetic Mean), as it is also known by. The resulting tree is shown below. As expected the small and large pizzas grouped with the original pizza sample. While two other distinct groups are the scone and donut samples.

```{r}
#This code gives meaningful names to individual data points
#And uses euclidean distances to create a distance matrix

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
#plot this average linkage tree (figure 3)
```

###**Average linkage**

![Figure 3](Images/image011.png?raw=true)

*Figure 3; A tree of the hierarchical clustering of the hypothetical data, using average linkage.*

In hierarchical clustering to access the clusters, the tree is cut and the components of the resulting clades are the clusters. In the given example the most obvious selection to me would be 4 clades, or clusters. However this does not give the clustering that would be expected when looking at the groups. The obvious clusters are the pizza (small medium and large all clustered together), scones and donuts. This raises the question of why the clustering is not like this. The average linking method used creates a grouping between the medium pizza and either the large or small pizza, with these being the smallest distance. The resulting profile is however is stretched away from the medium. Causing the next smallest distance to be the scones donuts. Despite the fact it is obvious to the human eye to expand the pizza cluster rather than create a donut/scone cluster.

###**Single Linkage**

To avoid this an alternative method to UPGMA should be used. Given the explanation of why the clusters divided the way they did a more appropriate method of building the tree would be single linkage. Where UPGMA would use the average of the clusters, and pair this with the nearest neighbour based on these averages, the single linkage method pairs clusters based on the shortest distance between two components of the clusters. This means that where the average of the medium pizza and the small large pizza is was pulled away from the medium, which would have been the ideal medium of the larger all-inclusive pizza cluster, it will no longer affect the large pizza grouping with this cluster. As the short distance between the medium pizza and the large pizza is no longer ignored in favour of the average of the small and medium pizza profile. The single linkage method also does not create a distinction in the relation of the small and large pizza to the medium pizza as the UPGMA method had.

```{r}
HeirarchicalClust_single <- (hclust(NewData_dist,method = 'single'))
#The distnace matrix is already created, so the new clustering only changes the method
#by which the clustering is determined
plot(HeirarchicalClust_single)
#plots the clustering produced by the single linkage (figure 4)
```

![Figure 4](Images/image013.png?raw=true)

*Figure 4; The same data as the earlier previous tree but not clustered using single linkage methodology.*

###**Wards Linkage**

 Another method to determine how the tree would be formed is via wards methods. Or wards linkage. This method, similar to the other mentioned methods, takes the clusters of minimum distance and fuses them, to create a new cluster. It is of course in the definition of this distance. Wards method defines the distance as the sum of variances created by joining the clusters. As such the selection of the shortest distance makes wards method one which minimises the variance in the tree. The clustering from this method appears more appropriate as seen the increased difference in the heights of the pizza cluster and non pizza clusters clade.

```{r}
HeirarchicalClust_ward <- (hclust(NewData_dist,method = 'ward.D'))
#again only the method of clustering changes
plot(HeirarchicalClust_ward)
#Produces the plot for figure 5
```
![Figure 5](Images/image015.png?raw=true)

*Figure 5; The simulated data clustered with wards method. Showing a more appropriate clustering pattern.*

##***Clustering scores***

###**Silhouette Method**

	
 Various methods exist to evaluate goodness of a cluster. These methods are often to estimate the ideal number of clusters as well, by estimate the validity of each cluster at various values of k and returning the average of the clusters scores. By using this average score, a glimpse is given into the overall validity of the clusters as a whole, and thus gives estimates on the appropriate value of k to be used. 
The silhouette method was first described by Rousseuw in 1986. The silhouette method measures the similarity of the clusters data points to each other, and the dissimilarity of the points to the centre of the nearest cluster to that point. 

![Equation 2](Images/image017.png?raw=true)

*Where a(i) is the average dissimilarity of i, with its own cluster, and  b(i) is the dissimilarity of i and the closest point to i which is not part of its cluster.*

```{r}
#The following packages are loaded in order to use silhouette function
library(fpc)
library(cluster)

#To test a range of different number of clusters as solutions, we use a range of k
#k is commonly used to refer to the number of clusters the data is divided into

VectorOfSilScores <- c()
#creates an empty vector to put the scores of the silhouettes into
for (k in 2:30){
  #iterate over a range of k = 2, to k = 30
  Silhouette_k <- silhouette(cutree(HeirarchicalClust_single,k),dist = NewData_dist)
  #for the given value of k use the 'silhouette' function to get a score for that value of k
  #when using hierachical we 'cut the tree' to detemerine the number of clusters (k) 
  VectorOfSilScores <- c(VectorOfSilScores,mean(Silhouette_k[,'sil_width']))
  #store this cluster silhouette cluster in the vector
  print(paste('Average silhouette score for ',k,' clusters is ',mean(Silhouette_k[,'sil_width']),sep=''))
}
plot(cbind(2:30,VectorOfSilScores))
#plot the average silhouette scores vs the value of k (figure 6)
```

![Figure 6](Images/image020.png?raw=true)

*Figure 6; A figure of the average silhouette scores for the number of cluster included in the model. A higher score is better. 1 is highest possible score*

Examining the figure of scores vs the number of clusters it is apparent that the method suggest that the best model uses a cluster number of 7, with 5 being a close second. While 6 has a noticeable drop off in comparison but would still be a decent classification for the data. The high score for 5 is expected as there is five values around which each set of data is centred. The value of 3 clusters is still seen to be quite high as it clustering of the small and large pizza with the medium pizza, does not cause the too much dissimilarity in the cluster, but obviously more is created than the  when it is divided into its 5 clusters. High values are again seen at k = 7. This is dividing the scones in into multiple clusters. It is only via human intuition that this can be spotted and accounted for.

**Gap Statistic**

```{r}
#this is a slightly modified version of code found from;
# http://stackoverflow.com/questions/15376075/cluster-analysis-in-r-determine-the-optimal-number-of-clusters
# control + f 'Gap Statistic' for the revelant section
# the paper (Tibshirani *et al*, 2001) outlining this method can be found at
# https://web.stanford.edu/~hastie/Papers/gap.pdf

SampleGapStat <- clusGap(as.matrix(NewData_dist),kmeans,10,B=100,verbose=interactive())

xy <- as.matrix(NewData_dist)
title <- 'Raw data'

gap <- SampleGapStat
k <- maxSE(gap$Tab[, 'gap'], gap$Tab[, 'SE.sim'], method='Tibs2001SEmax')
fit <- kmeans(xy, k)
pch <- ifelse(fit$cluster==1,24,16); col <- ifelse(fit$cluster==1,'Red', 'Black')
plot(gap, main=paste('Gap stats,', title))
abline(v=k, lty=3, lwd=2, col='Blue')
xy <- apply(xy, 2, scale)
title <- 'Standardized data'
```


The gap statistic was proposed by Tibshirani et al, as formalised method for the “elbow method” heuristic of choosing the optimal cluster size. The graph is highlights the most optimal point with the broken vertical blue line. The criteria for selecting a point is twofold. First the data is compared to a reference distribution to see if any clustering is appropriated. If not the “optimal” cluster is decided to be zero. For data where the clustering is appropriate the value of k chosen is the lowest value of k which differs from k+1 by at least one standard error. In figure 8 this is difficult to see clearly. However a careful examinations shows that the points are indeed one standard error apart. 

![Figure 7](Images/image022.png?raw=true)

*Figure 7; A graphical output of the gap statistic applied to the data. The broken blue line shows the value of k which the gap statistic considers he best. Here it is 3.*

