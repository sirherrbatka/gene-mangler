(cl:in-package #:gene-mangler.common)


(defgeneric next-proxy (proxy))


(defgeneric proxy (proxy-enabled))


(defmethod next-proxy ((proxy (eql nil)))
  nil)


(defmethod proxy ((proxy-enabled (eql nil)))
  nil)


(defclass lifting-proxy ()
  ((%next-proxy :initarg :next-proxy
                :reader next-proxy))
  (:default-initargs :next-proxy nil))


(defclass proxy-enabled ()
  ((%proxy :initarg :proxy
           :accessor proxy))
  (:default-initargs :proxy nil))


(defun envelop (object proxy-class &rest args)
  (setf (proxy object) (apply #'make proxy-class
                              :next-proxy (proxy object)
                              args))
  object)


(defmacro defgeneric/proxy (name arguments)
  (bind (((:flet /proxy (symbol))
          (intern (format nil "~a/PROXY" symbol)))
         (setfp (listp name))
         (with-proxy-name (if setfp
                              `(setf ,(/proxy (second name)))
                              (/proxy name)))
         (function-arguments (mapcar (lambda (x)
                                       (if (listp x)
                                           (first x)
                                           x))
                                     arguments))
         (proxy-objects (~>> arguments
                               (remove-if #'atom)
                               (mapcar #'first)))
         (proxy-arguments (mapcar #'/proxy proxy-objects))
         ((:flet generic-lambda-list (&optional (proxy-arguments proxy-arguments)))
          (if setfp
              `(,(first function-arguments)
                ,@proxy-arguments
                ,@(rest function-arguments))
              `(,@proxy-arguments
                ,@function-arguments))))
    `(progn
       (defgeneric ,with-proxy-name ,(generic-lambda-list))
       ,@(iterate
           (for arg in proxy-arguments)
           (for list = (substitute (list arg 'lifting-proxy)
                                   arg
                                   proxy-arguments))
           (for next = (substitute `(next-proxy ,arg)
                                   arg
                                   proxy-arguments))
           (collect `(defmethod ,with-proxy-name
                         ,(generic-lambda-list list)
                       ,(if setfp
                            `(setf (,(second with-proxy-name)
                                    ,@next
                                    ,@(rest function-arguments))
                                   ,(first function-arguments))
                            `(,with-proxy-name
                              ,@next
                              ,@function-arguments)))))
       (defun ,name (,@function-arguments)
         (funcall #',with-proxy-name
                  ,@(iterate
                      (for p in proxy-objects)
                      (collect `(proxy ,p)))
                  ,@function-arguments)))))
