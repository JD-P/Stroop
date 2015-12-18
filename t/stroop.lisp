(in-package :cl-user)
(defpackage stroop-test
  (:use :cl
        :stroop
	:stroop.colorize
        :prove)
  (:export :*test-table*
	   :run-tests))
(in-package :stroop-test)

(plan 3)

(setq *test-table* (make-hash-table :test 'equal))
(setf (gethash 'a *test-table*) 1/3)
(setf (gethash 'b *test-table*) 2/3)
(setf (gethash 'c *test-table*) 2/3)

(defun test-count-table-mean (count-table)
  (is (count-table-mean count-table) 5/3
      "count-table-mean returned accurate mean."))

(defun test-count-table-variance (count-table)
  (is (count-table-variance count-table) 2/9
      "count-table-variance returned accurate variance."))

(defun test-count-table-sd (count-table)
  (is (count-table-sd count-table) (sqrt 2/9)
      "count-table-sd returned accurate standard deviation"))


(test-count-table-mean *test-table*)
(test-count-table-variance *test-table*)
(test-count-table-sd *test-table*)

(finalize)
