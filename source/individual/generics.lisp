(cl:in-package #:gene-mangler.individual)

(common:defgeneric/proxy crossover* ((mixer)
                                     fitness-calculator
                                     individual-a
                                     individual-b))
(common:defgeneric/proxy mutate* ((mutator) individual))
(common:defgeneric/proxy for-mutation-p ((mutator) individual))
