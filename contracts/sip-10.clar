;; SIP-10
;; Implementing SIP-10 locally so we can work with FTs correctly
;;  Written by David-Jesse
;; Day 75 - Introduction to Traits & SIP-10 (FTs)

(define-trait ft-trait 
    (
        ;; Transfer from principal to principal
        (transfer (uint principal principal (optional (buff 34))) (response bool uint))

        ;; Human-readable name of the token
        (get-name () (response (string-ascii 32) uint))

        ;; Human-readable symbol
        (get-symbol () (response (string-ascii 32) uint))

        ;; Number of decimals used to represent the token
        (get-decimals () (response uint uint))

        ;; Balance
        (get-balance (principal) (response uint uint))

        ;; Current total supply
        (get-total-supply () (response uint uint))

        ;; Optional URI for metadata
        (get-token-uri () (response (optional (string-ascii 356)) uint))
        
    )
)

