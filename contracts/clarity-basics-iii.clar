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

;; Day 22 - Unwrapping
;; Unwrap Methods 
;; Unwrap - (Unwrap! optional | response throw-value): The standard for unwrapping an optional or response with a specific error / throw value
;; Unwrap-Err - (Unwrap-err! response throw-value): If response is an (err...) it'll unwrap the error value, else it'll return the throw value
;; Unwrap-Panic - (Unwrap-panic optional | response): Unwrapped if (some..) | (ok..) else this throws a runtime error
;; Unwrap-Err-Panic - (Unwrap-error-panic response): Unwrapped if response is an (err...), else this throws a runtime error.

(define-public (unwrap-example (new-num uint)) 
  (ok (var-set list-day-21 
        (unwrap! 
            (as-max-len? (append (var-get list-day-21) new-num) u5) 
         (err "error list at max-length"))
  ))
)

(define-public (unwrap-panic-example (new-num uint)) 
  (ok (var-set list-day-21 
        (unwrap-panic 
            (as-max-len? (append (var-get list-day-21) new-num) u5))
  ))
)

(define-public (unwrap-err-example (input (response uint uint))) 
    (ok (unwrap-err! input (err u10)))
)
(define-public (try-example (input (response uint uint))) 
   (ok (try! input))
)   

;; Unwrap! - Optionals & Response
;; Unwrap-err - response
;; Unwrap-panic - Optional & response
;; Unwrap-err-panic - optional & response
;; Try! - Optional & response
