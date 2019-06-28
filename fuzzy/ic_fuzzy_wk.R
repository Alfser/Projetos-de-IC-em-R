##this is an coputional inteligence work
##this work will build a system that verify
##if a elderly person is so prone to develop a heart problem


library(sets)

##sets that will be a universe of variables
sets_options("universe", seq(from = 0, to = 900, by = 0.1))

##variables to ralational in fuzzy logic

##veryfy if the person do often exercise in the week
exercicio_fisico = fuzzy_variable(pouco = fuzzy_cone_gset(center = 0, radius = 3, universe = 0:7),
                                  as_vezes = fuzzy_cone_gset(center = 3, radius = 3, universe = 0:7),
                                  regularmente = fuzzy_trapezoid_gset(corners = c(4, 6, 7, 9), universe =0:7)
                                  ) 
  
##vrify if the person eat so vegetables ande fruits
come_frutas_legumes = fuzzy_variable(pouco = fuzzy_normal_gset(mean = 0, sd = 100),
                                     
                                     as_vezes = fuzzy_normal_gset(400, 100),
                                     
                                     sempre = fuzzy_normal_gset(800, 100)
                                     )  

##verify how many time the person stop smoking
parou_fumo = fuzzy_variable(a_pouco_tempo = fuzzy_trapezoid_gset(corners = c(0, 3, 5, 7), universe = 0:16),
                      
                            a_um_tempo = fuzzy_trapezoid_gset(corners = c(5, 8, 10, 14), universe = 0:16),
                      
                            bastante_tempo = fuzzy_trapezoid_gset(c(9, 14, 16, 20), universe = 0:16)
                           )

##prediction if is possible the person to has a heart problem 
heart_problem = fuzzy_partition(varnames = c(risco_baixo = 0, risco_medio = 40, risco = 70, risco_alto = 100), sd = 10, universe = 0:100)
variables <- set(exercicio_fisico, come_frutas_legumes, parou_fumo, heart_problem)


##relations or rules of fuzzy logic system
rules = set( fuzzy_rule(exercicio_fisico %is% pouco && come_frutas_legumes %is% pouco && parou_fumo %is% a_pouco_tempo, heart_problem %is% risco_alto),
              
              fuzzy_rule(exercicio_fisico %is% pouco && come_frutas_legumes %is% as_vezes && parou_fumo %is% a_um_tempo, heart_problem %is% risco),
              
              fuzzy_rule(exercicio_fisico %is% as_vezes && come_frutas_legumes %is% pouco && parou_fumo %is% bastante_tempo, heart_problem %is% risco_medio),
              
              fuzzy_rule(exercicio_fisico %is% pouco && come_frutas_legumes %is% pouco && parou_fumo %is% a_um_tempo, heart_problem %is% risco),
              
              fuzzy_rule(exercicio_fisico %is% as_vezes && come_frutas_legumes %is% pouco && parou_fumo %is% a_pouco_tempo, heart_problem %is% risco),
              
              fuzzy_rule(exercicio_fisico %is% as_vezes && come_frutas_legumes %is% pouco && parou_fumo %is% a_um_tempo, heart_problem %is% risco_medio),
              
              fuzzy_rule(exercicio_fisico %is% as_vezes && come_frutas_legumes %is% as_vezes && parou_fumo %is% a_um_tempo, heart_problem %is% risco_medio),
                          
              fuzzy_rule(exercicio_fisico %is% pouco && come_frutas_legumes %is% as_vezes && parou_fumo %is% a_pouco_tempo, heart_problem %is% risco),
              
              fuzzy_rule(exercicio_fisico %is% regularmente && come_frutas_legumes %is% as_vezes && parou_fumo %is% a_pouco_tempo, heart_problem %is% risco_medio),
              
              fuzzy_rule(exercicio_fisico %is% as_vezes && come_frutas_legumes %is% sempre && parou_fumo %is% bastante_tempo, heart_problem %is% risco_baixo),
              
              fuzzy_rule(exercicio_fisico %is% regularmente && come_frutas_legumes %is% pouco && parou_fumo %is% bastante_tempo, heart_problem %is% risco_medio),
              
              fuzzy_rule(exercicio_fisico %is% regularmente && come_frutas_legumes %is% sempre && parou_fumo %is% a_um_tempo, heart_problem %is% risco_medio),
              
              fuzzy_rule(exercicio_fisico %is% regularmente && come_frutas_legumes %is% sempre && parou_fumo %is% bastante_tempo, heart_problem %is% risco_baixo),
              
              fuzzy_rule(exercicio_fisico %is% as_vezes && come_frutas_legumes %is% sempre && parou_fumo %is% bastante_tempo, heart_problem %is% risco_baixo),
              
              fuzzy_rule(exercicio_fisico %is% pouco && come_frutas_legumes %is% pouco && parou_fumo %is% bastante_tempo, heart_problem %is% risco_medio),
             
              fuzzy_rule(exercicio_fisico %is% pouco && come_frutas_legumes %is% as_vezes && parou_fumo %is% bastante_tempo, heart_problem %is% risco_medio),
             
             fuzzy_rule(exercicio_fisico %is% regularmente && come_frutas_legumes %is% pouco && parou_fumo %is% a_pouco_tempo, heart_problem %is% risco_medio)
             )

##it create a system fuzzy
system <- fuzzy_system(variables, rules)

##plot all system
plot(system)

##plot just the variable exercicio_fisico
plot(exercicio_fisico, xlab = "dias/semana", ylab = "grau de pertinência", main = "Frequência de exercícios físico")
##title(main="Autos", col.main="red", font.main=4)

##plot just the variable come_frutas_legumes
plot(come_frutas_legumes, xlab = "gramas/dia", ylab = "grau de pertinência", main = "Quantidade que se alimenta de frutas e legumes ao dia")

##plot just the variable parou_fuma
plot(parou_fumo, xlab = "anos", ylab = "grau de pertinência", main = "Há quantos anos parou de fumar")

##plot just the variable output heart_problem
plot(heart_problem, xlab = "percentual", ylab = "grau de pertinência", main = "Risco de ter problamas cardíacos")

##select a region according to input
fi <- fuzzy_inference(system, list(exercicio_fisico = 3, come_frutas_legumes = 200, parou_fumo = 0))

##plot crisp output
##sets_options("universe", seq( from = 0, to = 100, by = 0.1))
##plot(fi)



##plot fuzzy reponse with output
plot(heart_problem, xlab = "percentagem", ylab = "Grau de pertinência", main ="Resultado")
par(new = TRUE)
lines(fi, universe = 0:100, col = "red")

##get crisp out
abline(v=gset_defuzzify(fi, "centroid"), col="blue")

##legend("bottomright",legend = C("area fuzzy", "Centroid"),
  ##     lty=c(NA, 1), col=c("red", "blue"), lwd=2, bty="n")

legend(12, 1, c("saida","centroid"),  bty = "n", lwd = 2, cex = 0.8,
      col=c("red","blue"), lty=2:2);



##clean sets
sets_options("universe", NULL)

##clean global enviroment
rm(list = ls())

