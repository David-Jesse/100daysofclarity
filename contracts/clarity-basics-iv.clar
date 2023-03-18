;; title: clarity-basics-iv
;; Reviewing more clarity fundamentals
;; Written by David-Jesse

;; Day 26.5 - Let
;; Function that allows the initialization/management of local variables and allows for multiple functions within a body return the value of the last function

(define-data-var counter uint u0)
(define-map counter-history uint { user: principal, count: uint })

(define-public (increase-count-begin (increase-by uint)) 
    (begin 

        ;; Assert that tx-sender is not previous counter-history user
        (asserts! (is-eq (some tx-sender) (get user (map-get? counter-history (var-get counter)))) (err u0))

        ;; Var-set counter history
        (map-set counter-history (var-get counter) {
            user: tx-sender,
            count: (+ increase-by (get count ( (unwrap! (map-get? counter-history (var-get counter))) (err u1))))
        })

        ;; Var-set Increase counter
        (ok (var-set counter (+ (var-get counter) u1)))
     )
)
