(cl:in-package #:gene-mangler.algorithms)


(defclass roulette-selection (fundamental-selection-criteria)
  ((%selected-count :initarg :select-count
                    :reader selected-count)))


(defmethod generation:select ((criteria roulette-selection)
                              fitness-calculator
                              population-interface
                              population)
  (generation:ensure-fitness fitness-calculator
                             population-interface
                             population)
  (iterate
    (with values = (~> population
                       (cl-ds.alg:cumulative-accumulate
                        #'+ :key #'individual:individual-fitness)
                       cl-ds.alg:to-vector))
    (with largest-value = (last-elt values))
    (with selected-count = (selected-count criteria))
    (with result = (make-array selected-count
                               :adjustable t
                               :fill-pointer selected-count))
    (for i from 0 below (min (length population)
                             selected-count))
    (for random = (random largest-value))
    (for k = (cl-ds.utils:lower-bound values random #'<))
    (setf (aref result i) (aref population k))
    (finally (return result))))
