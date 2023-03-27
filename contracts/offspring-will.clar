;; Offspring-will
;; A smart contract that allows parents to create and fund wallets unlockable only by parent or offspring
;; Written by David-Jesse

;; Offspring wallet
;; This is our main map that is created & funded by a parent & only unlockable by an assigned offspring (principal)
;; Principal -> {offspring-principal: principal, offspring-dob: uint, balance: int}

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

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



;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;
;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;
;; Parent Functions ;;
;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;
;; Offspring Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;