(in-package :cl-user)
(defpackage stroop.parse-print
  (:use :cl
	:closure-html)
  (:export :pt-print))
(in-package :stroop.parse-print)

;; Take a parse tree and descend it in-order, at each stage of the descent print
;; element beginning tag before descending to next element(s) and element 
;; ending tag after.

(defun pt-print (parse-tree, printer &optional excluder)
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
  (if (excluder parse-tree) NIL
      (format t "<~a>" (pt-name element)) ;; Print beginning tag of element
      (mapc #'(lambda (element)
		(if (printer element) 
		    NIL 
		    (pt-print element printer)))
	    (pt-children parse-tree))
      (format t "</~a>" (pt-name element)))) ;; Print ending tag of element 