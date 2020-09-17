(cl:in-package #:gene-mangler.graph-data)


(defmacro lense (form)
  `(make-lense :read-callback (lambda () ,form)
               :write-callback (lambda (x) (setf ,form x))))
