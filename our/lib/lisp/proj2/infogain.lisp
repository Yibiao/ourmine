(defun infogain (data &optional (n 5))
  (let* ((vals)
	(classvals (get-class-values data))
	(classcnt (length data))
	(tmpres)
	(tmpsum 0)
	(tmpdiv)
	(final)
	(presplit)
	(info 0)
	(infogains))
    (dotimes (col (- (length (car data)) 1) infogains)
      (setf vals (get-vals data col) tmpres '() tmpsum 0 tmpdiv '() final '() info 0)     
      (dolist (val vals)
	(setf tmpres '())
	(dolist (classval classvals)
	  (setf tmpres (append tmpres (list (class-count-with-val val col classval data)))))
	(setf tmpsum (apply #'+ tmpres))
	(setf tmpdiv '())
	(dolist (res tmpres)
	  (setf tmpdiv (append tmpdiv (list (float (/ res tmpsum))))))
	;;works on assoc list eg. (5/14 . entropy of 5/14, 9/14)
	(setf final (append final (list (append (list (float (/ tmpsum classcnt))) (entropy tmpdiv))))))
    (setf presplit (extract-before-splitting classvals data))
    (setf tmpsum (apply #'+ presplit))
    (setf tmpres '())
    (dolist (res presplit)
      (setf tmpres (append tmpres (list (float (/ res tmpsum))))))
    (setf infogains (append infogains (list (weighted-sum (entropy tmpres) final)))))))
    ;(format t "~a " (weighted-sum (entropy tmpres) final)))))
    

;;produce weighted sum, i.e 5/14 * 0.971 (entropy of 2/5, 3/5) + ...
(defun weighted-sum (unsplit split)
  (let ((sum 0))
    (dolist (group split (- unsplit sum))
      (incf sum (* (first group) (cdr group))))))

;;assume class is last col... only works on binary classes!	
(defun extract-before-splitting (classvals data)
  (let ((classvalcounts)
	(acnt 0)
	(bcnt 0)
	(class (car classvals)))
    (dolist (row data)
	(if (equal (nth (- (length row) 1) row) class)
	    (incf acnt)
	    (incf bcnt)))
    (setf classvalcounts (list acnt bcnt))
    classvalcounts))
  
;;assumes class is last col in row
(defun class-counts (data classes)
  (let ((count 0)
	(cntlist '()))
    (dolist (class classes cntlist)
      (setf count 0)
      (dolist (row data)
	(if (equal (nth (- (length row) 1) row) class)
	    (incf count)))
      (setf cntlist (append cntlist (list count))))))

;;gets column values
(defun get-vals (data colnum)
  (let ((vals '()))
    (dolist (i data vals)
      (if (not (contains vals (nth colnum i)))
	  (setf vals (append vals (list (nth colnum i))))))))

(defun contains (lst val)
  (dotimes (i (length lst))
    (if (equal (nth i lst) val)
	(return-from contains t)))
  nil)

;;takes entropy of list of items
(defun entropy (vals)
  (let ((ent 0))
    (dolist (i vals (abs ent))
      (if (> i 0)
      (setf ent (- ent (* (* -1 i) (log i 2))))))))

;;multiple classes are extracted here based on a list of column numbers of classes
(defun get-class-values (data &optional (colnumlist (list (- (length (car data)) 1))))
  (let ((classvals '()))
    (dolist (i colnumlist classvals)
      (dolist (row data)
	(if (not (contains classvals (nth i row)))
	    (setf classvals (append classvals (list (nth i row)))))))))

;;assume class is end of row
(defun class-count-with-val (val colnum classval data)
  (let ((count 0))
    (dolist (row data count)
      (if (and (equal (nth colnum row) val)
	       (equal (nth (- (length row) 1) row) classval))
	  (incf count)))))
      	    
;; test data; weather.nominal
(setf weather '(
	     (sunny hot high FALSE no)
	     (sunny hot high TRUE no)
	     (overcast hot high FALSE yes)
	     (rainy mild high FALSE yes)
	     (rainy cool normal FALSE yes)
	     (rainy cool normal TRUE no)
	     (overcast cool normal TRUE yes)
	     (sunny mild high FALSE no)
	     (sunny cool normal FALSE yes)
	     (rainy mild normal FALSE yes)
	     (sunny mild normal TRUE yes)
	     (overcast mild high TRUE yes)
	     (overcast hot normal FALSE yes)
	     (rainy mild high TRUE no)))

(setf weather-num '(
		     (2 0 6 2 yes)
		     (0 8 0 0 yes)
		     (0 1 3 3 no)
		     (0 0 4 2 yes)
		     (2 0 0 2 no)
		     (3 1 4 2 yes)))
