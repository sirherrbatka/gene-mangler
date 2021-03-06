(cl:in-package #:gene-mangler.graph-data)

(prove:plan 61)

(let* ((linear-graph (build-graph
                     ()
                     ((a) (b) (c) (d))
                     ((a b) (b c) (c d))))
       (first-node (~> linear-graph nodes (aref 0)))
       (last-node (~> linear-graph nodes (aref 3)))
       (path (shortest-path linear-graph first-node last-node)))
  (prove:isnt path nil)
  (let* ((path-nodes (nodes path)))
    (prove:is (length path-nodes) 4)
    (prove:is (aref path-nodes 0) first-node)
    (prove:is (aref path-nodes 3) last-node)))

(let* ((linear-graph (build-graph
                      ()
                      ((a) (b) (c) (d))
                      ((a b) (b c) (c d))))
       (all-nodes (nodes linear-graph)))
  (let ((reachable-nodes (reachable-nodes (aref all-nodes 0))))
    (prove:is (length reachable-nodes) 4)
    (prove:is (aref reachable-nodes 0) (aref all-nodes 0))
    (prove:is (aref reachable-nodes 1) (aref all-nodes 1))
    (prove:is (aref reachable-nodes 2) (aref all-nodes 2))
    (prove:is (aref reachable-nodes 3) (aref all-nodes 3))))

(let* ((linear-graph (build-graph
                      ()
                      ((a) (b) (c) (d))
                      ((a b) (b c) (c d))))
       (all-nodes (nodes linear-graph))
       (first-node (aref all-nodes 0))
       (last-node (aref all-nodes 3))
       (path (shortest-path linear-graph first-node last-node))
       (edges (edges path)))
  (prove:is (length edges) 3)
  (break-edge! (aref edges 1))
  (let ((reachable-from-first (reachable-nodes first-node))
        (reachable-from-last (reachable-nodes last-node)))
    (prove:is (length reachable-from-last) 2)
    (prove:is (length reachable-from-first) 2)
    (prove:is (aref reachable-from-first 0) (aref all-nodes 0))
    (prove:is (aref reachable-from-first 1) (aref all-nodes 1))
    (prove:is (aref reachable-from-last 0) (aref all-nodes 3))
    (prove:is (aref reachable-from-last 1) (aref all-nodes 2))))

(let* ((linear-graph (build-graph
                      ()
                      ((a) (b) (c) (d))
                      ((a b) (b c) (c d))))
       (all-nodes (nodes linear-graph))
       (clone (clone linear-graph))
       (cloned-nodes (nodes clone)))
  (prove:is (length cloned-nodes) (length all-nodes))
  (prove:isnt (aref all-nodes 0) (aref cloned-nodes 0))
  (prove:isnt (aref all-nodes 1) (aref cloned-nodes 1))
  (prove:isnt (aref all-nodes 2) (aref cloned-nodes 2))
  (prove:isnt (aref all-nodes 3) (aref cloned-nodes 3)))

(let* ((linear-graph (build-graph
                      ()
                      ((a) (b) (c) (d))
                      ((a b) (b c) (c d))))
       (mixer (make 'graph-cutset-mixer))
       (fragments (cutset mixer linear-graph)))
  (prove:is (length fragments) 2)
  (prove:ok (every (lambda (fragment)
                     (< (~> fragment nodes length) 4))
                   fragments))
  (prove:is (sum fragments :key (compose #'length #'nodes)) 4)
  (prove:ok (every (lambda (fragment)
                     (= (~> fragment nodes first-elt reachable-nodes length)
                        (~> fragment nodes length)))
                   fragments))
  (let* ((combined-graph (combine-fragments mixer (aref fragments 0) (aref fragments 1)))
         (all-nodes (nodes combined-graph)))
    (prove:is (length all-nodes) 4)))

(let* ((circular-graph (build-graph
                        ()
                        ((a) (b) (c) (d))
                        ((a b) (b c) (c d) (d a))))
       (cycles (cycles circular-graph))
       (mixer (make 'graph-cutset-mixer))
       (fragments (cutset mixer circular-graph)))
  (prove:is (length cycles) 1)
  (prove:is (~> cycles first-elt nodes length) 4)
  (prove:is (~> cycles first-elt nodes remove-duplicates length) 4)
  (iterate
    (for edge in-vector (edges circular-graph))
    (prove:is (cycles-count edge) 1))
  (prove:is (length fragments) 2)
  (prove:ok (every (lambda (fragment)
                     (~> fragment broken-edges length (= 2)))
                   fragments))
  (prove:ok (every (lambda (fragment)
                     (< (~> fragment nodes length) 4))
                   fragments))
  (prove:is (sum fragments :key (compose #'length #'nodes))
            4)
  (prove:ok (every (lambda (fragment)
                     (= (~> fragment nodes first-elt reachable-nodes length)
                        (~> fragment nodes length)))
                   fragments))
  (let* ((combined-graph (combine-fragments mixer (aref fragments 0) (aref fragments 1)))
         (all-nodes (nodes combined-graph)))
    (prove:is (length all-nodes) 4)))

(let* ((circular-graph (build-graph
                        ()
                        ((a) (b) (c) (d) (e))
                        ((a b) (b c) (c d) (d a) (d e))))
       (cycles (cycles circular-graph))
       (cycle-counts (~> circular-graph
                         edges
                         (cl-ds.alg:on-each #'cycles-count)
                         cl-ds.alg:group-by
                         cl-ds.alg:count-elements)))
  (prove:is (length cycles) 1)
  (prove:is (~> cycles first-elt nodes length) 4)
  (prove:is (~> cycles first-elt nodes remove-duplicates length) 4)
  (prove:is (cl-ds:at cycle-counts 0) 1)
  (prove:is (cl-ds:at cycle-counts 1) 4)
  (iterate
    (for edge in-vector (~> cycles first-elt edges))
    (prove:is (cycles-count edge) 1)))

(let* ((nested-circular-graph (build-graph
                                  ()
                                  ((a) (b) (c) (d) (e) (f))
                                  ((a b)
                                   (b c) (b d) (d e) (c e)
                                   (e f) (f a))))
       (cycles (cycles nested-circular-graph))
       (cycles-by-size
         (~> cycles
             (cl-ds.alg:group-by :key (compose #'length
                                               #'edges))
             cl-ds.alg:to-vector))
       (cycles-grouped-by-edges (cycles-grouped-by-edges nested-circular-graph)))
  (prove:is (length cycles) 3)
  (cl-ds:across cycles-grouped-by-edges
                (lambda (edge.cycles)
                  (bind (((edge . cycles) edge.cycles))
                    (prove:is (cycles-count edge) (length cycles)))))
  (let* ((inner (~> cycles-by-size (cl-ds:at 4) first-elt))
         (edges (edges inner)))
    (iterate
      (for edge in-vector edges)
      (prove:is (cycles-count edge) 2)))
  (let* ((by-cycle-count (~> cycles-by-size
                             (cl-ds:at 5)
                             (cl-ds.alg:multiplex :key #'edges)
                             (cl-ds.alg:distinct :test 'eq)
                             (cl-ds.alg:group-by :key #'cycles-count)
                             cl-ds.alg:to-vector)))
    (prove:is (~> by-cycle-count (cl-ds:at 2) length) 7)))

(prove:finalize)
