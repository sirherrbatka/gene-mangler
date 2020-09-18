(cl:in-package #:cl-user)


(defpackage #:gene-mangler.generation
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual))
  (:export
   #:build-population
   #:crossover
   #:distinct
   #:ensure-fitness
   #:fundamental-conductor
   #:hash-function
   #:mutate
   #:mutation-rate
   #:new-generation
   #:population-interface
   #:mutator
   #:mixer
   #:select
   #:selection-criteria
   #:fitness-calculator
   #:test))
