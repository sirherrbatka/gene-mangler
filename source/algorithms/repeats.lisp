(cl:in-package #:gene-mangler.algorithms)


(defclass repeats (common:lifting-proxy)
  ((%number-of-repeats :reader number-of-repeats
                       :initarg number-of-repeats)))


(defmethod individual:crossover*/proxy ((mixer/proxy repeats)
                                        mixer
                                        fitness-calculator
                                        individual-a
                                        individual-b)
  (iterate
    (with result = (vect))
    (repeat (number-of-repeats mixer/proxy))
    (map nil
         (rcurry #'vector-push-extend result)
         (call-next-method))
    (finally (return result))))
