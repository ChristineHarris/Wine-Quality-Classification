# Wine-Quality-Classification

This project compares the power of six different techniques - Logistic Regression (GLM), Support Vector Machines (SVM), Support Vector Machines with Radial Basis Function
(SVM-RBF), Neural Networks (NNet), Neural Networks Average (AvgNN), and Random Forest (RF) - to predict the quality of wine based solely on physicochemical properties.

## Data

In a 2009 study on wine quality classification, Paulo Cortez and his colleagues created two [datasets](https://archive.ics.uci.edu/ml/datasets/wine+quality) related to red and white variants of Portuguese “Vinho Verde” wine. The red wine dataset contains 1,599 instances and the white wine dataset contains 4,898 instances. 

There 11 input variables include objective tests: 
*   fixed acidity (1)
*   volatile acidity (2)
*   citric acid (3)
*   residual sugar (4)
*   chlorides (5)
*   free sulfur dioxide (6)
*   total sulfur dioxide (7)
*   density (8)
*   pH (9)
*   sulphates (10)
*   alcohol (11)

The output is based on sensory data: quality (12). The output is represented by a score between 0 (very bad) and 10 (very excellent), and is determined by taking the median of at least three evaluations by wine experts. Due to privacy and logistical issues, only physicochemical (inputs) and sensory (output) variables are included in this data.

## Exploratory Data Analysis



## Preprocessing



## Model Building


## Results


## Sources

A. Nachev, and M. Hogan. Using Data Mining Techniques to Predict Product Quality from Physicochemical Data. *Proceedings on the International Conference on Artificial Intelligence (ICAI).* The Steering Committee of The World Congress in Computer Science, Computer Engineering and Applied Computing (WorldComp), 2013.

J. Sim, and C. Wright. The Kappa Statistic in Reliability Studies: Use, Interpretation, and Sample Size Requirements. *Journal of the American Physical Therapy Association,* 85(3): 257-268, 2005.

P. Appalasamy, A. Mustapha, N.D. Rizal, F. Johari, and A.F. Mansor. Classification-based Data Mining Approach for Quality Control in Wine Production. *Journal of Applied Sciences,* 12(6): 598-601, 2012.

P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis. Modeling wine preferences by data mining from physicochemical properties. *Decision Support Systems,* 47(4): 547-553, 2009.
