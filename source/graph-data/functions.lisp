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
      (unless (shiftf (gethash next visited) t)
        (assert next)
        (push next stack)))
    (finally (return result))))


(defun shortest-path (graph a-node b-node)
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


(defclass graph-walking-cell ()
  ((%leading-edge :initarg :leading-edge
                  :reader leading-edge)
   (%node :initarg :node
          :reader node)
   (%trail :initarg :trail
           :reader trail))
  (:default-initargs
   :leading-edge nil
   :trail '()
   :node nil))


(defun trail-cells-to-path (graph trail-cells)
  (make 'path
        :graph graph
        :nodes (map 'vector #'node trail-cells)
        :edges (~>> (map 'vector #'leading-edge trail-cells)
                    (remove-if #'null))))


(defun detect-cycle (cell seen)
  (iterate
    (with trail = (trail cell))
    (with node = (node cell))
    (with result = (list cell))
    (for trail-cell in trail)
    (for cell-node = (node trail-cell))
    (when (eq node cell-node)
      (for key = (~> result
                     (mapcar (compose #'index #'node) _)
                     (sort #'<)))
      (for mapped-p = (shiftf (gethash key seen) t))
      (when mapped-p
        (leave (values nil nil)))
      (iterate
        (for trail-cell in result)
        (for cell-edge = (leading-edge trail-cell))
        (unless (null cell-edge)
          (incf (cycles-count cell-edge))))
      (leave (values result t)))
    (push trail-cell result)
    (finally
     (return (values nil t)))))


(defun scan-cycles (graph)
  (iterate outer
    (with stack = (list (make 'graph-walking-cell
                              :node (~> graph nodes first-elt))))
    (with seen = (make-hash-table :test 'equal))
    (until (endp stack))
    (for cell = (pop stack))
    (for node = (node cell))
    (for leading-edge = (leading-edge cell))
    (for trail = (trail cell))
    (for new-trail = (cons cell trail))
    (for edges = (edges node))
    (for (values cycle walk) = (detect-cycle cell seen))
    (when cycle
      (collect cycle into cycles at start))
    (unless walk
      (next-iteration))
    (iterate
      (for edge in-vector (edges node))
      (when (eq edge leading-edge)
        (next-iteration))
      (for seen-p = (~> (member edge trail
                                :test 'eq :key 'leading-edge)
                        endp
                        not))
      (for destination = (follow-edge node edge))
      (assert destination)
      (when seen-p
        (next-iteration))
      (push (make 'graph-walking-cell
                  :node destination
                  :trail new-trail
                  :leading-edge edge)
            stack))
    (finally (return-from outer
               (map 'vector
                    (curry #'trail-cells-to-path graph)
                    cycles)))))


(defun cycles-grouped-by-edges (graph)
  (~> graph cycles
      (cl-ds.alg:multiplex
       :key (lambda (x)
              (map 'vector
                   (curry #'cons x)
                   (edges x))))
      (cl-ds.alg:group-by :test 'eq :key #'cdr)
      (cl-ds.alg:on-each #'car)
      (cl-ds.alg:distinct :test 'eq)
      cl-ds.alg:to-vector))


(defun cutset (mixer graph)
  (iterate
    (with result = (vect))
    (repeat (number-of-cuts mixer))
    (for fragments = (cut mixer graph))
    (when (vectorp fragments)
      (iterate
        (for f in-vector fragments)
        (vector-push-extend f result)))
    (finally (return result))))


(defun break-edge! (edge)
  (let* ((first-node (first-node edge))
         (second-node (second-node edge))
         (first-edges (edges first-node))
         (second-edges (edges second-node)))
    (cl-ds.utils:swapop first-edges (position edge first-edges))
    (cl-ds.utils:swapop second-edges (position edge second-edges))
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

