(cl:in-package #:gene-mangler.individual)


(defstruct individual
  content fitness)


(defclass fundamental-mutator (common:proxy-enabled)
  ())


(defclass fundamental-mixer (common:proxy-enabled)
  ())


(defclass fundamental-fitness-calculator (common:proxy-enabled)
  ())
