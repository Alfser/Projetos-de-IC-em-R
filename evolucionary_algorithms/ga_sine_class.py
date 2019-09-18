"""
Basic Genetic Algorithm

"""

import numpy as np
import matplotlib.pyplot as plt
import random
from mpl_toolkits.mplot3d import art3d

class GaSine(object):

    def __init__(self):

        self.DNA_SIZE = 50  # CHROMOSOME length
        self.POP_SIZE = 100  # population size
        self.CROSS_RATE = 0.75  # mating probability (DNA crossover)
        self.MUTATION_RATE = 0.01  # mutation probability
        self.N_GENERATIONS = 500
        self.X_BOUND = [-100, 100]  # x y upper and lower bounds

    # find non-zero fitness for selection
    def get_fitness(self, x, y):
        up = (np.sin(np.sqrt(x ** 2 + y ** 2)) ** 2) - 0.5
        dow = (1 + 0.001 * (x ** 2 + y ** 2)) ** 2

        return 0.5 - up / dow

    # convert binary CHROMOSOME to decimal and normalize it to a range(-100, 100)
    def translateDNA(self, pop):
        integer = pop.dot(2 ** np.arange(self.DNA_SIZE / 2)[::-1])
        return (integer * (self.X_BOUND[1] - self.X_BOUND[0]) / (2 ** (self.DNA_SIZE / 2) - 1)) + self.X_BOUND[0]

    def select(self, pop, fitness):  # nature selection wrt pop's fitness
        idx = np.random.choice(np.arange(self.POP_SIZE), size=self.POP_SIZE, replace=True,
                               p=fitness / fitness.sum())
        return pop[idx]

    def crossover(self, parent, pop):  # mating process (genes crossover)
        if np.random.rand() < self.CROSS_RATE:
            i_ = np.random.randint(0, self.POP_SIZE, size=1)  # select another individual from pop
            cross_points = np.random.randint(0, 2, size=self.DNA_SIZE).astype(np.bool)  # choose crossover points
            parent[cross_points] = pop[i_, cross_points]  # mating and produce one child
        return parent

    def mutate(self, child):
        for point in range(self.DNA_SIZE):
            if np.random.rand() < self.MUTATION_RATE:
                child[point] = 1 if child[point] == 0 else 0
        return child

    def play(self):
        # Running GA
        pop = np.random.randint(2, size=(self.POP_SIZE, self.DNA_SIZE))  # initialize the pop DNA

        random.seed(97)
        plt.ion()  # something about plotting

        u = np.linspace(self.X_BOUND[0], self.X_BOUND[1], 100)
        x, y, = np.meshgrid(u, u)
        z = self.get_fitness(x, y)
        fig, ax = plt.subplots(1, 1)
        contour = ax.contourf(x, y, z, 30, cmap='terrain')
        ax.set_xlabel('x')
        ax.set_ylabel('y')
        ax.set_title('Curva de Nível da Função')
        plt.colorbar(contour)
        plt.show()
        melhor = []
        media = []
        for _ in range(self.N_GENERATIONS):
            x_values = self.translateDNA(pop[:, :25])  # compute function value by extracting DNA
            y_values = self.translateDNA(pop[:, 25:])
            # something about plotting
            if 'sca' in globals():
                self.sca.remove()
            sca = plt.scatter(x_values, y_values, s=10, lw=0, c='red', alpha=0.5);plt.pause(0.05)

            # GA part (evolution)
            fitness = self.get_fitness(x_values, y_values)
            melhor.append(pop[np.argmax(fitness), :])
            media.append(np.mean(pop))
            print("Most fitted DNA: ", melhor[_])
            print("fitness: ", np.max(fitness))
            pop = self.select(pop, fitness)
            pop_copy = pop.copy()
            for parent in pop:
                child = self.crossover(parent, pop_copy)
                child = self.mutate(child)
                parent[:] = child  # parent is replaced by its child

        plt.figure(2)
        plt.plot(melhor)
        plt.show()
        plt.figure(3)
        plt.plot(media)
        plt.show()

        plt.ioff()
        plt.show()


if __name__ == "__main__":
    run = GaSine()
    run.play()
