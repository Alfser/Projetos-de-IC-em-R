#neural networks homework
#this work has the goal to train a neural network 
#to verify the kind of eating to you deslike
library('neuralnet')

#separing set train and set test from csv file 
table = read.table('set_of_test_train.csv', header = T, sep = ';', stringsAsFactors = F)
train = table[1:15 , ]
test =  table[16:20, ]

#normalizing sets
train[, 1:8] = train[, 1:8]/3
test[, 1:8] = test[, 1:8]/3

names = names(table)

#creating formula to put it into neurauralnet function 
f = as.formula(paste(paste(names[9:11], collapse = '+'), '~',paste(names[1:8], collapse = '+')))

nn = neuralnet(formula = f, data = train, hidden = c(5,5), act.fct = 'logistic', linear.output = F)

#seeing error
nn$result.matrix[1:3, ]

plot(nn)

#making test
r = compute(nn, test[1:8])

#compariong neural network responses with correct outcomes
a = data.frame(rede = max.col(r$net.result))
prob = r$net.result

a$test = max.col(test[, 9:11])
a$erro = (abs(a$rede - a$test))
qtd = sum(a$erro != 0)
percent = (qtd/nrow(test))*100
print(paste('error perrcente : ', percent, '%'))

plot(a$test, col = 'green', pch = 20, ylim = c(0.5,4.5))
par(new = T)
plot(a$rede, col = 'red', ylim = c(0.5, 4.5))


