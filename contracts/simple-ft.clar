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


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

