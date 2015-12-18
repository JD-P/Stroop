(in-package :cl-user)
(defpackage stroop.colorize
  (:use :cl
	:closure-html
	:stroop.parse-print
	:split-sequence
	:drakma)
  (:export :*dictionary*
	   :count-table-sd
	   :count-table-variance
	   :count-table-mean))
(in-package :stroop.colorize)

(defun color-pt-print (http-url dictionary)
  "Print an HTML page as colorized text.

   This function takes two arguments:

   http-url: An http-url of the form 'http://mywebsite.com' this should be a
             string.
   dictionary: A hash table dictionary that should have come distributed with Stroop.
               If it did and it was read successfuly it should be defined by this
               package as the variable name *dictionary* when the package is in 
               use.
  "
  (let (
	(page-pt (parse (http-request http-url) NIL))
	)
    (pt-parse page-pt color-printer style-excluder)))

(defun color-printer (element) nil)

(defun colorize (word)
  "Take a string representing a word and wrap it in an inline HTML color tag
   according to its frequency.

   The frequency mappings are:

   "
nil)

(defun count-table-sd (count-table)
  (sqrt (count-table-variance count-table)))

(defun count-table-variance (count-table)
  (let (
	(count (hash-table-count count-table))
	(mean (count-table-mean count-table))
	)
    (/
     (apply #'+ 
	    (mapcar
	     #'(lambda (value)
		 (expt (- (* value count) mean) 2))
	     (loop for value being the hash-values of count-table collecting value)))
     count)))

(defun count-table-mean (count-table)
  (let (
	(count (hash-table-count count-table))
	)
    (/ (apply #'+ 
	      (mapcar
	       #'(lambda (value) 
		   (* value count))
	       (loop for value being the hash-values of count-table collecting value))
	      )
       count)))

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

(setq *dictionary* (let (
			 (dictionary-file (open "dictionary.txt"))
			 (dictionary (make-hash-table :test 'equal))
			 )
		     (loop until (not (if (setq entry 
						(parse-line 
						 (read-line dictionary-file nil))) 
					  T NIL))
			do (setf (gethash (first entry) dictionary) (second entry))
			finally (return dictionary))))
