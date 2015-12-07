(load "table-gen.lisp")
(setq output (gen-frequency-table *standard-input*))
(maphash #'(lambda (key value) (format t "(~A ~A)~%" key value))
	 output)