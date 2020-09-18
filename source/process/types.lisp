(cl:in-package #:gene-mangler.process)


(defclass process ()
  ((%conductor
    :initarg :conductor
    :accessor conductor)
   (%population-interface
    :initarg :population-interface
    :accessor population-interface)
   (%population
    :initarg :population
    :accessor population)
   (%generation
    :initarg :generation
    :accessor generation)
   (%maximum-generation
    :initarg :maximum-generation
    :reader maximum-generation))
  (:default-initargs
   :generation 0))
