(cl:in-package #:gene-mangler.graph-data)


(defclass graph-mutator (individual:fundamental-mutator)
  ())


(defclass graph-cutset-mixer (individual:fundamental-mixer)
  ((%number-of-cuts :initarg :number-of-cuts
                    :reader number-of-cuts))
  (:default-initargs :number-of-cuts 1))


(defclass node ()
  ((%edges :accessor edges
           :initarg :edges)
   (%index :accessor index
           :initarg :index))
  (:default-initargs :index 0 :edges (vect)))


(defclass graph ()
  ((%nodes :initarg :nodes
           :reader nodes)))


(defclass path ()
  ((%graph :initarg :graph
           :reader graph)
   (%edges :initarg :edges
           :reader edges)
   (%nodes :initarg :nodes
           :reader nodes)))


(defclass edge ()
  ((%first-node :initarg :first-node
                :accessor first-node)
   (%second-node :initarg :second-node
                 :accessor second-node)))


(defclass broken-edge ()
  ((%first-node :initarg :first-node
                :accessor first-node)
   (%second-node :initarg :second-node
                 :accessor second-node)
   (%original-edge :initarg :original-edge
                   :accessor original-edge)))


(defclass graph-fragment (graph)
  ((%broken-edges :initarg :broken-edges
                  :reader broken-edges)
   (%source-graph :initarg :source-graph
                  :reader source-graph)))


(defstruct lense
  read-callback
  write-callback)
