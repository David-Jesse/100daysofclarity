;; Odds & Evens
;; Contract for a 2-player betting game

;; Game
;; Two players bet the same amount that a future block will be odd or even
;; Players can have no more than 3 active bets at a time
;; Bets can only be made in factors of 5 & have to be less than 50
;; The contract should charge 2 STXs to create a bet, 2 STXs to join a bet & 1 STX to cancel a bet
;; All or nothing for winner

;; Bet
;; Create Bet -> A bet created between principal A (starts), principal B (Optional), bet amount & bet height
;; Match Bet -> Principal B spots Bet A & fills in the second slot. Bet is locked until reveal height
;; Reveal Bet -> Once reveal height is surpassed, either player can call bet result

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Min bet height in blocks
(define-constant min-future-height u10)

;; Max bet height in blocks
(define-constant max-future-height u1008)

;; Max user active bets
(define-constant max-active-bets u3)

(define-constant max-bet-fee u50)

;; Create / match bet fee
(define-constant create-bet-fee u2000000)

;; Cancel bet fee
(define-constant cancel-bet-fee u1000000)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-map bets uint { 
    opens-bet: principal,
    matches-bet: (optional principal),
    amount-bet: uint,
    height-bet: uint,
    winner: (optional principal)
 })

 (define-map user-bets principal {open-bets: (list 100 uint), active-bets: (list 3 uint)})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;; Variable that keeps track of all open bets
 (define-data-var open-bets (list 100 uint) (list ))

;; Variable that keeps track of all active bets
(define-data-var active-bets (list 100 uint) (list ))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get all open bets
(define-read-only (get-open-bets) 
    (var-get open-bets)
)

;; Get all active bets
(define-read-only (get-active-bets) 
    (var-get active-bets)
)

;; Get specific bets 
(define-read-only (get-bets (bet-id uint)) 
    (map-get? bets bet-id)
)

;; Get user bets
(define-read-only (get-user-bets (user principal))
    (map-get? user-bets user)
)


;;;;;;;;;;;;;;;;;;;
;; Bet Functions ;;
;;;;;;;;;;;;;;;;;;;







