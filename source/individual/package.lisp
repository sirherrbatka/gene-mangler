(cl:in-package #:cl-user)


(defpackage #:gene-mangler.individual
  (:use #:cl #:gene-mangler.aux-package)
  (:export
   #:content
   #:crossover
   #:crossover*
   #:fitness
   #:fitness*
   #:individual
   #:individual-content
   #:individual-fitness
   #:individual-has-fitness-p
   #:individual-p
   #:mutate
   #:mutate*))
