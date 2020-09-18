(cl:in-package #:gene-mangler.algorithm)


(defmethod gene-mangler.individual:mutate* ((mutator (eql nil))
                                            individual)
  individual)


(defmethod gene-mangler.generation:mutate ((mutator (eql nil))
                                           population-interface
                                           population)
  #())
