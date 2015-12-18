(in-package :cl-user)
(defpackage stroop.web
  (:use :cl
        :caveman2
        :stroop.config
        :stroop.view
        :stroop.db
	:stroop.colorize
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


