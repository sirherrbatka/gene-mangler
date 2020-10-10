(cl:in-package #:cl-user)


(defpackage #:gene-mangler.algorithms
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual)
   (#:common #:gene-mangler.common)
   (#:generation #:gene-mangler.generation)
   (#:process #:gene-mangler.process))
  (:export
   #:proxy
   #:criteria
   #:concatinating-conductor
   #:elite
   #:roulette
   #:mutation-rate))
