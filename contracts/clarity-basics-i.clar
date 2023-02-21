;; Clarity Basics I
;; Day 3 - Booleans and Read-only
;; Day 4 - Uints, Ints and Simple Operators
;; Here we are to review the basics of clarity

(define-read-only (show-true-i) 
    true
)

(define-read-only (show-false-i)
    false
)

(define-read-only (show-true-ii) 
    (not false)
)

(define-read-only (show-false-ii)
    (not true)
)

;; Day 4
(define-read-only (add) 
    (+ u1 u1)
)
(define-read-only (substract) 
    (- 1 2)
)
(define-read-only (multiply) 
    (* u44 u2)
)
(define-read-only (divide)
    (/ u4 u2)
)
(define-read-only (uint-to-int) 
    (to-int u4)
)
(define-read-only (int-to-uint) 
    (to-uint 4)
)