(defun keep-cols (table keep-cols)
  (let* ((data (table-egs-to-lists table))
         (newdata '())
         (keep-cols (append keep-cols (list (table-class table))))
         (temprow))
    (dolist (instance data)
      (dotimes (col (length (car data)))
        (if (find col keep-cols)
            (setf temprow (append temprow (list (nth col instance))))))
      (setf newdata (append newdata (list temprow)))
      (setf temprow '()))
    newdata))


(defun keep-columns (table keep-these)
  (let* ((columns (table-columns table))
         (kept-cols '()))
    (dolist (n keep-these kept-cols)
      (setf kept-cols (append kept-cols (list (nth n columns)))))))


(defun get-common-cols (ar shared)
  (let* ((ar-cols '(0 9 12 11 10 14 16 2 3 6 5 8 7 17))
         (shared-cols '(0 1 2 4 5 6 8 10 12 13 15 16 17 18))
         (ar-cols (append ar-cols (list (table-class ar))))
         (shared-cols (append shared-cols (list (table-class shared))))
         (data1 (keep-cols ar ar-cols))
         (data2 (keep-cols shared shared-cols))
         (newtables))
    (setf newtables (append newtables (list (make-simple-table (table-name ar) (keep-columns ar ar-cols) data1))))
    (setf newtables (append newtables (list (make-simple-table (table-name shared) (keep-columns shared shared-cols) data2))))
    newtables))
    
            
