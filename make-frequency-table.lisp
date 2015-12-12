(load "table-gen.lisp")
(setq output (gen-frequency-table *standard-input*))
(loop for key being the hash-keys in output using (hash-value value) 
   do (format t "(~A ~A)~%" key value))