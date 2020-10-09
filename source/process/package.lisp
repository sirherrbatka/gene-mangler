(cl:in-package #:cl-user)


(defpackage #:gene-mangler.process
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual)
   (#:common #:gene-mangler.common)
   (#:generation #:gene-mangler.generation))
  (:export
   #:cycle!
   #:run!
   #:maximum-generation
   #:generation
   #:update-population-after-cycle!
   #:update-population-after-cycle!/proxy
   #:population
   #:process
   #:population-interface
   #:conductor
   #:finished-p
   #:finished-p/proxy
   #:fitness-calculator
   #:criteria))
