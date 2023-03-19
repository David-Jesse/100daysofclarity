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
            count: (+ increase-by (get count (unwrap! (map-get? counter-history (var-get counter)) (err u1))))
        })

        ;; Var-set Increase counter
        (ok (var-set counter (+ (var-get counter) u1)))
     )
)

(define-public (increase-count-let (increase-by uint)) 
    (let 
     (
        ;;Local variables
        (current-counter (var-get counter))
        (current-counter-history (default-to {user: tx-sender, count: u0} (map-get? counter-history current-counter)))
        (previous-counter-user (get user current-counter-history))
        (previous-count-amount (get count current-counter-history))

       )
        ;; Assert that tx-sender is *not* previous counter-history user
        (asserts! (not (is-eq tx-sender previous-counter-user)) (err u0))

        ;; Var-set counter-history
        (map-set counter-history current-counter 
            {
                user: tx-sender,
                count: (+ increase-by previous-count-amount)
            }
        )

        ;; Var-set increase-counter
        (ok (var-set counter (+ u1 current-counter)))
        
    )


)
