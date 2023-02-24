;; clarity-basics-ii

;; Day 8 - Optionals & Parameters
(define-read-only (show-some-i) 
    (some u2)
)
(define-read-only (show-none-ii) 
    none 
)
(define-read-only (params (num uint) (string (string-ascii 48)) (boolean bool)) 
    num
)
(define-read-only (params-optional (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)) ) 
    num
)

;; Day 9 -  Optionals Part II
(define-read-only (is-some-example (num (optional uint))) 
    (is-some num)
)

(define-read-only (is-none-example (num (optional uint))) 
    (is-none num)
)

(define-read-only (params-optional-and (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)) ) 
    (and
        (is-some num)
        (is-some string)
        (is-some boolean)
    )
)

;; Day 10 - Constants & Intro to Variables
(define-constant fav-num u10)
(define-constant fav-string "Jesus")
(define-read-only (show-constant) 
    fav-string
)

(define-read-only (show-constant-double) 
    (* fav-num u2)
)
