(in-package :cl-user)
(defpackage stroop-test-asd
  (:use :cl :asdf))
(in-package :stroop-test-asd)

(defsystem stroop-test
  :author "John David Pressman"
  :license ""
  :depends-on (:stroop
               :prove)
  :components ((:module "t"
                :components
                ((:file "stroop"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
