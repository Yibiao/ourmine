(defun appendl (a b) (append a (list b)))

(defun abs (x) (if (< x 0) (* -1 x) x))

(defun sum (l)
  "Computes the sum of a list of numbers."
  (let ((sum 0))
    (dolist (x l sum)
      (incf sum x))))

(defun mean (&rest nums)
  (/ (apply #'+ nums)
     (length nums)))

(defun median (l &optional (n (length l)))
  (let* ((sorted (sort l #'<))
	 (midv   (floor (/ n 2)))
	 (midpos (nth midv sorted)))
    (if (oddp n)
	midpos
	(mean  midpos
	       (nth (1- midv) sorted)))))

(defun lt (x y)
  (string< (format nil "~a" x) (format nil "~a" y)))

(defun flatten (lis)
  "Removes nestings from a list."
  (cond
    ((atom lis)        lis)
    ((listp (car lis)) (append (flatten (car lis))
			       (flatten (cdr lis))))
    (t                 (append (list (car lis))
			       (flatten (cdr lis))))))

(defun nchars (n &optional (char #\Space))
  (with-output-to-string (s)
    (dotimes (i n)
      (format s "~a" char))))

(defun visit (f l)
  (if (atom l)
      (funcall f l)
      (dolist (x l)
	(visit f x))))

(defun percentiles (l &optional (collect '(0 25 50 75 100)))
  "one pass through a list of nums to 'collect' some percentiles"
  (let* (out
	 last
	 (size (length l)))
    (doitems (one pos l out)
      (if (null collect)
	  (return-from percentiles out))
      (let ((want (first collect))
	    (progress (* 100.0 (/ (1+ pos) size))))
	(if (>= progress want)
	    (push (cons (pop collect)
			(if (= progress want)
			    one
			    (mean one (or last one))))
		  out)))
      (setf last one))))



(deftest !percentiles ()
  (test
   (percentiles '(1 2 3 4 5 6 7 8 9 10)
		'(0 25 50 75 100)
		)
   '((100 . 10)
     (75 . 15/2)
     (50 . 5)
     (25 . 5/2)
     (0 . 1))))