(cl:in-package #:cl-user)


(defpackage #:gene-mangler.graph-data
  (:use #:cl #:gene-mangler.aux-package)
  (:local-nicknames
   (#:individual #:gene-mangler.individual)
   (#:generation #:gene-mangler.generation)
   (#:algorithms #:gene-mangler.algorithms)
   (#:process #:gene-mangler.process))
  (:export
   #:break-edge!
   #:broken-edge
   #:broken-edges
   #:clone
   #:combine-fragments
   #:connect-nodes
   #:crawl
   #:cut
   #:cutset
   #:cycles-grouped-by-edges
   #:cycles
   #:cycles-count
   #:edge
   #:edges
   #:first-node
   #:follow-edge
   #:graph
   #:graph-cutset-mixer
   #:graph-fragment
   #:graph-mutator
   #:graph-without
   #:index
   #:invalid-origin
   #:lense
   #:look
   #:make-edge
   #:no-edge-error
   #:no-node-error
   #:no-path-error
   #:node
   #:nodes
   #:nodes-connectable-p
   #:number-of-cuts
   #:original-edge
   #:partakes-in-cycle-p
   #:connected-graph-p
   #:path
   #:reachable-nodes
   #:second-node
   #:set-indexes-for-nodes
   #:shortest-path)
  )
