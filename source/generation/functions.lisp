(cl:in-package #:gene-mangler.generation)


(defun transform-population (function population-interface population)
  (iterate
    (for i from 0 below (population-size population-interface
                                         population))
    (setf #1=(at-population population-interface
                         population
                         i)
          (funcall function #1#))
    (finally (return population))))


(defun crossover (mixer
                  population-interface
                  population)
  (~> (crossover-pairs population-interface
                       population)
      (cl-ds.alg:multiplex
       :function (lambda (a.b)
                   (bind (((a . b) a.b))
                     (individual:crossover
                      mixer
                      a b))))
      cl-ds.alg:to-vector))


(defun mutate (mutator population-interface population)
  (~> (individuals-for-mutation mutator
                                population-interface
                                population)
      (cl-ds.alg:to-vector :key (curry #'individual:mutate
                                       mutator))))


(defun individuals-for-mutation (mutator
                                 population-interface
                                 population)
  (~> (population-range population-interface population)
      (cl-ds.alg:without (curry #'individual:for-mutation-p
                                mutator))))
