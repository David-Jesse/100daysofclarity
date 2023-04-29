;; Simple FT
;; Our very first FT implementation
;; Day 77

;; FT - ClarityToken, supply of 100
;; Every principal can claim 1 CT, once

(impl-trait .sip-10.ft-trait)

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Define Fungible Token
(define-fungible-token clarity-token u100)

;; Human-readable name
(define-constant name "ClarityToken")

;; Human-readable symbol
(define-constant symbol "CT")

;; Token decimals
(define-constant decimals u0)

;; Claim Map
(define-map can-claim principal bool)


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Can claim
(define-read-only (get-claim-status (wallet principal)) 
    (default-to true (map-get? can-claim wallet))
)

;;;;;;;;;;;;
;; SIP-10 ;;
;;;;;;;;;;;;

;; Transfer
(define-public (transfer (amount uint) (sender principal) (recipient principal) (note (optional (buff 64))))
    (ft-transfer? clarity-token amount sender recipient)    
)

;; Get Token Name
(define-public (get-name) 
    (ok name)
)

;; Get Token Symbol
(define-public (get-symbol) 
    (ok symbol)
)

;; Get Token Decimals
(define-public (get-decimals) 
    (ok decimals)
)

;; Get Token Balance
(define-public (get-balance (wallet principal)) 
    (ok (ft-get-balance clarity-token wallet))
)

;; Get Token URI
(define-public (get-token-uri) 
    (ok none)
)

;; Get Total supply
(define-public (get-total-supply) 
    (ok (ft-get-supply clarity-token))
)

;; Day 78
;;;;;;;;;;
;; Mint ;;
;;;;;;;;;;

(define-public (claim-ct) 
    (let       
        (
            (current-claim-status (get-claim-status tx-sender))
        )
            ;; Assert that current-claim-status is true
            (asserts! current-claim-status (err "err-already-claimed"))

            ;; Mint 1 CT to tx-sender
            (unwrap! (ft-mint? clarity-token u1 tx-sender) (err "err-mint-ft"))

            ;; Change claim-status for tx-sender to false
            (ok (map-set can-claim tx-sender false))
    )
)

;; Stacking Mint