(cl:in-package #:cl-user)


(defpackage #:gene-mangler.generation
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual))
  (:export
   #:population-interface
   #:distinct
   #:crossover
   #:mutate
   #:build-population
   #:ensure-fitness
   #:select
   #:mutation-rate
   #:test
   #:hash-function))
