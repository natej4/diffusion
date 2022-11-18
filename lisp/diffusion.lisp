#!/usr/bin/sbcl --script
;;;; CSC330 Project 2 F22
;;;; Written by Nate Jackson
;;;; Modeling the diffusion of gas within a room


(progn
;; (declaim (type (SB-INT:INDEX) maxsize))
(defvar maxsize)
(defvar cube)
(defvar p 0)
(defvar partx)
(defvar party)
(princ "Enter value for maxsize: ")
(terpri)
(setf maxsize (read))
(princ "75% partition y/n? ")
(terpri)
(let ((temp))
	(setq temp (read))
	(if (string= temp "y")
		(setf p 1)))

(setf cube (make-array (list (+ 2 maxsize) (+ 2 maxsize) (+ 2 maxsize)))) ;the room
(setf partx (/ maxsize 2))
(setf party (* maxsize 0.5))
;;zeroing out the room
(loop for i from 0 to (1+ maxsize)
    do (loop for j from 0 to (1+ maxsize)
        do (loop for k from 0 to (1+ maxsize)
            do (if (= p 1)
                    (if (and (= i partx) (>= j party))
                        (setf (aref cube i j k) 2.0)
                        (setf (aref cube i j k) 0.0))
                (setf (aref cube i j k) 0.0)))))

(defvar diffusion_coefficient 0.175)
(defvar room_dimension 5)
(defvar speed_of_gas_molecules 250.0)
(defvar timestep)
(setf timestep (/ room_dimension speed_of_gas_molecules))
(defvar distance_between_blocks)
(setf distance_between_blocks (/ room_dimension maxsize))
(defvar DTerm  )
(setf DTerm (* diffusion_coefficient (/ timestep (* distance_between_blocks distance_between_blocks))))
;;first cell
(setf (aref cube 1 1 1) 1.0e21)

(defvar pass 0) ;conservation of mass
(defvar mytime) ;system time
(setq mytime 0.0)
(defvar myratio 0.0)

(defvar change 0.0)

(defvar sumval 0.0)
(defvar maxval )

(defvar minval )
(loop 
    (unless (< myratio 0.99)
        (return 0))
    (loop for i from 1 to maxsize
        do (loop for j from 1 to maxsize
            do (loop for k from 1 to maxsize
                do (loop for l from 1 to maxsize
                    do (loop for m from 1 to maxsize
                        do (loop for n from 1 to maxsize
                            do (when (or (and (= i l) (and (= j m)(= k (1+ n)))) 
                                    (or (and (= i l) (and (= j m) (= k (1- n))))
                                        (or (and (= i l) (and (= j (1+ m)) (= k n)))
                                            (or (and (= i l) (and (= j (1- m)) (= k n)))
                                                (or (and (= i (1+ l)) (and (= j m) (= k n)))
                                                    (and (= i (1- l)) (and (= j m) (= k n))))))))
							(if (= p 1)
								(if (and (/= (aref cube i j k) 2.0) (/= (aref cube l m n) 2.0))
                                                        		((setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))
                                                        		(setf (aref cube i j k) (- (aref cube i j k) change))
                                                        		(setf (aref cube l m n) (+ (aref cube l m n) change))))
                                                        	((setf change (* DTerm (- (aref cube i j k) (aref cube l m n)))) 
								(setf (aref cube i j k) (- (aref cube i j k) change))
                                                        (setf (aref cube l m n) (+ (aref cube l m n) change)))))))))))
(setf mytime (+ mytime timestep))



(setf maxval (aref cube 1 1 1))
(setf minval (aref cube 1 1 1))
(setq sumval 0)


(loop for i from 1 to maxsize
    do (loop for j from 1 to maxsize
        do (loop for k from 1 to maxsize
 do
            (setq maxval (max (aref cube i j k) maxval))
            (setq minval (min (aref cube i j k) minval))
            (setq sumval (+ sumval (aref cube i j k))))))
            
(setf myratio (/ minval maxval))

;;output
(format t "~f ~f" mytime (aref cube 0 0 0))
(format t " ~f"(aref cube (1- maxsize) 0 0))
(format t " ~f"(aref cube (1- maxsize) (1- maxsize) 0))
(format t " ~f"(aref cube (1- maxsize) (1- maxsize) (1- maxsize)))
(format t " ~f~%" sumval)

)
(format t "Box equilibrated in ~f seconds of simulated time.~%" mytime )
)
