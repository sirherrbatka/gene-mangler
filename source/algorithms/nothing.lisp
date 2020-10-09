(cl:in-package #:gene-mangler.algorithms)


(defmethod individual:mutate*/proxy (mutator/proxy
                                     (mutator (eql nil))
                                     individual)
  individual)


(defmethod individual:for-mutation-p/proxy (mutator/proxy
                                            (mutator (eql nil))
                                            individual)
  nil)


(defclass inclusive-criteria (generation:fundamental-selection-criteria)
  ())


(defmethod generation:select/proxy (proxy
                                    (selection inclusive-criteria)
                                    fitness-calculator
                                    population-interface
                                    population)
  population)


(defmacro criteria (&rest forms)
  `(~> (make 'inclusive-criteria)
       ,@(mapcar (lambda (x) `(common:envelop ',(first x) ,@(rest x)))
                 forms)))
