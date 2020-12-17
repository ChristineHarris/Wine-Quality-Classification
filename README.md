# Wine-Quality-Classification

Within the wine industry, certification and quality assessment are conducted via physicochemical and sensory tests. Some of these sensory tests, such as taste and preference, are performed by wine experts and are therefore prone to a certain degree of subjectivity. Physicochemical tests, on the other hand, create objective measurements of a wine's properties (such as acidity and pH). The purpose of this analysis is to explore the degree to which these physicochemical tests on their own can predict wine quality, potentially prompting a reevaluation of the current system and heavy reliance on wine tasters.

## Data

In a 2009 study on wine quality classification, Paulo Cortez and his colleagues created two [datasets](https://archive.ics.uci.edu/ml/datasets/wine+quality) related to red and white variants of Portuguese "Vinho Verde" wine. The red wine dataset contains 1,599 instances and the white wine dataset contains 4,898 instances. 

The 11 input variables are the results of objective physicochemical tests: 
*   Fixed acidity (1)
*   Volatile acidity (2)
*   Citric acid (3)
*   Residual sugar (4)
*   Chlorides (5)
*   Free sulfur dioxide (6)
*   Total sulfur dioxide (7)
*   Density (8)
*   pH (9)
*   Sulphates (10)
*   Alcohol (11)

The output is based on sensory data: quality (12). Quality is represented by a score between 0 (very bad) and 10 (very excellent), and is determined by taking the median of at least three evaluations by wine experts. Due to privacy and logistical issues, only physicochemical (inputs) and sensory (output) variables are included in this data.

## Exploratory Data Analysis

Looking at the summary statistics for the variables in both data sets, it's clear that there are some significant differences in the physicochemical properties between red and white wines. For example, white wines typically contain much higher amounts of residual sugar than red wines. As such, separate classification models will be built for red and white wine.

![](/images/summary_statistics.PNG)


## Preprocessing

#### *Dichotomizing the Response*
The response variable, quality, is redefined as a factor in order to create a binary classification problem. Rather than a quantitative rating from 1 to 10, scores greater than or equal to 6 are classified as "good" and scores less than 6 are classified as "bad." The dataset is split into training and test sets according to a 70-30 split.

**NOTE:** The response variable was dichotomized in order for the analysis to correspond to project instructions (that is, to transform the problem into a binary classification problem). In general, dichotomizing the response variable is not recommended as valuable information contained in the data set will be lost. In this project, for example, red wine with a quality rating of 6 and a quality rating of 9 are both considered "good." That is, the distinction between a quality rating of 6 and a quality rating of 9 is deemed unimportant. In reality, this distinction is likely quite significant. 

#### *Feature Scaling*
The variables in this dataset have amplitudes of significant size. In addition, these physicochemical properties are recorded using several different units of measure, making them hard to compare. It is therefore inefficient to use the data in its original form. For the purposes of this analysis, the data is scaled to ensure that no one variables is more influential than the others. The data is scaled individually for each input variable. In this way, the mean value for each column will be 0 and the mean standard deviation will be 1.


#### *Feature Selection*
Recursive feature elimination was performed on both the white wine and red wine datasets in order to identify how many input variables should included in the classification models. After analyzing the backwards elimination plots for the two datasets, it is clear that both red and white wine classification models perform better when considering all of the potential input variables. These results corroborate Cortez’s finding that most of the physicochemical inputs are relevant to the classification of wine quality. As a result, all 11 input variables will be utilized in this analysis. Additionally, 

![](/images/feature_selection.PNG)

## Model Building


## Results

![](/images/results_accuracy.PNG)

![](/images/results_kappa.PNG)

## Sources

A. Nachev, and M. Hogan. Using Data Mining Techniques to Predict Product Quality from Physicochemical Data. *Proceedings on the International Conference on Artificial Intelligence (ICAI).* The Steering Committee of The World Congress in Computer Science, Computer Engineering and Applied Computing (WorldComp), 2013.

J. Sim, and C. Wright. The Kappa Statistic in Reliability Studies: Use, Interpretation, and Sample Size Requirements. *Journal of the American Physical Therapy Association,* 85(3): 257-268, 2005.

P. Appalasamy, A. Mustapha, N.D. Rizal, F. Johari, and A.F. Mansor. Classification-based Data Mining Approach for Quality Control in Wine Production. *Journal of Applied Sciences,* 12(6): 598-601, 2012.

P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis. Modeling wine preferences by data mining from physicochemical properties. *Decision Support Systems,* 47(4): 547-553, 2009.
