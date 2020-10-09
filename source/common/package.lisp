(cl:in-package #:cl-user)


(defpackage #:gene-mangler.common
  (:use #:cl #:gene-mangler.aux-package)
  (:export
   #:reverse-proxy
   #:proxy-enabled
   #:envelop
   #:proxy
   #:defgeneric/proxy
   #:next-proxy))
