(cl:in-package #:gene-mangler.algorithms)


(defclass fundamental-selection-criteria ()
  ())


(defclass fundamental-mixer ()
  ())


(defclass fundamental-mutator ()
  ((%mutation-rate :initarg :mutation-rate
                   :reader generation:mutation-rate)))


(defclass fundamental-fitness-calculator ()
  ())
