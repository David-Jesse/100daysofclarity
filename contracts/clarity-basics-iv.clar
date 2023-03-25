;; title: clarity-basics-iv
;; Reviewing more clarity fundamentals
;; Written by David-Jesse

;; Day 26.5 - Let
;; Function that allows the initialization/management of local variables and allows for multiple functions within a body return the value of the last function

;; (let
;;    (
        ;; Local vars are created/ stored
;;        (test-var u0)
;;    )

;;      body (function1)
;;       (function2)
;; )

(define-data-var counter uint u0)
(define-map counter-history uint { user: principal, count: uint })

(define-public (increase-count-begin (increase-by uint)) 
    (begin 

        ;; Assert that tx-sender is not previous counter-history user
        (asserts! (is-eq  (some tx-sender) (get user (map-get? counter-history (var-get counter)))) (err u0))

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

;; Day 32 - Syntax
;; trailing (marked by heavy parenthesis)
;; Encapsulated (highlights internal functions)

;; Day 33 - STX-Transfer
(define-public (send-stx-single) 
    (stx-transfer? u1000000 tx-sender 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND)
)
(define-public (send-stx-double) 
   (begin 
        (unwrap! (stx-transfer? u1000000 tx-sender 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND) (err u0))
        (stx-transfer? u1000000 tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
   )
)

;; Day 34 - Stx-get-balance & Stx-burn
;; Stx-get-balance
(define-read-only (balance-of) 
    (stx-get-balance tx-sender)
)
(define-public (send-stx-balance) 
    (stx-transfer? (stx-get-balance tx-sender) tx-sender 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND)
)
(define-public (burn-some (amount uint)) 
    (stx-burn? amount tx-sender)
)
(define-public (burn-half-of-balance) 
    (stx-burn? (/ (stx-get-balance tx-sender) u2) tx-sender)
)

;; Day 35 - Block-height
;; Tx-sender: A keyword used to temporarily store the principal that signed or kicked off a transaction
;; Block-height: Returns the block height of the stacks blockchain as an unsigned integer
(define-read-only (read-current-height) 
    block-height
)
(define-constant day-in-blocks u144)
(define-read-only (has-a-day-passed) 
    (if (> block-height day-in-blocks) 
        true
        false
     )
)