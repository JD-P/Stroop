(in-package :cl-user)
(defpackage stroop-asd
  (:use :cl :asdf))
(in-package :stroop-asd)

(defsystem stroop
  :version "0.1"
  :author "John David Pressman"
  :license ""
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop

               ;; for @route annotation
               :cl-syntax-annot

               ;; HTML Template
               :djula

               ;; for DB
               :datafly
               :sxql

	       ;; for HTML requests and parsing
	       :drakma
	       :closure-html
	       :split-sequence)
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "parse-print" "colorize"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config")
		 (:file "parse-print")
		 (:file "colorize"))))
  :description ""
  :in-order-to ((test-op (load-op stroop-test))))
