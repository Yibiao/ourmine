(defun discrete-column (col)
   (make-discrete :name (header-name col) :classp (header-classp col)
                  :ignorep (header-ignorep col)))

(defun chop-it-up (record bins i column mean stddev &key (base 3))
  (when (funcall (directional-compare i)
                 (nth column (eg-features record))
                 (+ mean (* (directional-integer i) stddev)))
    (add (aref bins (+ base i))
         (nth column (eg-features record)))
    (setf (nth column (eg-features record)) i)
    (return-from chop-it-up t))
  nil)

(defun chopscan (record bins column mean stddev &key (start -3) (end 3))
  (macrolet ((chop-trampoline (i)
               `(when (chop-it-up record bins ,i column mean stddev :base (* -1 start))
                  (return-from chopscan bins))))
    (loop for i from start upto 0 do (chop-trampoline i))
    (loop for i from end downto 1 do (chop-trampoline i))))

(defun normal-chops (tbl)
  (let (normval
        (bins (make-array 7))
        std
        m
        (n 0))
    (init-bins bins 7)
    (dolist (column (table-columns tbl))
      (when (typep column 'numeric)
        (setf normval (fill-normal tbl n))
        (setf std (stdev normval))
        (setf m (mean normval))
        (dolist (record (table-all tbl))
          (chopscan record bins n m std))
        (push (build-bin-list bins) (table-ranges tbl))
        (init-bins bins 7))
      (setf (nth n(table-columns tbl))(discrete-column column))
      (incf n))
                 
      
      (setf (table-ranges tbl) (reverse (table-ranges tbl)))
      tbl))

 