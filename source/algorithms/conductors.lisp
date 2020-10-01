(cl:in-package #:gene-mangler.algorithms)


(defclass concatinating-conductor (generation:fundamental-conductor)
  ())


(defmethod generation:new-generation ((conductor concatinating-conductor)
                                      population-interface
                                      population)
  (let* ((mutator (generation:mutator conductor))
         (mixer (generation:mixer conductor))
         (fitness-calculator (generation:fitness-calculator conductor))
         (selection-criteria (generation:selection-criteria conductor))
         (offsprings (generation:crossover mixer
                                           fitness-calculator
                                           population-interface
                                           population))
         (mutants (generation:mutate mutator
                                     population-interface
                                     offsprings))
         (combined-population (generation:build-population
                               population-interface
                               (cl-ds.alg:multiplex
                                (list population
                                      offsprings
                                      mutants))))
         (new-population
           (generation:select selection-criteria
             fitness-calculator
             population-interface
             combined-population)))
    (shuffle new-population)))
