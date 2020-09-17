(cl:in-package #:gene-mangler.process)


(defclass process ()
  ((%mixer
    :initarg :mixer
    :reader mixer)
   (%mutator
    :initarg :mutator
    :reader mutator)
   (%fitness-calculator
    :initarg :fitness-calculator
    :reader fitness-calculator)
   (%criteria
    :initarg :criteria
    :reader criteria)
   (%population
    :initarg :population
    :accessor population)
   (%generation
    :initarg :generation
    :accessor generation)
   (%maximum-generation
    :initarg :maximum-generation
    :reader maximum-generation)))
