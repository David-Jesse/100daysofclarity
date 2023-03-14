;; Day 20
;; title: clarity-basics-iii
(define-read-only (list-bool) 
    (list true false true)
)

(define-read-only (list-int) 
    (list u2 u3 u5)
)

(define-read-only (list-string) 
    (list "Hey" "gorgeous")
)

(define-read-only (list-principal) 
    (list tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG )
)

(define-data-var num-list (list 10 uint) (list u1 u4 u3 u2))
(define-data-var principal-list (list 5 principal) (list tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG ))

;; Element-At (index -> value)
;; Element-At function returns an optional
(define-read-only (element-at-num-list (index uint)) 
    (element-at (var-get num-list) index)
)

(define-read-only (element-at-principal-list (index uint)) 
    (element-at (var-get principal-list) index)
)

;; Index-Of (value -> index)
;; Also returns an optional
(define-read-only (index-of-num-list (item uint)) 
    (index-of (var-get num-list) item)
)

(define-read-only (index-of-principal-list (item principal)) 
    (index-of (var-get principal-list) item)
)

;; Day 21 - Lists contd. & Intro to Unwrapping
(define-data-var list-day-21 (list 5 uint) (list u1 u2 u3 u4))
(define-read-only (list-length)
    (len (var-get list-day-21))
)

(define-public (add-to-list (new-num uint)) 
  (ok (var-set list-day-21 
        (unwrap! (as-max-len? (append (var-get list-day-21) new-num) u5) 
            (err u0))
  ))
)