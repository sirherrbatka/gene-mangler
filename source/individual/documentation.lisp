(cl:in-package #:gene-mangler.individual)


(docs:define-docs
  :formatter docs.ext:rich-aggregating-formatter

  (function
   crossover*
   (:description "Performs crossover between two objects. Returns a new object."
    :notes "Ordinary function crossover is here to unwrap the objects from the individual structs that also store evaluated fitness of the objects."))

  (function
   mutate*
   (:description "Performs mutation on the individual object. Returns new, mutated object."))

  (function
   fitness*
   (:description "Evaluates fitness of the individual as a number. Returns the result.")))
