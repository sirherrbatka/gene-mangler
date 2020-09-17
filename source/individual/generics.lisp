(cl:in-package #:gene-mangler.individual)


(defgeneric crossover* (mixer individual-a individual-b))
(defgeneric mutate* (mutator individual))
(defgeneric fitness* (fitness-calculator individual))
