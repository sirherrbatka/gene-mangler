(cl:in-package #:gene-mangler.individual)


(defun content (individual)
  (if (individual-p individual)
      (individual-content individual)
      individual))


(defun fitness (fitness-calculator individual)
  (ensure (individual-fitness individual)
    (~>> individual content (fitness* fitness-calculator))))


(defun crossover (cross individual-a individual-b)
  (~> (crossover* cross
                  (content individual-a)
                  (content individual-b))
      (make-individual :content)))


(defun mutate (mutator individual)
  (~>> individual
       content
       (mutate* mutator)
       (make-individual :content)))


(defun individual (content &optional fitness)
  (if (individual-p content)
      content
      (make-individual :content content :fitness fitness)))


(defun individual-has-fitness-p (individual)
  (not (null (individual-fitness individual))))
