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
;; Cancel bet -> Maual? or does it auto-expire?
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
 (define-data-var bet-index uint u0)

 (define-data-var open-bets (list 100 uint) (list ))

;; Variable that keeps track of all active bets
(define-data-var active-bets (list 100 uint) (list ))

;; Helper var for filtering out uints
(define-data-var helper-uint uint u0)


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

;; Open / Create Bet
;; @desc - Public function for creating a new bet
;; @param - Amount (uint), amount of bet / bet size - Height (uint), block that we're betting on        
(define-public (create-bet (amount uint) (height uint)) 
    (let        
        (
            (current-bet-id (var-get bet-index))
            (next-bet-id (+ u1 current-bet-id))
            (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
            (current-active-user-bets (get active-bets current-user-bets))
        )

            ;; Assert that amount is less than or equal to 50 STX

            ;; Assert that amount is a factor of 5 (mod 5 = 0)

            ;; Assert that height is higher than (min-future-height + block-height) and lesser than (max-future-height + block-height)

            ;; Charge create-match-fee in STX

            ;; Map-set current-user bets

            ;; Var-set open bets

            ;; Map-set bets

            ;; Var-set bet-index to next-index

            
            (ok 1)
    )
)

;; Match / Join bet
;; @desc -> Public function for joining or matching an open bet as principal B
;; @param -> None
(define-public (match-bet (bet uint)) 
    (let            
        (
            (current-bet (unwrap! (map-get? bets bet) (err "err-bet-doesnt-exist")))
            (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
            (current-user-open-bets (get open-bets current-user-bets))
            (current-active-bets (get active-bets current-user-bets))
            (current-bet-height-bet (get height-bet current-bet))
        )

            ;; Assert that block-height is equal to or less than the current-bet-height-bet

            ;; Assert that current-user-active bet length is < or equal to 3

            ;; Transfer current bet amount in STX

            ;; Transfer create-match-fee in STX

            ;; Map-set current-bet by merging current-bet with {matches-bet: (some tx-sender)} 

            ;; Map-set user-bets by appending bet to current-active-bets list & by filtering out bet with filter-out-uint

            ;; Var-set helper-uint with bet

            (ok 1)
    )
)

(define-private (filter-out-uint (bet uint)) 
    (not (is-eq bet (var-get helper-uint)))
)


