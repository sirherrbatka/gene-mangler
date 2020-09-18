(cl:in-package #:gene-mangler.process)


(defmethod run! ((process process))
  (iterate
    (until (finished-p process))
    (cycle! process)))


(defmethod finished-p or ((process process))
  (>= (generation process)
      (maximum-generation process)))


(defmethod cycle! ((process process))
  (let ((new-generation (generation:new-generation
                         (conductor process)
                         (population-interface process)
                         (population process))))
    (setf (population process) new-generation)
    (incf (generation process)))
  process)
