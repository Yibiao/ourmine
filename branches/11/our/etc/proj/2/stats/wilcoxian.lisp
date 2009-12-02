(defun wilcoxon(pop1 pop2 level)
  (let* ((diff (make-list (length pop1)))
         (absDiff (make-list (length pop1)))
         (n 0))
    (doitems (onePop i pop1)
      (incf n)
      (setf (nth i diff) (- onePop (nth i pop2)))
      (setf (nth i absDiff) (abs (- onePop (nth i pop2)))))
    (let ((ranks (rank absDiff))
           (w0 0)
           (w 0))
      (doitems (oneAbsDiff i absDiff)
        (setf w0 (gethash (nth i absDiff) ranks))
        (setf w (+ w (if (< (nth i diff) 0)
                 (* -1 w0)
                 0))))
      (let* ((sigma-value (sigma n))
             (z-value (z w sigma-value)))
        (if (and
             (>= z-value 0)
             (<= z-value (z-critical level)))
            NIL
            T)))))
            
(defun sigma(n)
  (sqrt (/ (* n (+ n 1)(+ (* 2 n) 1)) 6)))

(defun z(w sigma)
  (/ (- w 0.5) sigma))

(defun z-critical(&optional (level 0.05))
  (if (eql 0.10 level)
      1.645
      (if (eql 0.05 level)
          1.960
          (if (eql 0.01 level)
              2.576))))

(defun rank (l &key (ranks (make-hash-table)) (n 0))
  (if (null l)
      ranks
      (let (repeats sum now)
        (labels ((walk () (incf n) (pop l))
                 (new  () (setf repeats 1) (setf sum n))
                 (same () (incf sum n) (incf repeats))
                 (spin () (when (eql now (car l))
                            (walk) (same) (spin))))
          (setf now (walk))
          (new)
          (spin)
          (setf (gethash now ranks) (/ sum repeats))
          (rank  l :ranks ranks :n n )))))

