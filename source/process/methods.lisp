(cl:in-package #:gene-mangler.process)


(defmethod run! ((process process))
  (iterate
    (until (finished-p process))
    (cycle process)))


(defmethod finished-p or ((process process))
  (>= (generation process)
      (maximum-generation process)))


(defmethod cycle! ((process process))
  (let* ((population (population process))
         (mutator (mutator process))
         (fitness-calculator (fitness-calculator process))
         (selection-criteria (criteria process))
         (population-interface (population-interface process))
         (mixer (mixer process))
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
    (setf (population process) new-population)
    process))
