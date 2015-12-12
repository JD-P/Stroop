(ql:quickload 'split-sequence)

(defun gen-frequency-table (file)
  (let* ((count-table (gen-count-table file (make-hash-table :test 'equal)))
	 (total (apply #'+ (loop for value being the hash-values of count-table collecting value)))
	 (frequency-table (make-hash-table :test 'equal)))
    (loop for key being the hash-keys in count-table using (hash-value value) 
       do (setf (gethash key frequency-table) (/ value total)))
    (return-from gen-frequency-table frequency-table)))

(defun gen-count-table (file count-table)
  (let ((chunk-buffer (make-array 4096)))
    (loop until (not (setq chunk-buffer (read-chunk file 4096)))
	 do (parse-count-transfer count-table chunk-buffer)
       finally (return count-table))))

(defun parse-count-transfer (count-table chunk)
  (let ((counted-chunk (count-chunk (parse-chunk chunk))))
    (loop for count in counted-chunk
	 do (if (gethash (string-downcase (car count)) count-table) 
		(setf 
		 (gethash (string-downcase (car count)) count-table) 
		 (+ (gethash (string-downcase (car count)) count-table) (first (cdr count))))
		(setf (gethash (string-downcase (car count)) count-table)
		      (first (cdr count))))))
  count-table)
			

(defun read-chunk (file size)
  (let
      ((chunk-buffer (make-array size)))
    (if (zerop (read-sequence chunk-buffer file)) nil
	(let ((last-read (if (not (peek-char nil file nil))
			     nil
			     (elt chunk-buffer 
				  (- (length chunk-buffer) 1)))))
	  (loop until (or 
		       (eql last-read #\space)
		       (not last-read))
	     do (setq last-read (read-char file nil))
	     do (setq chunk-buffer
		      (concatenate 'vector chunk-buffer (vector last-read)))
	     finally (return chunk-buffer))))))
    

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
    (if (not delimiter)
	sequences
	(progn
	  (setq split-sequences 
		(mapcar 
		 #'(lambda (sequence) 
		     (split-sequence:split-sequence delimiter sequence))
		 sequences))
	  (apply #'split-many (cdr split-list) 
		 (remove "" 
			 (apply #'concatenate 
				'list split-sequences) 
			 :test #'equalp))))))