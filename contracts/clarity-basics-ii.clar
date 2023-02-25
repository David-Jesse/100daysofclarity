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
(define-constant fav-string "Hi,")
(define-data-var fav-num-var uint u12)
(define-data-var your-name (string-ascii 24) " Jesse")

(define-read-only (show-constant) 
    fav-string
)

(define-read-only (show-constant-double) 
    (* fav-num u2)
)

(define-read-only (show-fav-num-var) 
    (var-get fav-num-var)
)
(define-read-only (show-var-double) 
    (* u2 (var-get fav-num-var))
)
(define-read-only (say-hi) 
    (concat fav-string (var-get your-name))
)

;; Day 11 - Public Functions & Responses
(define-read-only (response-example) 
    (ok u26)
)
(define-public (change-name (new-name (string-ascii 24))) 
    (ok (var-set your-name new-name))
)
(define-public (change-fav-num (new-num uint)) 
    (ok (var-set fav-num-var new-num))
)