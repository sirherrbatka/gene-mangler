(cl:in-package #:gene-mangler.algorithms)


(defclass elite (common:lifting-proxy)
  ((%size :reader size
          :initarg size)))


(defmethod individual:crossover*/proxy ((mixer/proxy elite)
                                        mixer
                                        individual-a
                                        individual-b)
  (take (size mixer/proxy) (call-next-method)))


(defmethod generation:select/proxy ((criteria/proxy elite)
                                    criteria
                                    fitness-calculator
                                    population-interface
                                    population)
  (~> (call-next-method)
      (generation:population-range population-interface _)
      (cl-ds.alg:restrain-size (size criteria/proxy))
      (generation:build-population population-interface _)))
