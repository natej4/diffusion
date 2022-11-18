#!/usr/bin/sbcl --script
;;;; CSC330 Project 2 F22
;;;; Written by Nate Jackson
;;;; Modeling the diffusion of gas within a room
;;;; 11-18-2022


(progn
(defvar maxsize);Number of cells that make up the room
(defvar cube)
(defvar p 0)
(defvar partx)
(defvar party)
;; user input
(princ "Enter value for maxsize: ")
(terpri)
(setf maxsize (read))
(princ "75% partition y/n? ")
(terpri)
(let ((temp))
	(setq temp (read))
    (princ temp)
    (terpri)
	(if (string= temp "Y")
		(setf p 1)))

(setf cube (make-array (list (+ 2 maxsize) (+ 2 maxsize) (+ 2 maxsize)))) ;the room
;; setting location of partition
(setf partx (floor(* (+ maxsize 1) 0.5)))
(setf party (floor(* (+ maxsize 1) 0.5)))

;;zeroing out the room
(loop for i from 0 to (1+ maxsize)
    do (loop for j from 0 to (1+ maxsize)
        do (loop for k from 0 to (1+ maxsize)
            do 
                (setf (aref cube i j k) 0.0))))
;; creation of partition
(when (= p 1)
    (loop for i from 0 to (1+ maxsize)
        do (loop for j from 0 to (1+ maxsize)
            do (loop for k from 0 to (1+ maxsize)
                do (if (and (= i partx) (>= j party))
                            (setf (aref cube i j k) 2.0))))))
;; variable declaration
(defvar diffusion_coefficient 0.175)
(defvar room_dimension 5)
(defvar speed_of_gas_molecules 250.0)
(defvar timestep)
(setf timestep (/ room_dimension speed_of_gas_molecules))
(defvar distance_between_blocks)
(setf distance_between_blocks (/ room_dimension maxsize))
(defvar DTerm  )
(setf DTerm (* diffusion_coefficient (/ timestep (* distance_between_blocks distance_between_blocks))))
(defvar mytime) ;system time
(setq mytime 0.0)
(defvar myratio 0.0)
(defvar change 0.0)
(defvar sumval 0.0)
(defvar maxval )
(defvar minval )

;;first cell
(setf (aref cube 1 1 1) 1.0e21)
(loop 
    (unless (< myratio 0.99)
        (return 0))
;;diffusion process
    (loop for i from 1 to maxsize
        do (loop for j from 1 to maxsize
            do (loop for k from 1 to maxsize
                do (loop for l from 1 to maxsize
                    do (loop for m from 1 to maxsize
                        do (loop for n from 1 to maxsize
                            ;;determine if cells are next to each other
                            do (when (or (and (= i l) (and (= j m)(= k (1+ n)))) 
                                    (or (and (= i l) (and (= j m) (= k (1- n))))
                                        (or (and (= i l) (and (= j (1+ m)) (= k n)))
                                            (or (and (= i l) (and (= j (1- m)) (= k n)))
                                                (or (and (= i (1+ l)) (and (= j m) (= k n)))
                                                    (and (= i (1- l)) (and (= j m) (= k n))))))))
							(when (= p 1)
								(when (and (/= (aref cube i j k) 2.0) (/= (aref cube l m n) 2.0))
                                    (setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))
                                    (setf (aref cube i j k) (- (aref cube i j k) change))
                                    (setf (aref cube l m n) (+ (aref cube l m n) change))))
                            (when (/= p 1)
                                (setf change (* DTerm (- (aref cube i j k) (aref cube l m n)))) 
								(setf (aref cube i j k) (- (aref cube i j k) change))
                                (setf (aref cube l m n) (+ (aref cube l m n) change))))))))))
(setf mytime (+ mytime timestep))

;;checking to see if room is rully diffused
(setf maxval (aref cube 1 1 1))
(setf minval (aref cube 1 1 1))
(setq sumval 0)

(loop for i from 1 to maxsize
    do (loop for j from 1 to maxsize
        do (loop for k from 1 to maxsize
            do (when (/= (aref cube i j k) 2)
                (setq maxval (max (aref cube i j k) maxval))
                (setq minval (min (aref cube i j k) minval))
                (setq sumval (+ sumval (aref cube i j k)))))))
             
(setf myratio (/ minval maxval))

;;output
(format t "~f ~f" mytime (aref cube 1 1 1))
(format t " ~f"(aref cube maxsize 1 1))
(format t " ~f"(aref cube maxsize maxsize 1))
(format t " ~f"(aref cube maxsize maxsize maxsize))
(format t " ~f~%" sumval);monitors conservation of mass

)
(format t "Box equilibrated in ~f seconds of simulated time.~%" mytime )
)
