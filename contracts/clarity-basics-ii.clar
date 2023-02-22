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