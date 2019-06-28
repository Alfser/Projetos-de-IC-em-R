#learning exemple neural network in R

install.packages("neuralnet")
library(neuralnet)

#creating train data set
TKS = c(20, 10 ,30, 20, 80, 30)
CSS = c(90, 20, 40, 50, 50, 80)
placed = c(1,0,0,1,1)

#Here, you will combine multiple columns or feature into a single set of data

df = data.frame(TKS, CSS, placed)

require(neuralnet)

nn = neuralnet(placed~TKS+CSS, data = df, hidden = 3, act.fct = "logistic", linear.output = FALSE)

plot(nn)


#creating test set

TKS = c(30, 40, 85)
CSS = c(85, 50, 40)

test = data.frame(TKS, CSS)

##Predicting using neural network
Predict = compute(nn, test)
Predict$net.rersult

##converting probability into a binary classes
prob = Predict$net.result
pred = ifelse(prob>0.5, 1, 0)

pred


