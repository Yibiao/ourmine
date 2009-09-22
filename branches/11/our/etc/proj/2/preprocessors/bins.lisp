; under dev.
; * currently sorting function uses files, look into sort-field
; * the 'bins' directory is required to generate bin files

; testing function 
(deftest test-bins ()
  (let* ((nbins 10)
         (n-instances (negs (ar3)))) ; get the number of instances in the data set
      (bins (class-sort (ar3)) nbins n-instances) ; sort the data into n bins
      (build-data-sets nbins) ; build train and test data sets from the bins
  )
)

;----------------------------------------------------------
; SORTING FUNCTION - creates a file for each class of data
                 ; - all instances of that class are placed
                 ; - in that class file
; ARGUMENTS
 ; - INPUT: a table of data
 ; - OUTPUT: list of known classes, class files

; SORTING ALGORITHM
 ; read in an instance from the file
 ; if the class is unknown
    ; add to the list of known classes
 ; else
    ; write the instance to the class file

(defun class-sort (data)
  ; gather all of the instances of data
  (let ((all-instances (table-all data))
        ; locate the class column
        (classi (table-class data))
        ; count the total number of instances
        (n-instances (negs data))
        ; create a list to track class values
        (class-list (list )))

     ; for every instance, grab the class value
     (dolist (per-instance all-instances)
       (let* ((all-features (eg-features per-instance))
              (per-instance-class (nth classi all-features)))
           ; check class value against array of classes
           (if (list-search class-list per-instance-class)
               () ; if found, do nothing
               (setf class-list (append class-list (list per-instance-class))) ; if not found, add it
           )
           ; open a stream to that class file with name "stream"
           (let* ((path (make-pathname :name (format nil "~A.dat" per-instance-class)))
                  (stream (open path :direction :output
                                     :if-exists :append
                                     :if-does-not-exist :create)))
               ; write the instance to the class-file
               (doitems (per-feature i all-features)
                   (format stream "~A " per-feature))
       
               (format stream "~%")
               (close stream)))
               
      )
      ; call the bins function to sort data into bins
;     (bins class-list 10 n-instances)
      class-list
  )
)

; returns true if the argument is found in the list
(defun list-search (class-list class-arg)
  (let ((found nil))
    (dolist (per-class class-list)
        (if (equal per-class class-arg)
            (return-from list-search t)
            () ; do nothing
        )
    )
    (and found)
  )
)

;-----------------------------------------------------------
; BIN FUNCTION- places instances into n bins randomly

; ARGUMENTS
 ; - INPUT: a list of known classes, desired # of bins, total # of instances
 ; - OUTPUT: n bins of randomized data

; BIN ALGORITHM
; while the list of classes is not empty
    ; grab a class from the list of known classes
    ; for each instance of data in the class file
        ; randomly select one of the bins (files)
        ; while the bin is full
            ; move to the next bin
        ; place the value in the bin

(defun bins (class-list nbins n-instances)
  ; create an array to track instance counts in each bin 
  (let* ((bin-count (make-array nbins :initial-element (ceiling (/ n-instances nbins)))))
    ; for each class in the class list
    (dolist (class-file class-list)
        (let* ((path (make-pathname :name (format nil "~A.dat" class-file)))
               (instream (open path :direction :input))
               (rand (random nbins)) ; random bin
               (free (aref bin-count rand))) ; number of free spots in bin

            ; for each instance of data in the class file
            (loop for line = (read-line instream nil :eof) 
                  until (eql line :eof)
                 do
                    (loop until (/= free 0) ; search until a non-full bin is found
                          do
                              (setf rand (random nbins)
                                    free (aref bin-count rand))
                    )
                    ; write the instance to the bin
                    (let* ((bin-path (make-pathname 
                                     :name (format nil "./bins/~A.dat" rand)))
                           (outstream (open bin-path :direction :output
                                                     :if-exists :append
                                                     :if-does-not-exist :create)))
                        (format outstream "~A~%" line)
                        (setf (aref bin-count rand) (- (aref bin-count rand) 1)
                              rand (random nbins)
                              free (aref bin-count rand))
                        (close outstream)
                    )
            )
            (close instream)
            (delete-file path) ; clean up tmp files
        )
    )
  )
)

; constructs a test set of data from 10% of the data and
; a training set of data from 90% randomly
; the data sets are placed in test.dat and train.dat respectively
(defun build-data-sets (nfiles)
    (let* ((test (ceiling (/ nfiles 10)))
           (test-path (make-pathname :name "./bins/test.dat"))
                           (test-stream (open test-path :direction :output
                                                      :if-exists :append
                                                      :if-does-not-exist :create))
           (train-path (make-pathname :name "./bins/train.dat"))
                           (train-stream (open train-path :direction :output
                                                       :if-exists :append
                                                       :if-does-not-exist :create)))
        (loop for i from 0 to (- test 1)
              do 
                  (let* ((path (make-pathname :name (format nil "./bins/~A.dat" i)))
                          (instream (open path :direction :input)))
                  (loop for line = (read-line instream nil :eof)
                      until (eql line :eof)
                      do
                          (format test-stream "~A~%" line)
                  )
                  (delete-file path))
        )
        (close test-stream)

       (loop for i from test to (- nfiles 1)
              do
                  (let* ((path (make-pathname :name (format nil "./bins/~A.dat" i)))
                         (instream (open path :direction :input)))
                  (loop for line = (read-line instream nil :eof)
                      until (eql line :eof)
                      do
                          (format train-stream "~A~%" line)
                  )
                  (delete-file path))
        )
        (close train-stream)
    ) 
)
