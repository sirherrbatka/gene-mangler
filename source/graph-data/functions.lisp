(cl:in-package #:gene-mangler.graph-data)


(defun reachable-nodes (node)
  (iterate
    (with visited = (lret ((v (make-hash-table :test 'eq)))
                      (setf (gethash node v) t)))
    (with result = (vect))
    (with stack = (list node))
    (until (endp stack))
    (for n = (pop stack))
    (vector-push-extend n result)
    (iterate
      (for edge in-vector (edges n))
      (for next = (follow-edge n edge))
      (unless (gethash next visited)
        (setf (gethash next visited) t)
        (push next stack)))
    (finally (return result))))


(defun shortest-path (graph a-node b-node)
  (declare (optimize (debug 3)))
  (bind ((nodes (nodes graph))
         (a-index (position a-node nodes :test 'eq))
         (b-index (position b-node nodes :test 'eq))
         (number-of-nodes (length nodes))
         (distances (make-array number-of-nodes
                                :element-type 'fixnum
                                :initial-element most-positive-fixnum))
         (queue (cl-ds.queues.2-3-tree:make-mutable-2-3-queue))
         (register nil)
         ((:flet qpush (edge node))
          (cl-ds:put! queue
                      (list (cons (list edge node)
                                  register)
                            node)))
         ((:flet qpop ())
          (cl-ds:mod-bind (q found cell) (cl-ds:take-out! queue)
            (setf register (first cell))
            cell)))
    (when (null a-index)
      (error 'no-node-error
             :format-control "No such node in the graph!"))
    (when (null b-index)
      (error 'no-node-error
             :format-control "No such node in the graph!"))
    (setf (aref distances a-index) 0)
    (cl-ds:put! queue (list (list (list nil a-node)) a-node))
    (iterate outer
      (until (~> queue cl-ds:size zerop))
      (for (trace node) = (qpop))
      (when (eq node b-node)
        (iterate
          (with nodes = (vect))
          (with edges = (vect))
          (for (edge destination) in trace)
          (assert (not (find destination nodes)))
          (vector-push-extend destination nodes)
          (unless (null edge)
            (assert (not (find edge edges)))
            (vector-push-extend edge edges))
          (finally
           (return-from outer
             (make 'path
                   :edges (reverse edges)
                   :graph graph
                   :nodes (reverse nodes))))))
      (for p-index = (index node))
      (for old-distance = (aref distances p-index))
      (for new-distance = (1+ old-distance))
      (iterate
        (for edge in-vector (edges node))
        (for destination = (follow-edge node edge))
        (for index = (index destination))
        (when (<= (aref distances index) new-distance)
          (next-iteration))
        (setf (aref distances index) new-distance)
        (qpush edge destination))
      (finally (return-from outer nil)))))


(defun cutset (mixer graph)
  (iterate
    (with result = (vect))
    (repeat (number-of-cuts mixer))
    (for fragments = (cut mixer graph))
    (iterate
      (for f in-vector fragments)
      (vector-push-extend f result))
    (finally (return result))))


(defun break-edge! (edge)
  (let ((first-node (first-node edge))
        (second-node (second-node edge)))
    (setf #1=(edges first-node) (remove edge #1# :test 'eq)
          #2=(edges second-node) (remove edge #2# :test 'eq))
    (make 'broken-edge
          :first-node first-node
          :second-node second-node
          :original-edge edge)))


(defun lense-read (lense)
  (funcall (lense-read-callback lense)))


(defun lense-write (lense x)
  (funcall (lense-write-callback lense) x))


(defun look (lense)
  (lense-read lense))


(defun (setf look) (new-value lense)
  (lense-write lense new-value))

