(cl:in-package #:gene-mangler.generation)


(defgeneric test (population-interface))
(defgeneric hash-function (population-interface))
(defgeneric mutator (conductor))
(defgeneric mixer (conductor))
(defgeneric selection-criteria (conductor))
(defgeneric fitness-calculator (conductor))
(common:defgeneric/proxy new-generation ((conductor)
                                         (population-interface)
                                         population))
(common:defgeneric/proxy crossover-pairs ((population-interface)
                                          population))
(common:defgeneric/proxy ensure-fitness ((fitness-calculator)
                                         population-interface
                                         population))
(common:defgeneric/proxy ensure-fitness/vector ((fitness-calculator)
                                                vector))
(common:defgeneric/proxy select ((criteria)
                                 fitness-calculator
                                 population-interface
                                 population))
(common:defgeneric/proxy build-population ((population-interface)
                                           individuals))
(common:defgeneric/proxy population-size ((population-interface)
                                          population))
(common:defgeneric/proxy at-population ((population-interface)
                                        population
                                        index))
(common:defgeneric/proxy (setf at-population) (new-value
                                               (population-interface)
                                               population
                                               index))
(common:defgeneric/proxy population-range ((population-interface)
                                           population))
