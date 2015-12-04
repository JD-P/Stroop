(ql:quickload 'prove)
(in-package :cl-user)
(defpackage my-test
  (:use :cl
        :prove))
(in-package :my-test)

(load "table-gen.lisp")

(plan 4)

;; TEST READ-CHUNK

(defun test-read-chunk ()
  (let ((test-text "hello world my name is david"))
    (with-input-from-string (file test-text)
      (is (coerce (read-chunk file 28) 'string) "hello world my name is david"))
    (with-input-from-string (file "")
      (is (read-chunk file 4096) 0))))

(test-read-chunk)

(defun test-parse-chunk ()
  (let ((test-chunk 
	 (with-input-from-string (file "hello world my name is david")
	   (read-chunk file 28))))
    (is (parse-chunk test-chunk) '(#(#\h #\e #\l #\l #\o) 
				   #(#\w #\o #\r #\l #\d) 
				   #(#\m #\y) #(#\n #\a #\m #\e)
				   #(#\i #\s) #(#\d #\a #\v #\i #\d))
	:test #'equalp)))

(test-parse-chunk)

(defun test-count-chunk ()
  (let ((test-chunk
	 (with-input-from-string (file "hello world my name is david")
	   (read-chunk file 28))))
    (is (count-chunk (parse-chunk test-chunk)) '(("hello" 1) 
						 ("world" 1) 
						 ("my" 1) 
						 ("name" 1) 
						 ("is" 1) 
						 ("david" 1)))))
(test-count-chunk)

(finalize)
