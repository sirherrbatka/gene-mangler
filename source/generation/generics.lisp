(cl:in-package #:gene-mangler.generation)


(defgeneric crossover (mixer fitness-calculator
                       population-interface population))
(defgeneric mutate (mutator population-interface population))
(defgeneric new-generation (conductor
                            population-interface
                            population))
(defgeneric ensure-fitness (fitness-calculator
                            population-interface
                            population))
(defgeneric select (criteria fitness-calculator
                    population-interface population))
(defgeneric build-population (population-interface individuals))
(defgeneric mutation-rate (mutator))
(defgeneric test (population-interface))
(defgeneric hash-function (population-interface))
(defgeneric mutator (conductor))
(defgeneric mixer (conductor))
(defgeneric selection-criteria (conductor))
(defgeneric fitness-calculator (conductor))
