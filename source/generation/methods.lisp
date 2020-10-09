(cl:in-package #:gene-mangler.generation)


(defmethod build-population/proxy (proxy
                                   (population-interface population-interface)
                                   individuals)
  (if (distinct population-interface)
      (~> individuals
          (cl-ds.alg:distinct
           :test (test population-interface)
           :hash-function (hash-function population-interface)
           :key #'individual:content)
          (cl-ds.alg:to-vector :key #'individual:individual)
          shuffle)
      (~> (cl-ds.alg:to-vector individuals
                               :key #'individual:individual)
          shuffle)))


(defmethod crossover-pairs/proxy (population-interface/proxy
                                  (population-interface population-interface)
                                  population)
  (cl-ds.alg:multiplex
   (population-range population-interface population)
   :function (lambda (x)
               (iterate
                 (with range = (population-range population-interface population))
                 (for (values elt more) = (cl-ds:consume-front range))
                 (while more)
                 (until (eq elt x))
                 (collecting (cons elt x) at start)))))


(defmethod population-size/proxy (proxy
                                  (population-interface population-interface)
                                  population)
  (length population))


(defmethod at-population/proxy (proxy
                                (population-interface population-interface)
                                population
                                index)
  (aref population index))


(defmethod (setf at-population/proxy) (new-value
                                       proxy
                                       (population-interface population-interface)
                                       population
                                       index)
  (setf (aref population index) new-value))


(defmethod population-range/proxy (proxy
                                   (population-interface population-interface)
                                   population)
  (cl-ds:whole-range population))

