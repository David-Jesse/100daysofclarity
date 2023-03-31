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
(define-constant add-walllet-funds-fee u2000000)

;; Min . Add offspring wallet funds amount
(define-constant min-add-wallet-amount u5000000)

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

;; Day 39 - Outlining the public functions for Parents Functions
;; Day 40 - Outling the public functions for Offspring functions

;;;;;;;;;;;;;;;;;;;;;;
;; Parent Functions ;;
;;;;;;;;;;;;;;;;;;;;;; 

;; Create Wallet
;; @desc - creates new offspring wallet with new parent (no initial deposit)
;; @params - new-offspring-principal: principal, new-offspring-dob: uint
(define-public (create-wallet (new-offspring-principal principal) (new-offspring-dob uint)) 
    (let  
        (

            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees create-wallet-fee))

        )
            ;; Assert that map-get? offspring wallet is none
            (asserts! (is-none (map-get? offspring-wallet tx-sender)) (err "err-wallet-already-exists"))

            ;; Assert that new-offspring-dob is at least higher than block-height - 18 years of blocks
           ;; (asserts! (> new-offspring-dob (- block-height eighteen-years-in-block-height)) (err "err-past-18-years"))

            ;; Assert that the new-offspring-principal is NOT the admin OR tx-sender
            (asserts! (or (not (is-eq tx-sender new-offspring-principal)) (is-none (index-of (var-get admin) new-offspring-principal))) (err "invalid-offspring-principal"))

            ;; Pay create wallet fee in STX (5 stx)
            (unwrap! (stx-transfer? create-wallet-fee tx-sender deployer) (err "err-stx-transfer"))
            
            ;; Var-set total fees
            (var-set total-fees-earned new-total-fees)

            ;; Map-set offspring-wallet
            (ok (map-set offspring-wallet tx-sender {
                offspring-principal: new-offspring-principal,
                offspring-dob: new-offspring-dob,
                balance: u0
            }))

    )
)

;; Fund Wallet
;;  @desc - allows anyone to fund an existing wallet
;; @params - parent: principal, amount: uint
(define-public (fund-wallet (parent principal) (amount uint)) 
    (let 
        (
            ;; Local vars
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")))
            (current-offspring-wallet-balance (get balance current-offspring-wallet))
            (new-offspring-wallet-balance (+ (- amount add-walllet-funds-fee) current-offspring-wallet-balance))
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees min-add-wallet-amount))

        )
            ;; Assert that amount is higher than min-add-wallet-amount ( 5 stx)
            (asserts! (> amount min-add-wallet-amount) (err "not-enough-stx"))
            
            ;; Send stx (amount - fee) to contract
            (unwrap! (stx-transfer? (- amount add-walllet-funds-fee) tx-sender contract)  (err "err-sending-stx-to-contract"))

            ;; Send stx (fee) to deployer
            (unwrap! (stx-transfer? add-walllet-funds-fee tx-sender deployer) (err "err-sending-stx-to-deployer"))

            ;; Var-set total fees
            (var-set total-fees-earned new-total-fees)

            ;; Map-set current offspring-wallet by merging old balance + amount
            (ok (map-set offspring-wallet parent 
                (merge  
                    current-offspring-wallet
                    {balance: new-offspring-wallet-balance}
                )
            ))

    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Offspring Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Claim Wallets
;; @desc -  Allows offspring to claim wallet once and once only
;; params - parent: principal

(define-public (claim-wallet (parent principal)) 
    (let  
        (
            ;; Local var
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")))
            (current-offspring (get offspring-principal current-offspring-wallet))
            (current-dob (get offspring-dob current-offspring-wallet))
            (current-balance (get balance current-offspring-wallet))
            (current-withdrawal-fee (/ (* current-balance u2) u100))
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees current-withdrawal-fee))
        )
            ;; Asserts that tx-sender is-eq to the offspring-principal
            (asserts! (is-eq current-offspring tx-sender) (err "err-not-offspring-principal"))

            ;; Assert that blockheight is 18 years later than offspring-dob
            (asserts! (> block-height (+ current-dob eighteen-years-in-block-height)) (err "err-not-eighteen"))

            ;; Send stx (amount - withhdrawal) to offspring
            (unwrap! (as-contract (stx-transfer? (- current-balance current-withdrawal-fee) tx-sender current-offspring)) (err "err-sending-stx-offspring"))

            ;; Send stx withdrawal fee to deployer
            (unwrap! (as-contract (stx-transfer? (current-withdrawal-fee) tx-sender deployer)) (err "err-sending-stx-deployer"))

            ;; Delete offstring-wallet map
            (map-delete offspring-wallet parent)

            ;; Update total fees earned
            (ok (var-set total-fees-earned new-total-fees))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emergency Withdrawal ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emergency claim
;; @desc - allows either parent or an admin to withdraw all stacks - emergency withdrawal fee back to parent and removes wallet
;; @params - parent: principal
(define-public (emergency-claim (parent principal)) 
    (let 
        (
            ;; Local vars
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")))


        )
            ;; Assert that tx-sender is either parent or one of the admins

            ;; Assert that blockheight is < 18years from dob

            ;; Send stx (amount - emergency-withhdrawal) to offspring

            ;; Send stx emergency-withdrawal fee to deployer

            ;; Delete offstring-wallet map

            ;; Update total fees earned
             (ok 1)
     )
)


;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; Add admin
;; @desc - function to add an admin to existing admin list
;; @params - new admin: principal

(define-public (add-admin (new-admin principal)) 
    (let  
        (
            
        )
            ;; Assert that tx-sender is a current admin

            ;; Assert that new-admin does not exist in list of admins

            ;; Append new-admin to list of admins


        (ok 1)
    )
)

;; Remove Admin
;; @desc - Function that lets you remove an existing admin
;; @params - removed-admin: principal
(define-public (remove-admin (removed-admin principal)) 
    (let   
        (


        )

        ;; Asserts that tx-sender is a current admin

        ;; Filter remove removed-admin

        (ok 1)
    )
)