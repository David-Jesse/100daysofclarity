;; Odds & Evens
;; Contract for a 2-player betting game

;; Game
;; Two players bet the same amount that a future block will be odd or even
;; Players can have no more than two active bets at a time
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

(define-map bets uint { 
    opens-bet: principal,
    matches-bet: (optional principal),
    amount-bet: uint,
    height-bet: uint 
 })

;; Variable that keeps track of all active bets
(define-data-var active-bets (list 100 uint) (list ))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;
;; Bet Functions ;;
;;;;;;;;;;;;;;;;;;;







