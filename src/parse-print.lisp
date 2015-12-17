(in-package :cl-user)
(defpackage stroop.parse-print
  (:use :cl
	:closure-html)
  (:export :pt-print
	   :stroop-printer
	   :stroop-excluder))
(in-package :stroop.parse-print)

;; Take a parse tree and descend it in-order, at each stage of the descent print
;; element beginning tag before descending to next element(s) and element 
;; ending tag after.

(defun pt-print (parse-tree printer &optional excluder)
  "pt-print takes three arguments:

   parse-tree: An HTML element returned by closure-html:parse or 
               closure-html:pt-children

   printer: A function that prints out the contents of tags. Returns true if a
            tag is a 'base case' that has no children and recurses otherwise.

   excluder: An optional function that excludes certain tags from being printed
             during the descent. It returns true if a tag is to be excluded from
             printing.
  "
  (if (not excluder) (setq excluder (lambda () NIL)) NIL)
  (if (funcall excluder parse-tree) NIL
      (progn
	(format t "<~a~a>" (pt-name parse-tree) ;; Print beginning tag of element
		(apply #'concatenate 'string 
		       (reverse (stringify-attrs (pt-attrs parse-tree)))))
	(mapc #'(lambda (element)
		  (if (funcall printer element) 
		      NIL 
		      (pt-print element printer excluder)))
	      (pt-children parse-tree))
	(format t "</~a>" (pt-name parse-tree))))) ;; Print ending tag of element 

(defun stringify-attrs (attr-list &optional strings)
  (if (not (first attr-list)) strings
      (stringify-attrs
       (subseq attr-list 2)
       (cons 
	(format nil " ~a='~a'"
		(first attr-list) 
		(second attr-list))
	strings))))

(defun stroop-printer (element)
  (if (equal (pt-name element) :PCDATA)
      (progn 
	(format t "~a" (pt-attrs element))
	T)
      NIL))
  
(defun stroop-excluder (element)
  (if (equal (pt-name element) :LINK)
      T
      NIL))