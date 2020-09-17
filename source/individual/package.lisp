(cl:in-package #:cl-user)


(defpackage #:gene-mangler.individual
  (:use #:cl #:gene-mangler.aux-package)
  (:export
   #:individual
   #:individual-p
   #:fitness
   #:content
   #:individual-fitness
   #:individual-has-fitness-p

   #:crossover
   #:mutate
   #:fitness*
   #:crossover*
   #:mutate*))
