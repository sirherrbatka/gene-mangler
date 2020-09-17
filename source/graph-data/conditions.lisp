(cl:in-package #:gene-mangler.graph-data)


(define-condition no-edge-error (cl-ds:textual-error)
  ())


(define-condition no-node-error (cl-ds:textual-error)
  ())


(define-condition no-path-error (cl-ds:textual-error)
  ())


(define-condition invalid-origin (cl-ds:textual-error)
  ())
