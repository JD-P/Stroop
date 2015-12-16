(in-package :cl-user)
(defpackage stroop.web
  (:use :cl
        :caveman2
        :stroop.config
        :stroop.view
        :stroop.db
        :datafly
	:drakma
        :sxql
	:split-sequence)
  (:export :*web*))
(in-package :stroop.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute "/test/*" (&key splat)
  (http-request (first splat)))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))

;; Data Loads

(defun parse-line (raw-entry)
  (if (not raw-entry) NIL
      (let* (
	     (splitline (split-sequence #\space raw-entry))
	     (key (string 
		   (subseq (first splitline) 1)))
	     (value (read-from-string 
		     (subseq (second splitline) 0 
			     (- (length 
				 (second 
				  splitline))
				1)))))
	(list key value))))

(setq dictionary (let (
		       (dictionary-file (open "dictionary.txt"))
		       (dictionary (make-hash-table :test 'equal))
		       )
		   (loop until (not (if (setq entry 
					      (parse-line 
					       (read-line dictionary-file nil))) 
					T NIL))
		      do (setf (gethash (first entry) dictionary) (second entry))
		      finally (return dictionary))))

