(cl:in-package #:cl-user)


(asdf:defsystem gene-mangler
  :name "gene-mangler"
  :version "0.0.0"
  :author "Marek Kochanowicz"
  :depends-on ( :iterate       :serapeum
                :lparallel     :cl-data-structures
                :metabang-bind :alexandria
                :documentation-utils-extensions
                :cl-progress-bar)
  :serial T
  :pathname "source"
  :components ((:file "aux-package")
               (:module "common"
                :components ((:file "package")
                             (:file "lifting-proxy")))
               (:module "individual"
                :components ((:file "package")
                             (:file "generics")
                             (:file "types")
                             (:file "utils")
                             (:file "functions")
                             (:file "methods")
                             (:file "documentation")))
               (:module "generation"
                :components ((:file "package")
                             (:file "generics")
                             (:file "types")
                             (:file "utils")
                             (:file "functions")
                             (:file "methods")
                             (:file "documentation")))
               (:module "process"
                :components ((:file "package")
                             (:file "generics")
                             (:file "types")
                             (:file "utils")
                             (:file "functions")
                             (:file "methods")
                             (:file "documentation")))
               (:module "algorithms"
                :components ((:file "package")
                             (:file "nothing")
                             (:file "roulette")
                             (:file "conductors")
                             (:file "directed")
                             (:file "elite")
                             (:file "repeats")
                             (:file "documentation")))
               (:module "graph-data"
                :components ((:file "package")
                             (:file "generics")
                             (:file "types")
                             (:file "macros")
                             (:file "conditions")
                             (:file "utils")
                             (:file "functions")
                             (:file "methods")
                             (:file "documentation")))
               ))
