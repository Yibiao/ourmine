(defparameter *files* '(
                        "tests/deftest"
                        "data/ar3"
                        "tricks/lispfuns"
                        "tricks/macros"
                        "tricks/number"
                        "tricks/string"
                        "tricks/list"
                        "tricks/hash"
                        "tricks/random"
                        "tricks/normal"
                        "tricks/caution"
                        "table/structs"
                        "table/header"
                        "table/data"
                        "table/table"
                        "table/xindex"
                        "preprocessors/bins"
                        "preprocessors/numericvalue"
                        ))

(defun make1 (files)
  (let ((n 0))
    (dolist (file files)
      (format t ";;;; ~a.lisp~%"  file)
      (incf n)
      (load file))
    (format t ";;;; ~a files loaded~%" n)))

(defun make (&optional (verbose nil))
  (if verbose
      (make1 *files*)
      (handler-bind
          ((style-warning #'muffle-warning))
        (make1 *files*))))

(make)

