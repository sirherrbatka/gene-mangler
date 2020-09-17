(cl:in-package #:gene-mangler.graph-data)


(docs:define-docs
  :formatter docs.ext:rich-aggregating-formatter

  (function
   number-of-cuts
   (:description "Returns number of cuts performed by the graph-cutset-mixer."))

  (function
   make-edge
   (:description "Constructs and returns edge."
    :notes "This method dispatches on the mixer which allows to store additional informations in a custom EDGE subclass."))

  (function
   cutset
   (:description "Calls cut number-of-cuts times and returns vector containing all of the constructed graph-fragments."
                 :notes "Used to implement the INDIVIDUAL:CROSSOVER* operator."))

  (function
   follow-edge
   (:description "Returns node from the EDGE that is not the ORIGIN."))

  (function
   cut
   (:description "Splits graph into two graph-fragments."
    :notes "Algorithm based on the publication JavaGenes: Evolving Graphs with Crossover."))

  (function
   edges
   (:description "Returns vector of edges in the graph or those in the directly in the node."))

  (function
   clone
   (:description "Returns copy of the edge, node or the graph. When called on the graph the deep copy is returned."
    :notes "Some of the functions this layers are destructive, and therefore it is sometimes required to construct copy of the graph before calling those."))

  (function
   first-node
   (:description "Returns node from the edge."))

  (function
   second-node
   (:description "Returns node from the edge."))

  (function
   broken-edges
   (:description "Returns all of the edges that had to be broken to construct the graph fragment."))

  (function
   original-edge
   (:description "Returns the original edge object that was broken."))

  (function
   combine-fragments
   (:description "Performs crossover between two graph fragments. Dispatched on the mixer."
    :individual "Used to implement the INDIVIDUAL:CROSSOVER*"))

  (function
   crawl
   (:description "Called on either NODE or EDGE returns CL-DS:RANGE that presents lenses acting as handler to the content. To obtain the object from the lense programmer can use the LOOK function. LOOK is also setfable, which makes CRAWL useful for cloning GRAPH.")))

