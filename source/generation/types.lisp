(cl:in-package #:gene-mangler.generation)


(defclass population-interface ()
  ((%test :initarg :test
          :reader test)
   (%distinct :initarg :distinct
              :reader distinct)
   (%parallel :initarg :parallel
              :reader parallel)
   (%hash-function :initarg :hash-function
                   :reader hash-function)))
