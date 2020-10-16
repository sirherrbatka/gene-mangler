(cl:in-package #:cl-user)


(defpackage #:gene-mangler.individual
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:common #:gene-mangler.common))
  (:export
   #:content
   #:crossover
   #:crossover*
   #:crossover*/proxy
   #:fundamental-mutator
   #:fundamental-mixer
   #:fundamental-fitness-calculator
   #:for-mutation-p
   #:for-mutation-p/proxy
   #:individual
   #:individual-content
   #:individual-fitness
   #:individual-has-fitness-p
   #:individual-p
   #:make-individual
   #:mutate
   #:mutate*/proxy))
