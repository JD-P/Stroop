(ql:quickload 'split-sequence)

(defun gen-frequency-table (filepath) 
  (let ((file (open filepath))
	(buffer (make-array 4096)))
    (read-sequence buffer file)
    (print buffer)))

(defun gen-count-table (file count-table)
  (let ((chunk-buffer (make-array 4096)))
    (loop until (zerop (read-sequence chunk-buffer file))
	 do (parse-count-transfer count-table chunk-buffer)
       finally (return count-table))))

(defun parse-count-transfer (count-table chunk)
  (let ((counted-chunk (count-chunk (parse-chunk chunk))))
    (loop for count in counted-chunk
	 do (if (gethash (car count) count-table) 
		(setf 
		 (gethash (car count) count-table) 
		 (+ (gethash (car count) count-table) (first (cdr count))))
		(setf (gethash (car count) count-table)
		      (first (cdr count))))))
  count-table)
			

(defun read-chunk (file size)
  (let
      ((chunk-buffer (make-array size)))
    (if (zerop (read-sequence chunk-buffer file)) nil
	chunk-buffer)))
    

(defun parse-chunk (chunk)
  (split-many '(#\space #\tab #\newline #\vt #\page #\return #\fs #\gs #\rs #\us #\-) 
	      (remove-many '(#\! #\" #\# #\$ #\% #\& #\' #\( #\) #\* #\+ #\, #\. 
			     #\/ #\: #\; #\< #\= #\> #\? #\@ #\[ #\\ #\] #\^ #\_ 
			     #\{ #\} #\| #\~ 0 Nil)
			   chunk)))

(defun count-chunk (parsed-chunk)
  (mapcar #'(lambda (word) (list (coerce word 'string) (count word parsed-chunk)))
	  (remove-duplicates parsed-chunk)))

;; REMOVE CHARACTERS FROM CHUNK BEFORE PROCESSING:
;; ! " # $ % & ` ( ) * + , . / : ; < = > ? @ [ \ ] ^ _ { } | ~

(defun remove-many (rmlist sequence)
  (loop for undesirable in rmlist
       do (setq sequence (remove undesirable sequence)))
  sequence)

;; SPLIT CHARACTERS FROM CHUNK BEFORE PROCESSING:
;; #\space #\tab #\newline #\vt #\page #\return #\fs #\gs #\rs #\us #\-

(defun split-many (split-list &rest sequences)
  (if (equal (type-of sequences) 'CONS) Nil (setq sequences (list sequences)))
  (let 
      ((delimiter (car split-list)))
    (if delimiter
	(setq split-sequences 
	      (mapcar 
	       #'(lambda (sequence) 
		   (split-sequence:split-sequence delimiter sequence))
	       sequences))
	(return-from split-many sequences))
    (apply #'split-many (cdr split-list) 
	   (remove "" 
		   (apply #'concatenate 
			  'list split-sequences) 
		   :test #'equalp))))
       

(defun cut-buffer (buffer file)
  (let* (
	(word-cut (- (position (character " ") 
			       (reverse buffer)) 
		     1)
	(temp-buffer (make-array 
		      (- (length buffer) 
			 word-cut)
		     ))
	  )
	 )
    (read-sequence temp-buffer file)
    (concatenate 'vector 
      (subseq buffer 
        (-
          (length buffer)
	  word-cut
          ))
      temp-buffer)
    ))