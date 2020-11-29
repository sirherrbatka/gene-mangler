(cl:in-package #:gene-mangler.graph-data)


(defmethod make-edge ((mixer graph-cutset-mixer)
                      a-node
                      b-node)
  (assert a-node)
  (assert b-node)
  (make 'edge
        :first-node a-node
        :second-node b-node))


(defmethod clone ((graph graph-fragment))
  (bind (((:values clone mapping) (call-next-method))
         (nodes (nodes clone))
         (broken-edges (~> graph broken-edges copy-array)))
    (iterate
      (for i from 0 below (length broken-edges))
      (for edge = (aref broken-edges i))
      (for clone = (clone edge))
      (setf (aref broken-edges i) clone)
      (for range = (crawl clone))
      (iterate
        (for (values lense more) = (cl-ds:consume-front range))
        (while more)
        (for object = (look lense))
        (for already-cloned = (gethash object mapping))
        (setf (look lense) already-cloned))
      (assert (not (original-edge clone)))
      (assert (or (first-node clone) (second-node clone)))
      (finally (return (values (make 'graph-fragment
                                     :nodes nodes
                                     :source-graph (source-graph graph)
                                     :broken-edges broken-edges)
                               mapping))))))


(defmethod connect-nodes ((mixer graph-cutset-mixer)
                          a-node
                          b-node)
  (bind ((new-edge (make-edge mixer a-node b-node))
         ((:flet with-new-edge (node))
          (~>> node edges
               (push-into-vector-copy new-edge))))
    (setf (edges a-node) (with-new-edge a-node)
          (edges b-node) (with-new-edge b-node))))


(defmethod nodes-connectable-p ((mixer graph-cutset-mixer)
                                a-node
                                b-node)
  t)


(defmethod combine-fragments ((mixer graph-cutset-mixer)
                              a-fragment
                              b-fragment)
  (bind ((a-fragment-clone (clone a-fragment))
         (b-fragment-clone (clone b-fragment))
         (a-nodes (nodes a-fragment-clone))
         (b-nodes (nodes b-fragment-clone))
         (a-broken-edges (broken-edges a-fragment-clone))
         (b-broken-edges (broken-edges b-fragment-clone))
         ((:flet find-node (broken-edge nodes))
          (or (~> broken-edge first-node
                  (find nodes :test 'eq))
              (~> broken-edge second-node
                  (find nodes :test 'eq))
              (assert nil)))
         ((:flet merge-edges (a-edge b-edge))
          (connect-nodes mixer
                         (find-node a-edge a-nodes)
                         (find-node b-edge b-nodes)))
         (a-random-broken-edges (~> a-broken-edges
                                    copy-array
                                    shuffle))
         (b-random-broken-edges (~> b-broken-edges
                                    copy-array
                                    shuffle))
         ((:values shorter.nodes longer.nodes)
          (extrema `((,a-random-broken-edges . ,a-nodes)
                     (,b-random-broken-edges . ,b-nodes))
                   #'< :key (compose #'length #'car)))
         ((shorter . shorter-nodes) shorter.nodes)
         ((longer . longer-nodes) longer.nodes))
    ;; this is not exactly correct,
    ;; it simply discards all of the extra broken edges
    ;; The source algorithm is more sophisticated as it does that
    ;; it randomizes that behaviour
    ;; TODO implement the complete algorithm
    (map nil #'merge-edges
         a-random-broken-edges
         b-random-broken-edges)
    (if (and (emptyp a-random-broken-edges)
             (emptyp a-random-broken-edges))
        (iterate outer
          (with nodes-2 = (shuffle b-nodes))
          (with nodes-1 = (shuffle a-nodes))
          (for first-node in-vector nodes-1)
          (iterate
            (for second-node in-vector nodes-2)
            (when (nodes-connectable-p mixer first-node second-node)
              (connect-nodes mixer first-node second-node)
              (in outer (leave))))
          (finally (error "Can't connect graphs.")))
        (iterate
          (for i from (length shorter) below (length longer))
          (for broken-edge = (aref longer i))
          (for longer-node = (find-node broken-edge longer-nodes))
          (when (zerop (random 3))
            (next-iteration))
          (iterate
            (for shorter-node in-vector (shuffle shorter-nodes))
            (when (nodes-connectable-p mixer shorter-node longer-node)
              (connect-nodes mixer shorter-node longer-node)
              (finish)))))
    (make 'graph
          :nodes (~> a-fragment-clone nodes first-elt
                     reachable-nodes set-indexes-for-nodes))))


(defmethod cl-ds.utils:cloning-information append ((node node))
  '((:edges edges)
    (:index index)))


(defmethod cl-ds.utils:cloning-information append ((edge edge))
  '((:first-node first-node)
    (:second-node second-node)))


(defmethod cl-ds.utils:cloning-information append ((edge broken-edge))
  '((:first-node first-node)
    (:second-node second-node)
    (:original-edge original-edge)))


(defmethod clone ((node node))
  (cl-ds.utils:quasi-clone
   node
   :edges (~> node edges copy-array)))


(defmethod clone ((edge edge))
  (cl-ds.utils:clone edge))


(defmethod clone ((edge broken-edge))
  (cl-ds.utils:clone edge))


(defmethod clone ((graph graph))
  (bind ((nodes (nodes graph))
         (clone-mapping (make-hash-table :test 'eq))
         (clones (make-hash-table :test 'eq))
         ((:flet ensure-clone (object))
          (if (gethash object clones)
              (values object nil)
              (if-let ((clone (gethash object clone-mapping)))
                (values clone nil)
                (let ((clone (clone object)))
                  (setf (gethash object clone-mapping) clone
                        (gethash clone clones) t)
                  (values clone t))))))
    (iterate
      (for node in-vector nodes)
      (for (values clone new) = (ensure-clone node))
      (unless new (next-iteration))
      (iterate
        (with stack = (list clone))
        (until (endp stack))
        (for links = (crawl (pop stack)))
        (iterate
          (for (values lense more) = (cl-ds:consume-front links))
          (while more)
          (for reached-object = (look lense))
          (for (values clone new) = (ensure-clone reached-object))
          (setf (look lense) clone)
          (when new (push clone stack)))))
    (values (make 'graph
                  :nodes (map 'vector
                              (rcurry #'gethash clone-mapping)
                              nodes))
            clone-mapping)))


(defmethod graph-without ((graph graph) objects)
  (check-type objects vector)
  (bind ((skipped-objects (cl-ds.alg:to-hash-table objects :test 'eq))
         ((:flet skipped-p (object))
          (not (null (gethash object skipped-objects))))
         (nodes (~>> graph nodes (remove-if #'skipped-p)))
         (first-node (first-elt nodes))
         (clone-mapping (make-hash-table :test 'eq))
         ((:flet ensure-clone (object))
          (let ((clone (gethash object clone-mapping)))
            (if (null clone)
                (values (setf (gethash object clone-mapping)
                              (clone object))
                        t)
                (values (gethash object clone-mapping)
                        nil)))))
        (iterate
         (with stack = (~> first-node ensure-clone list))
         (until (endp stack))
         (for object = (pop stack))
         (assert object)
         (for links = (crawl object))
         (iterate
          (for (values lense more) = (cl-ds:consume-front links))
          (while more)
          (assert lense)
          (for reached-object = (look lense))
          (assert reached-object)
          (when (skipped-p reached-object)
            (setf (look lense) nil)
            (next-iteration))
          (for (values clone new) = (ensure-clone reached-object))
          (setf (look lense) clone)
          (when new (push clone stack))))
        (values (make 'graph
                      :nodes (map 'vector
                                  (rcurry #'gethash clone-mapping)
                                  nodes))
                clone-mapping)))


(defmethod crawl ((node node))
  (let ((edges (edges node)))
    (~> (cl-ds:iota-range :to (length edges))
        (cl-ds.alg:on-each
         (lambda (index)
           (when-let ((content (aref edges index)))
             (lense (aref edges index)))))
        (cl-ds.alg:without #'null))))


(defmethod crawl ((edge edge))
  (cl-ds:xpr (:i 0)
    (switch (i)
      (0 (cl-ds:send-recur (lense (first-node edge)) :i 1))
      (1 (cl-ds:send-recur (lense (second-node edge)) :i 2))
      (2 (cl-ds:finish)))))


(defmethod crawl ((edge broken-edge))
  (cl-ds:xpr (:i 0)
    (switch (i)
      (0 (cl-ds:send-recur (lense (first-node edge)) :i 1))
      (1 (cl-ds:send-recur (lense (second-node edge)) :i 2))
      (2 (cl-ds:send-recur (lense (original-edge edge)) :i 3))
      (3 (cl-ds:finish)))))


(defmethod follow-edge ((origin node) (edge edge))
  (cond ((eq origin (first-node edge))
         (second-node edge))
        ((eq origin (second-node edge))
         (first-node edge))
        (t (error 'invalid-origin
                  :format-control "Origin not found in the edge."))))


(defmethod edges :before ((object node))
  (let ((edges (slot-value object '%edges)))
    (decf (fill-pointer edges) (cl-ds.utils:swap-if edges #'null))))


(defmethod (setf edges) :before (new-value (object node))
  (assert (array-has-fill-pointer-p new-value)))


(defmethod edges ((object graph))
  (iterate outer
    (with hash-table = (make-hash-table :test 'eq))
    (for node in-vector (nodes object))
    (iterate
      (for edge in-vector (edges node))
      (setf (gethash edge hash-table) t))
    (finally
     (iterate
       (with result = (~> hash-table hash-table-count
                          make-array))
       (for (key whatever) in-hashtable hash-table)
       (for i from 0)
       (setf (aref result i) key)
       (finally (return-from outer result))))))


(defmethod individual:crossover*/proxy (mixer/proxy
                                        (mixer graph-cutset-mixer)
                                        fitness-calculator
                                        a-graph b-graph)
  (let ((a-cutset (cutset mixer a-graph))
        (b-cutset (cutset mixer b-graph)))
    (~> (cl-ds.alg:multiplex
         a-cutset
         :function (lambda (a-fragment)
                     (cl-ds.alg:on-each b-cutset
                                        (curry #'combine-fragments
                                               mixer a-fragment))))
        (cl-ds.alg:to-vector :key #'individual:individual))))


(defmethod cut ((mixer graph-cutset-mixer) graph)
  (let* ((clone (clone graph))
         (break-cycles (break-cycles mixer))
         (edges (edges clone)))
    (unless break-cycles
      (setf edges
            (remove-if-not #'zerop edges :key #'cycles-count)))
    (when (emptyp edges)
      (return-from cut
        (make 'graph-fragment
              :broken-edges #()
              :source-graph graph
              :nodes (nodes clone))))
    (iterate
      (with result = (vect))
      (with initial-edge = (pick-random edges))
      (with first-node = (first-node initial-edge))
      (with second-node = (second-node initial-edge))
      (with edge = initial-edge)
      (with broken-edges = (vect))
      (for broken-edge = (break-edge! edge))
      (vector-push-extend broken-edge broken-edges)
      (for path = (shortest-path clone first-node second-node))
      (until (null path))
      (setf edge (~> path edges pick-random))
      (finally
       (let ((first-nodes (reachable-nodes first-node))
             (second-nodes (reachable-nodes second-node)))
         (assert (= (+ (length first-nodes)
                       (length second-nodes))
                    (length (nodes graph))))
         (iterate
           (for first in-vector first-nodes)
           (assert (not (find first second-nodes))))
         (set-indexes-for-nodes first-nodes)
         (set-indexes-for-nodes second-nodes)
         (vector-push-extend
          (make
           'graph-fragment
           :broken-edges (remove-obsolete-broken-edges broken-edges
                                                       first-nodes)
           :source-graph graph
           :nodes first-nodes)
          result)
         (vector-push-extend
          (make
           'graph-fragment
           :broken-edges (remove-obsolete-broken-edges broken-edges
                                                       second-nodes)
           :source-graph graph
           :nodes second-nodes)
          result)
         (return result))))))


(defmethod initialize-instance :after ((object path)
                                       &rest initargs)
  (declare (ignore initargs))
  (let ((nodes (nodes object))
        (edges (edges object)))
    (iterate
      (for node in-vector nodes)
      (for edge in-vector edges)
      (assert (or (eq (first-node edge) node)
                  (eq (second-node edge) node))))))


(defmethod initialize-instance :after ((object edge) &rest initargs)
  (declare (ignore initargs))
  (assert (not (eq (first-node object)
                   (second-node object)))))


(defmethod initialize-instance :after ((object graph) &rest initargs)
  (declare (ignore initargs))
  (assert (every (complement #'null) (nodes object)))
  (setf (slot-value object '%cycles) (scan-cycles object)))


(defmethod initialize-instance :after ((object node) &rest initargs)
  (declare (ignore initargs))
  (assert (array-has-fill-pointer-p (edges object))))


(defmethod initialize-instance :after ((object graph-fragment)
                                       &rest initargs)
  (declare (ignore initargs))
  (iterate
    (with nodes = (nodes object))
    (for broken-edge in-vector (broken-edges object))
    (assert (or (find (first-node broken-edge) nodes)
                (find (second-node broken-edge) nodes)))))


(defmethod partakes-in-cycle-p ((edge edge))
  (~> edge cycles-count zerop not))


(defmethod connected-graph-p ((graph graph))
  (= (~> graph nodes first-elt
         reachable-nodes
         length)
     (~> graph nodes length)))
