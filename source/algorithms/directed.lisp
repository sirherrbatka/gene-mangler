(cl:in-package #:gene-mangler.algorithms)


(defclass directed (common:lifting-proxy)
  ((%directions :initarg :directions
                :reader directions)))


(defclass directed-population ()
  ((%directions :initarg :directions
                :accessor directions)
   (%population :initarg :population
                :accessor population)))


(defmethod generation:population-range/proxy
    ((population-interface/proxy directed)
     population-interface
     population)
  (~> population-interface/proxy
      common:next-proxy
      (call-next-method population-interface
                        (population population))))


(defmethod generation:ensure-fitness/proxy
    ((population-interface/proxy directed)
     calculator
     population-interface
     population)
  (generation:ensure-fitness/proxy
   (common:next-proxy population-interface/proxy)
   calculator
   population-interface
   (population population)))


(defmethod generation:build-population/proxy
    ((population-interface/proxy directed)
     population-interface
     individuals)
  (let ((population (~> population-interface/proxy
                        common:next-proxy
                        (call-next-method population-interface
                                          individuals))))
    (make 'directed-population
          :directions (directions population-interface)
          :population population)))


(defmethod generation:crossover-pairs/proxy
    ((population-interface/proxy directed)
     population-interface
     population)
  (cl-ds.alg:on-each (generation:population-range population-interface
                                                  population)
                     (~>> population directions first-elt (curry #'cons))))


(defmethod process:update-population-after-cycle!/proxy
    (process/proxy
     (population-interface/proxy directed)
     process
     population-interface
     population)
  (setf (directions population) (drop (process:generation process)
                                      (directions population)))
  population)


(defmethod process:finished-p/proxy
    (process/proxy
     (population-interface/proxy directed)
     proces
     population-interface
     population)
  (or (endp (directions population))
      (call-next-method)))
