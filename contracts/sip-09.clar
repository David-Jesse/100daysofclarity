;; SIP-09
;; Implementing SIP-09 locally so we can work with NFTs correctly
;;  Written by David-Jesse
;; Day 51 - Introduction to Traits & SIP-09 (NFTs)

(define-trait nft-trait 
    (
        ;; last token ID
        (get-last-token-id () (response uint uint))
        ;; URI metadata
        (get-token-uri (uint) (response (optional (string-ascii 256)) uint)) 
        ;; Get Owner
        (get-owner (uint) (response (optional principal) uint))
        ;; Transfer
        (transfer (uint principal principal) (response bool uint))
    )
)
