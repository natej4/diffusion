#!/usr/bin/sbcl --script
;;;; CSC330 Project 2 F22
;;;; Written by Nate Jackson
;;;; Modeling the diffusion of gas within a room

;; (declaim (sb-ext:muffle-conditions sb-ext:compiler-note))

(progn
(defconstant maxsize 10) ;const for room size
(defvar cube (make-array '(10 10 10))) ;the room
;;zeroing out the room
(loop for i from 0 to (1- maxsize)
    do (loop for j from 0 to (1- maxsize)
        do (loop for k from 0 to (1- maxsize)
            do (setf (aref cube i j k) 0.0))))

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
(setf (aref cube 0 0 0) 1.0e21)

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
    (loop for i from 0 to (1- maxsize)
        do (loop for j from 0 to (1- maxsize)
            do (loop for k from 0 to (1- maxsize)
                do (loop for l from 0 to (1- maxsize)
                    do (loop for m from 0 to (1- maxsize)
                        do (loop for n from 0 to (1- maxsize)
                            do (when (or (and (= i l) (and (= j m)(= k (1+ n)))) 
                                    (or (and (= i l) (and (= j m) (= k (1- n))))
                                        (or (and (= i l) (and (= j (1+ m)) (= k n)))
                                            (or (and (= i l) (and (= j (1- m)) (= k n)))
                                                (or (and (= i (1+ l)) (and (= j m) (= k n)))
                                                    (and (= i (1- l)) (and (= j m) (= k n))))))))
                                                        (setf change (* DTerm (- (aref cube i j k) (aref cube l m n))))
                                                        (setf (aref cube i j k) (- (aref cube i j k) change))
                                                        (setf (aref cube l m n) (+ (aref cube l m n) change)))))))))
(setf mytime (+ mytime timestep))



(setf maxval (aref cube 0 0 0))
(setf minval (aref cube 0 0 0))


(loop for i from 0 to (1- maxsize)
    do (loop for j from 0 to (1- maxsize)
        do (loop for k from 0 to (1- maxsize) do
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