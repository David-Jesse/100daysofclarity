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

;; Day 5 - Advanced Operators
(define-read-only (exponent) 
    (pow 2 3)
)
(define-read-only (square-root)
    (sqrti u9)
)

(define-read-only (modulo) 
    (mod u10 u4)
)

(define-read-only (logTwo) 
    (log2 (* u2 u8))
)

(define-read-only (add-substract) 
    (-
        (* 5 4)
        (+ 5)
    )
)

;; Day 6 - Strings
(define-read-only (say-hello) 
    "Hello"
)
(define-read-only (say-hello-world) 
    (concat "Hello" " World")
)

(define-read-only (say-hello-world-name) 
   (concat 
   (concat "Hello" " World,")  
   " Jesse"
   )
)