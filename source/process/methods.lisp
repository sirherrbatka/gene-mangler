(cl:in-package #:gene-mangler.process)


(defmethod run! ((process process))
  (iterate
    (with population-interface = (population-interface process))
    (for population = (population process))
    (until (finished-p process population-interface population))
    (cycle! process)
    (finally (return (population process)))))


(defmethod finished-p/proxy (process/proxy
                             population-interface/proxy
                             (process process)
                             population-interface
                             population)
  (>= (generation process) (maximum-generation process)))


(defmethod cycle! ((process process))
  (let ((new-generation (generation:new-generation
                         (conductor process)
                         (population-interface process)
                         (population process))))
    (incf (generation process))
    (setf (population process) (update-population-after-cycle!
                                process
                                (population-interface process)
                                new-generation)))
  process)


(defmethod update-population-after-cycle!/proxy (process/proxy
                                                 population-interface/proxy
                                                 (process process)
                                                 population-interface
                                                 population)
  population)
