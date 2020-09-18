(cl:in-package #:cl-user)


(defpackage #:gene-mangler.process
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual)
   (#:generation #:gene-mangler.generation))
  (:export
   #:cycle!
   #:run!
   #:maximum-generation
   #:generation
   #:population
   #:process
   #:population-interface
   #:conductor
   #:finished-p
   #:fitness-calculator
   #:criteria))
