(cl:in-package #:gene-mangler.algorithms)


(defclass concatinating-conductor (generation:fundamental-conductor)
  ())


(defclass replacing-conductor (generation:fundamental-conductor)
  ())


(defmethod generation:new-generation/proxy
    (conductor/proxy
     population-interface/proxy
     (conductor concatinating-conductor)
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
    new-population))


(defmethod generation:new-generation/proxy
    (conductor/proxy
     population-interface/proxy
     (conductor replacing-conductor)
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
                                (list offsprings
                                      mutants))))
         (new-population
           (generation:select selection-criteria
             fitness-calculator
             population-interface
             combined-population)))
    new-population))
