;; Day 37
;; Offspring-will
;; A smart contract that allows parents to create and fund wallets unlockable only by parent or offspring
;; Written by David-Jesse

;; Offspring wallet
;; This is our main map that is created & funded by a parent & only unlockable by an assigned offspring (principal)
;; Principal -> {offspring-principal: principal, offspring-dob: uint, balance: int}
;; 1. Create Wallet
;; 2. Fund Wallet
;; 3. Claim Wallet
;;  i - Offspring
;;  ii  - Parent/Admin


;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Deployer
(define-constant deployer tx-sender)

;; Contract
(define-constant contract (as-contract tx-sender))

;; Create Offspring Wallet fee
(define-constant create-wallet-fee u5000000)

;; Add offspring wallet funds fee
(define-constant offspring-wallet-funds-fee u2000000)

;; Min . Add offspring wallet funds fee
(define-constant min-create-wallet-fee u5000000)

;; Early Withdrawal fee (10%)
(define-constant early-withdrawal-fee u10)

;; Normal Withdrawal fee (2%)
(define-constant normal-withdrawal-fee u2)

;; 18 years in block height (18 years * 365 * 144 blocks/day)
(define-constant eighteen-years-in-block-height (* u18 (* u144 u365)))

;; Admin list of principals
(define-data-var admin (list 10 principal) (list tx-sender))

;; Total fees earned
(define-data-var total-fees-earned uint u0)

;; Offspring Wallet
(define-map offspring-wallet principal { 
    offspring-principal: principal,
    offspring-dob: uint,
    balance: uint  
    })


;; Day 38
;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;
;;;;;;;;;;;;;;;;;;;;

;; Get offspring wallet
(define-read-only (get-offspring-wallet (parent principal)) 
    (map-get? offspring-wallet parent)
)

;; Get offspring wallet principal

(define-read-only (get-offspring-wallet-principal (parent principal)) 
    (get offspring-principal (map-get? offspring-wallet parent))  
)

;; Get offspring wallet balance
(define-read-only (get-offspring-wallet-balance (parent principal)) 
    (default-to u0 (get balance (map-get? offspring-wallet parent)))
)

;; Get offspring wallet dob
(define-read-only (get-offspring-wallet-dob (parent principal)) 
    (get offspring-dob (map-get? offspring-wallet parent))  
)

;; Get offspring Wallet unlock height
(define-read-only (get-off-spring-wallet-unlock-height (parent principal)) 
    (let 
        (
            ;; Local vars
            (offspring-dob (unwrap! (get-offspring-wallet-dob parent) (err u1)))

        )


            ;; function body
            (ok (+ offspring-dob eighteen-years-in-block-height))
    )
)

;; Get earned fees
(define-read-only (get-earned-fees) 
    (var-get total-fees-earned)
)

;; Get STX in contract
(define-read-only (get-contract-stx-balance) 
    (stx-get-balance contract)
)

;; Day 39
;;;;;;;;;;;;;;;;;;;;;;
;; Parent Functions ;;
;;;;;;;;;;;;;;;;;;;;;;

;; (define-map offspring-wallet principal { 
;;     offspring-principal: principal,
;;     offspring-dob: uint,
;;     balance: uint  
;;     })

;; Create Wallet
;; @desc - creates new offspring wallet with new parent (no initial deposit)
;; @params - new-offspring-principal: principal, new-offspring-dob: uint
(define-public (create-wallet (new-offspring-principal principal) (new-offsprinf-dob uint)) 
    (let  
        (
            ;; local vars


        )
            ;; Assert that map-get? offspring wallet is none

            ;; Assert that new-offspring-dob is at least higher than block-height - 18 years of blocks

            ;; Map-set offspring-wallet

            ;; function body
        (ok 1)
    )
)

;; Fund Wallet
;;  @desc - allows anyone to fund an existing wallet
;; @params - parent-principal: principal, amount: uint
(define-public (fund-wallet (parent-principal principal) (amount uint)) 
    (let 
        (
            ;; Local vars

        )

            ;; function body
            (ok 1)
    )
)


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Offspring Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;