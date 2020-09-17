(cl:in-package #:cl-user)


(asdf:defsystem cl-data-structures-tests
  :name "gene-mangler-tests"
  :version "0.0.0"
  :depends-on (:prove-asdf :prove :gene-mangler)
  :defsystem-depends-on (:prove-asdf)
  :serial T
  :pathname "src"
  :components ((:module "graph-data"
                :components ((:test-file "tests")))))
