(cl:in-package #:cl-user)


(defpackage #:gene-mangler.algorithms
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual)
   (#:generation #:gene-mangler.generation)
   (#:process #:gene-mangler.process))
  (:export
   #:fundamental-selection-criteria
   #:fundamental-mixer
   #:fundamental-fitness-calculator
   #:fundamental-mutator
   #:mutation-rate))
