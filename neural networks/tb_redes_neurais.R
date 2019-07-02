#neural networks homework
#this work has the goal to train a neural network 
#to verify the kind of eating to you deslike
library('neuralnet')

#separing set train and set test from csv file
#this set contain 81 exemples
#contain 8 questions 5 class of out
#the elements are variable from -3 fom 0 

table = read.table('set_of_train_and_test.csv', header = T, sep = ';', stringsAsFactors = F)
#shuffleing lines to get more mixed
shuffle_table = table[sample(nrow(table)),]

#geting set o train end test shuffled
train = shuffle_table[1:60 , ]
test =  shuffle_table[61:81, ]

#normalizing sets intervals from -3,0 to 0,1 
train[, 1:8] = (train[, 1:8] - min(shuffle_table))/4
test[, 1:8] = (test[, 1:8]- min(shuffle_table))/4

names = names(table)

#creating formula to put it into neurauralnet function 
f = as.formula(paste(paste(names[9:13], collapse = '+'), '~',paste(names[1:8], collapse = '+')))

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


