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


(defclass fundamental-conductor ()
  ((%mutator :initarg :mutator
             :reader mutator)
   (%mixer :initarg :mixer
           :reader mixer)
   (%fitness-calculator :initarg :fitness-calculator
                        :reader fitness-calculator)
   (%selection-criteria :initarg :selection-criteria
                        :reader selection-criteria)))
