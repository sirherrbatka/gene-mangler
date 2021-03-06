(cl:in-package #:gene-mangler.algorithms)


(defclass elite (common:lifting-proxy)
  ((%size :reader size
          :initarg :size)))


(defmethod individual:crossover*/proxy ((mixer/proxy elite)
                                        mixer
                                        fitness-calculator
                                        individual-a
                                        individual-b)
  (let ((result (call-next-method)))
    (generation:ensure-fitness/vector fitness-calculator
                                      result)
    (take (size mixer/proxy)
          (sort result #'> :key #'individual:individual-fitness))))


(defmethod generation:select/proxy ((criteria/proxy elite)
                                    criteria
                                    fitness-calculator
                                    population-interface
                                    population)
  (let ((result (call-next-method)))
    (generation:ensure-fitness fitness-calculator
                               population-interface
                               result)
    (~>> result
         (generation:population-range population-interface)
         cl-ds.alg:to-vector
         (sort _ #'> :key #'individual:individual-fitness)
         (take (size criteria/proxy))
         (generation:build-population population-interface))))
