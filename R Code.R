##########################################################
############ Installing Relevant R Packages ##############
##########################################################

install.packages("corrplot")
library(corrplot)  

install.packages("caret")
library(caret)    

install.packages("klaR")
library(klaR)      

install.packages("nnet")
library(nnet)     

install.packages("kernlab")
library(kernlab)   

install.packages("randomForest")
library(randomForest)  

install.packages("gridExtra")
library(gridExtra) 

install.packages("e1071")
library(e1071)

install.packages("pROC")
library(pROC)

install.packages("doSNOW")
library(doSNOW)    
registerDoSNOW(makeCluster(3, type = 'SOCK'))

today=as.character(Sys.Date())

##########################################################
####################### WHITE WINE #######################
##########################################################

setwd("~/Desktop/STAT 5630/Final Project")
wine=read.csv("winequality-white.csv",header=T,sep=";")
summary(wine)

scaled=scale(wine[,1:11])
head(scaled)
apply(scaled,2,mean)
apply(scaled,2,sd)

##########################################################
################# Pre Processing Steps ###################
##########################################################

scaled=as.data.frame(scaled)
scaled$quality=wine$quality
head(scaled)

class(scaled$quality)
scaled$quality=as.numeric(scaled$quality)
good_ones=scaled$quality>=6
bad_ones=scaled$quality<6
scaled[good_ones,'quality']='good'
scaled[bad_ones,'quality']='bad'  
scaled$quality=as.factor(scaled$quality)
class(scaled$quality)
head(scaled$quality)

dummies=dummyVars(quality~.,data=scaled)
wine_dummied=data.frame(predict(dummies,newdata=scaled))
wine_dummied[,'quality']=scaled$quality

set.seed(3011)
trainIndices=createDataPartition(wine_dummied$quality,p=0.7,list=FALSE)
train=wine_dummied[trainIndices,]
test=wine_dummied[-trainIndices,]

##########################################################
######## Feature Selection by Backward Elimination #######
##########################################################

fitControl_rfe=rfeControl(functions=rfFuncs,method='cv',number=5) 
fit_rfe=rfe(quality~.,data=train,sizes=c(1:10),rfeControl=fitControl_rfe)
features=predictors(fit_rfe) 
max(fit_rfe$results$Accuracy) # [1] 0.8127793

png(paste0(today,'-','recursive-feature-elimination-white.png'))
plot(fit_rfe,type=c('g','o'),main='Recursive Feature Elimination')
dev.off()

##########################################################
####################### Resampling #######################
##########################################################

fitControl=trainControl(method='cv',number=5)

##########################################################
############# Logistic Regression (GLM) ##################
##########################################################

fit_glm=train(x=train[,features],y=train$quality,method='glm',preProcess='range',trControl=fitControl) 
predict_glm=predict(fit_glm,newdata=test[,features])
confMat_glm=confusionMatrix(predict_glm,test$quality,positive='good')
importance_glm=varImp(fit_glm,scale=TRUE)

png(paste0(today,'-','importance-glm-white.png'))
plot(importance_glm,main='Feature importance for Logistic Regression')
dev.off()

##########################################################
######## Support Vector Machines (Linear Kernel) #########
##########################################################

fit_svm=train(x=train[,features],y=train$quality,method='svmLinear',preProcess='range',trControl=fitControl,
              tuneGrid=expand.grid(.C=c(0.001,0.01,0.1,1,10,100,1000)))
predict_svm=predict(fit_svm,newdata=test[,features])
confMat_svm=confusionMatrix(predict_svm,test$quality,positive='good')
importance_svm=varImp(fit_svm,scale=TRUE)

png(paste0(today, '-', 'importance-svm-white.png'))
plot(importance_svm, main = 'Feature importance for SVM-Linear')
dev.off()

##########################################################
#### Support Vector Machines (Radial Basis Function) #####
##########################################################

fit_svmRBF=train(x=train[,features],y=train$quality,method='svmRadial',preProcess='range',trControl=fitControl,
                 tuneGrid=expand.grid(.C=c(0.001,0.01,0.1,1,10,100,1000),.sigma=c(0.001,0.01,0.1)))
predict_svmRBF=predict(fit_svmRBF,newdata=test[,features])
confMat_svmRBF=confusionMatrix(predict_svmRBF,test$quality,positive='good')
importance_svmRBF=varImp(fit_svmRBF,scale=TRUE)

png(paste0(today,'-','importance-svm-rbf-white.png'))
plot(importance_svmRBF,main='Feature importance for SVM-RBF')
dev.off()

##########################################################
############## Neural Networks (NNet) ####################
##########################################################

fit_nnet=train(x=train[,features],y=train$quality,method='nnet',preProcess='range',trControl=fitControl,
               tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(0,0.001,0.1)),trace=FALSE,maxit=1000)   
predict_nnet=predict(fit_nnet,newdata=test[,features],type='raw')
confMat_nnet=confusionMatrix(predict_nnet,test$quality,positive='good')
importance_nnet=varImp(fit_nnet,scale=TRUE)

png(paste0(today,'-','importance-nnet-white.png'))
plot(importance_nnet,main='Feature importance for NNet')
dev.off()

##########################################################
############# Neural Networks (AvNNet) ###################
##########################################################

fit_avNnet=train(x=train[,features],y=train$quality,method='avNNet',preProcess='range',trControl=fitControl,
                 tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(0,0.001,0.1),.bag=FALSE),trace=FALSE,maxit=1000)
predict_avNnet=predict(fit_avNnet,newdata=test[,features])
confMat_avNnet=confusionMatrix(predict_avNnet,test$quality,positive='good')
importance_avNnet=varImp(fit_avNnet,scale=TRUE)

png(paste0(today,'-','importance-avnnet-white.png'))
plot(importance_avNnet,main='Feature importance for avNnet')
dev.off()

##########################################################
################# Random Forest (RF) #####################
##########################################################

fit_rf=train(x=train[,features],y=train$quality,method='rf',trControl=fitControl,
             tuneGrid=expand.grid(.mtry=c(2:6)),n.tree=1000) 
predict_rf=predict(fit_rf,newdata=test[,features])
confMat_rf=confusionMatrix(predict_rf,test$quality,positive='good')
importance_rf=varImp(fit_rf,scale=TRUE)

png(paste0(today,'-','importance-rf-white.png'))
plot(importance_rf,main='Feature importance for Random Forest')
dev.off()

##########################################################
################## Method Comparison #####################
##########################################################

models=resamples(list(GLM=fit_glm,SVM=fit_svm,SVM_RBF=fit_svmRBF,
                      NNet=fit_nnet,AvgNNet=fit_avNnet,RF=fit_rf))
png(paste0(today,'-','models-comparison-white.png'))
dotplot(models)
dev.off()

results=summary(models)
png(paste0(today, '-','models-accuracy-white.png'),width=480,height=240)
grid.table(results$statistics$Accuracy)
dev.off()

png(paste0(today,'-','models-kappa-white.png'),width=480,height=240)
grid.table(results$statistics$Kappa)
dev.off()

##########################################################
####################### RED WINE #########################
##########################################################

wine=read.csv("winequality-red.csv",header=T,sep=";")
summary(wine)

scaled=scale(wine[,1:11])
head(scaled)
apply(scaled,2,mean)
apply(scaled,2,sd)

##########################################################
################# Pre Processing Steps ###################
##########################################################

scaled=as.data.frame(scaled)
scaled$quality=wine$quality
head(scaled)

class(scaled$quality)
scaled$quality=as.numeric(scaled$quality)
good_ones=scaled$quality>=6
bad_ones=scaled$quality<6
scaled[good_ones,'quality']='good'
scaled[bad_ones,'quality']='bad'  
scaled$quality=as.factor(scaled$quality)
class(scaled$quality)
head(scaled$quality)

dummies=dummyVars(quality~.,data=scaled)
wine_dummied=data.frame(predict(dummies,newdata=scaled))
wine_dummied[,'quality']=scaled$quality
set.seed(1234) 
trainIndices=createDataPartition(wine_dummied$quality,p=0.7,list=FALSE)
train=wine_dummied[trainIndices,]
test=wine_dummied[-trainIndices,]

##########################################################
######## Feature Selection by Backward Elimination #######
##########################################################

fitControl_rfe=rfeControl(functions=rfFuncs,method='cv',number=5) 
fit_rfe=rfe(quality~.,data=train,sizes=c(1:10),rfeControl=fitControl_rfe)
features=predictors(fit_rfe) 
max(fit_rfe$results$Accuracy) # [1] 0.7981807

png(paste0(today,'-','recursive-feature-elimination-red.png'))
plot(fit_rfe,type=c('g','o'),main='Recursive Feature Elimination')
dev.off()

##########################################################
####################### Resampling #######################
##########################################################

fitControl=trainControl(method='cv',number=5)

##########################################################
############# Logistic Regression (GLM) ##################
##########################################################

fit_glm=train(x=train[,features],y=train$quality,method='glm',preProcess='range',trControl=fitControl) 
predict_glm=predict(fit_glm,newdata=test[,features])
confMat_glm=confusionMatrix(predict_glm,test$quality,positive='good')
importance_glm=varImp(fit_glm,scale=TRUE)

png(paste0(today,'-','importance-glm-red.png'))
plot(importance_glm,main='Feature importance for Logistic Regression')
dev.off()

##########################################################
######## Support Vector Machines (Linear Kernel) #########
##########################################################

fit_svm=train(x=train[,features],y=train$quality,method='svmLinear',preProcess='range',trControl=fitControl,
              tuneGrid=expand.grid(.C=c(0.001,0.01,0.1,1,10,100,1000)))
predict_svm=predict(fit_svm,newdata=test[,features])
confMat_svm=confusionMatrix(predict_svm,test$quality,positive='good')
importance_svm=varImp(fit_svm,scale=TRUE)

png(paste0(today, '-', 'importance-svm-red.png'))
plot(importance_svm, main = 'Feature importance for SVM-Linear')
dev.off()

##########################################################
#### Support Vector Machines (Radial Basis Function) #####
##########################################################

fit_svmRBF=train(x=train[,features],y=train$quality,method='svmRadial',preProcess='range',trControl=fitControl,
                 tuneGrid=expand.grid(.C=c(0.001,0.01,0.1,1,10,100,1000),.sigma=c(0.001,0.01,0.1)))
predict_svmRBF=predict(fit_svmRBF,newdata=test[,features])
confMat_svmRBF=confusionMatrix(predict_svmRBF,test$quality,positive='good')
importance_svmRBF=varImp(fit_svmRBF,scale=TRUE)

png(paste0(today,'-','importance-svm-rbf-red.png'))
plot(importance_svmRBF,main='Feature importance for SVM-RBF')
dev.off()

##########################################################
############## Neural Networks (NNet) ####################
##########################################################

fit_nnet=train(x=train[,features],y=train$quality,method='nnet',preProcess='range',trControl=fitControl,
               tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(0,0.001,0.1)),trace=FALSE,maxit=1000)   
predict_nnet=predict(fit_nnet,newdata=test[,features],type='raw')
confMat_nnet=confusionMatrix(predict_nnet,test$quality,positive='good')
importance_nnet=varImp(fit_nnet,scale=TRUE)

png(paste0(today,'-','importance-nnet-red.png'))
plot(importance_nnet,main='Feature importance for NNet')
dev.off()

##########################################################
############# Neural Networks (AvNNet) ###################
##########################################################

fit_avNnet=train(x=train[,features],y=train$quality,method='avNNet',preProcess='range',trControl=fitControl,
                 tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(0,0.001,0.1),.bag=FALSE),trace=FALSE,maxit=1000)
predict_avNnet=predict(fit_avNnet,newdata=test[,features])
confMat_avNnet=confusionMatrix(predict_avNnet,test$quality,positive='good')
importance_avNnet=varImp(fit_avNnet,scale=TRUE)

png(paste0(today,'-','importance-avnnet-red.png'))
plot(importance_avNnet,main='Feature importance for avNnet')
dev.off()

##########################################################
################# Random Forest (RF) #####################
##########################################################

fit_rf=train(x=train[,features],y=train$quality,method='rf',trControl=fitControl,
             tuneGrid=expand.grid(.mtry=c(2:6)),n.tree=1000) 
predict_rf=predict(fit_rf,newdata=test[,features])
confMat_rf=confusionMatrix(predict_rf,test$quality,positive='good')
importance_rf=varImp(fit_rf,scale=TRUE)

png(paste0(today,'-','importance-rf-red.png'))
plot(importance_rf,main='Feature importance for Random Forest')
dev.off()

##########################################################
################## Method Comparison #####################
##########################################################

models=resamples(list(GLM=fit_glm,SVM=fit_svm,SVM_RBF=fit_svmRBF,
                      NNet=fit_nnet,AvgNNet=fit_avNnet,RF=fit_rf))
png(paste0(today,'-','models-comparison-red.png'))
dotplot(models)
dev.off()

results=summary(models)
png(paste0(today, '-','models-accuracy-red.png'),width=480,height=240)
grid.table(results$statistics$Accuracy)
dev.off()

png(paste0(today,'-','models-kappa-red.png'),width=480,height=240)
grid.table(results$statistics$Kappa)
dev.off()
