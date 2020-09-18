(cl:in-package #:gene-mangler.generation)


(defmethod build-population ((population-interface population-interface)
                             individuals)
  (if (distinct population-interface)
      (~> individuals
          (cl-ds.alg:distinct
           :test (test population-interface)
           :hash-function (hash-function population-interface)
           :key #'individual:content)
          (cl-ds.alg:to-vector :key #'individual:individual))
      (cl-ds.alg:to-vector individuals
                           :key #'individual:individual)))


(defmethod mutate (mutator
                   (population-interface population-interface)
                   population)
  (iterate
    (with mutation-rate = (mutation-rate mutator))
    (with length = (length population))
    (with result = (vect))
    (for i from 0 below length)
    (for test = (random 1.0))
    (when (< test mutation-rate)
      (vector-push-extend (aref population i)
                          result))
    (finally (return result))))


(defmethod crossover (mixer
                      fitness-calculator
                      (population-interface population-interface)
                      population)
  (declare (optimize (debug 3)))
  (iterate
    (with result = (vect))
    (with length = (length population))
    (for i from 0 below length)
    (for a = (aref population i))
    (iterate
      (for j from 0 below i)
      (for b = (aref population j))
      (for offsprings = (individual:crossover mixer a b))
      (map nil (rcurry #'vector-push-extend result)
           offsprings))
    (finally (return result))))


(defmethod ensure-fitness (fitness-calculator
                           (population-interface population-interface)
                           population)
  (map nil (curry #'individual:fitness fitness-calculator) population)
  population)
