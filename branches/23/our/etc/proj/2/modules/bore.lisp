; bore.lisp
;
; Implements the BORE pre-processor.
(defun bore (dataset columnnames)
  (let* ((normalvals (make-array (length columnnames) :initial-element (make-normal)))
	 (datatable (copy-table dataset))
         (returntable)
	 (index ())
	 (n 0)
	 (x 0)
	 (y 0)
	 (colname)
	 (fields ())
	 )
    (dolist (columns (table-columns datatable))
      (setf colname (header-name columns))
	(dolist (name columnnames)
	  (if (equal colname name)   
	      (progn
	       (dolist (record (table-all datatable))
		(setf index (eg-features record))
		(setf x (nth n index))
		(add (aref normalvals y) x))
	       (setf (table-columns datatable) (append (table-columns datatable)
				        `(,(make-numeric :name y :ignorep nil :classp nil))))
	       (dolist (record (table-all datatable))
		 (setf (eg-features record) (append (eg-features record) `(, (normalize (aref normalvals y)
					(nth n (eg-features record)))))))
	      (incf y))
	      ))
	(incf n))

    (setf (table-columns datatable) (append (table-columns datatable)
					    `(,(make-numeric :name "w" :ignorep nil :classp nil))))
    (dolist (record (table-all datatable))
      (dotimes (z y)
	(setf fields (append fields `(,(nth (+ z n) (eg-features record))))))
      (setf (eg-features record) (append (eg-features record) `(,(borew fields)))))


;    (setf returntable (sortw datatable (+ n y)))
 ;     (nth (+ y n) (eg-features record))
 ;  (format t "~a ~%" returntable)
 ;  (dolist (record (table-all datatable))
 ;    (format t "~a ~%" (> (nth (+ n y) (eg-features record)) (nth (+ n y) (eg-features (car (table-all datatable)))))))
   (format t "~a ~%" (display-table-simple (best-rest datatable)))
   ))


(defun borew (cols)
  (let ((w nil)
	(sumofsquares 0)
	)
    (dolist (num cols)
      (setf sumofsquares (+ sumofsquares (square num))))
    (setf w (- 1 (/ (sqrt sumofsquares) (sqrt (length cols)))))
    w))

(defun sortw (tbl n)
  (let ((rtntable)
        (alist)
        (k 0))
    (setf rtntable (make-table :name (table-name tbl) :columns (table-columns tbl) :class (table-class tbl)))
    (format t "~a ~%" (type-of (list (car (table-all tbl)))))
    (dolist (record (table-all tbl))
      (if (eql (table-all rtntable) nil)
          (setf (table-all rtntable) (list (car (table-all tbl))))    
          (progn
            (dotimes (k (negs tbl))
              (if (>= (nth n (eg-features record)) (nth n (eg-features (car (table-all rtntable)))))
                  (progn
                    (setf k (+ 100 (negs tbl)))                  
                    (if (eql alist nil)
                        (setf (table-all rtntable) (cons record (table-all rtntable)))
                        (setf (table-all rtntable) (cons alist (cons record (table-all rtntable))))))
                  (progn
                    (format t "~a ~%~%" (cdr (table-all rtntable)))
                    (setf alist (append alist `(,(car (table-all rtntable)))))
                    (if (not (eql (cdr (table-all rtntable)) nil))                         
                        (setf (table-all rtntable) (cdr (table-all rtntable))) ;this line doesnt work and needs to
                        (progn
                          (setf k (+ 100 (negs tbl)))
                          (setf (table-all rtntable) (append alist `(,record))))))))
            (setf k 0)
            (setf alist nil)))
      )
      rtntable)) 
