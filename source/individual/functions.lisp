(cl:in-package #:gene-mangler.individual)


(defun content (individual)
  (if (individual-p individual)
      (individual-content individual)
      individual))


(defun individual (content &optional fitness)
  (if (individual-p content)
      content
      (make-individual :content content :fitness fitness)))


(defun crossover (mixer fitness-calculator
                  individual-a individual-b)
  (map 'vector
       (lambda (x) (individual x))
       (crossover* mixer
                   fitness-calculator
                   (content individual-a)
                   (content individual-b))))


(defun mutate (mutator individual)
  (~>> individual
       content
       (mutate* mutator)
       individual))


(defun individual-has-fitness-p (individual)
  (not (null (individual-fitness individual))))
