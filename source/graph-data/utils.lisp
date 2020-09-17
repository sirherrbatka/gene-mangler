(cl:in-package #:gene-mangler.graph-data)


(defun pick-random (vector)
  (aref vector (random (length vector))))


(defun set-indexes-for-nodes (nodes)
  (iterate
    (for i from 0 below (length nodes))
    (for node in-vector nodes)
    (setf (index node) i)
    (finally (return nodes))))


(defun push-into-vector-copy (element vector)
  (lret ((result (make-array (~> vector length 1+)
                             :element-type (array-element-type vector)
                             :fill-pointer (and (array-has-fill-pointer-p vector)
                                                (~> vector length 1+))
                             :adjustable (adjustable-array-p vector))))
    (iterate
      (for i from 0 below (length vector))
      (setf (aref result i) (aref vector i)))
    (setf (aref result (length vector)) element)))


(defmacro build-graph ((&key (edge-class 'edge)
                          (edge-arguments '())
                          (node-class 'node)
                          (node-arguments '()))
                       nodes
                       edges)
  `(let ,(mapcar (lambda (name.arguments)
                   (bind (((name . arguments) name.arguments))
                     `(,name (make ',node-class
                                   ,@arguments
                                   ,@node-arguments))))
          nodes)
     (~> (vector ,@(iterate
                     (for (first second . args) in edges)
                     (collect `(make ',edge-class :first-node ,first
                                                  :second-node ,second
                                                  ,@args
                                                  ,@edge-arguments))))
         (cl-ds.alg:multiplex :function (lambda (edge)
                                          (list (list (first-node edge) edge)
                                                (list (second-node edge) edge))))
         (cl-ds.alg:group-by :key #'first :test 'eq)
         cl-ds.alg:to-vector
         (cl-ds:traverse (lambda (node.edges)
                           (bind (((node . edges) node.edges))
                             (setf (edges node)
                                   (map 'vector #'second edges))))))
     (make 'graph :nodes (set-indexes-for-nodes (vector ,@(map 'list #'first nodes))))))
