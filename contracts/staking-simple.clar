;; Staking - Simple
;; A barebone simple staking contract
;; User stakes "simple-nft" in exchange for "clarity-token"
;; Written by David-Jesse
;; Day 80

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Map that keeps track of the status of an NFT
(define-map nft-status uint {last-staked-or-claimed: (optional uint), staker: principal})

;; Map that keeps track of all the NFTs a user stakes
(define-map user-stakes principal (list 100 uint))

;; Helper variable to remove a uint
(define-data-var helper-uint uint u0)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Check unclaimed balance
;; (define-read-only (get-unclaimed-balance) 
;;     (let      
;;         (
;;             (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "err-no-stakes")))
;;             (current-user-height-differences (map map-from-ids-to-height-difference current-user-stakes))
;;         )

;;             (ok (fold + current-user-height-differences u0))     
;;     )
;; )

;; Private function that maps list of ids to list of height differences
(define-private (map-from-ids-to-height-difference (item uint)) 
    (let       
        (
            (current-item-status (default-to {last-staked-or-claimed: (some block-height), staker: tx-sender} (map-get? nft-status item)))
            (current-item-height (get last-staked-or-claimed current-item-status))
        )
            (- block-height (default-to u0 current-item-height))
    )
)


;; Check NFT stack status
;; @desc - Read only function that gets the current stake status-map (aka NFT status)
;; params - Item (uint), NFT identifier that whose status is being checked
(define-read-only (get-stake-status (item uint)) 
    (map-get? nft-status item)
)

;; Check principal reward rate
;; @desc - Read-only function gets the total reward rate for tx-sender
(define-read-only (get-reward-rate) 
    (len (default-to (list ) (map-get? user-stakes tx-sender)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Writing Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Stake NFT
;; @desc - Function to stake an unstaked nft-a item
;; param - Item (uint), NFT identifier for item submitted for staking
(define-public (stake-nft (item uint)) 
    (let       
        (
            (current-nft-owner (unwrap! (contract-call? .nft-simple get-owner item) (err "err-item-not-minted")))
            (current-user-stakes (default-to (list ) (map-get? user-stakes tx-sender)))
        )

        ;; Assert that user owns the NFT submitted
         (asserts! (is-eq (some tx-sender) current-nft-owner) (err "err-not-owner"))

        ;; Assert that NFT submitted is not already staked
        ;; Assert that last-claimed-or-staked is-none
        (asserts! (or (is-none (map-get? nft-status item)) (is-none (get last-staked-or-claimed (default-to {last-staked-or-claimed: none, staker: tx-sender} (map-get? nft-status item))))) (err "err-already-staked"))

        ;; Stake NFT custodially -> Transfer NFT from tx-sender to contract
        (unwrap! (contract-call? .nft-simple transfer item tx-sender (as-contract tx-sender)) (err "err-nft-transfer-to-contract"))

        ;; Update NFT-status map
        (map-set nft-status item {last-staked-or-claimed: (some block-height), staker: tx-sender})

        ;; Update user-stakes map
        (ok (map-set user-stakes tx-sender (unwrap! (as-max-len? (append current-user-stakes item) u100) (err "err-user-stakes-overflow"))))
    )
)

;; Day 83
;; Unstake NFT
;; @desc - Function to unstake a staked NFT
;; @param - Item (uint), NFT identifier for unstaking a stacked item
(define-public (unstake-nft (item uint)) 
    (let         
        (
            (current-tx-sender tx-sender)
            (current-nft-status (unwrap! (map-get? nft-status item) (err "err-no-nft-status")))
            (current-nft-status-last-height (unwrap! (get last-staked-or-claimed current-nft-status) (err "err-nft-not-staked")))
            (current-balance (- block-height current-nft-status-last-height))
            (current-nft-staker (get staker current-nft-status))
            (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "err-no-user-stakes")))
          
        )

            ;; Assert that tx-sender is the staker
            (asserts! (is-eq tx-sender current-nft-staker) (err "err-not-nft-staker"))

            ;; Transfer NFT from contract to staker/tx-sender
            (unwrap! (as-contract (contract-call? .nft-simple transfer item tx-sender current-tx-sender)) (err "err-sending-nft"))

            ;; Send unclaimed balance
            (unwrap! (contract-call? .simple-ft earned-ct current-balance) (err "err-claiming-ct"))

            ;; Delete NFT status map
            (map-delete nft-status item)

            ;; Var-set uint to item
            (var-set helper-uint item)

            ;; Update users stake map
            (ok (map-set user-stakes current-tx-sender (filter filter-remove-uint current-user-stakes)))
    )
)


;; Filter helper function to remove an id from user-stakes
  (define-private (filter-remove-uint (item uint)) 
        (not (is-eq item (var-get helper-uint)))
    )

;; Day 86
;; Claim CT Reward
;; @desc - Function to claim unstaked / earned CT
;; @param - Item (uint), NFT identifier for claiming
(define-public (claim-reward (item uint)) 
    (let         
        (
            (current-nft-status (unwrap! (map-get? nft-status item) (err "err-no-nft-status")))
            (current-nft-status-last-height (unwrap! (get last-staked-or-claimed current-nft-status) (err "err-nft-not-staked")))
            (current-balance (- block-height current-nft-status-last-height))
            (current-nft-staker (get staker current-nft-status))
            (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "err-user-has-no-stakes")))
        )

            ;; Assert that claimable balance > 0
            (asserts! (> current-balance u0) (err "err-no-claimable-balance"))

            ;; Assert that tx-sender is staker in the stake-status map
            (asserts! (is-eq tx-sender current-nft-staker) (err "err-not-staker"))

            ;; Send unclaimed balance
            (unwrap! (contract-call? .simple-ft earned-ct current-balance) (err "err-claiming-ct"))

            ;; Update nft-status map
            (ok (map-set nft-status item {last-staked-or-claimed: (some block-height), staker: tx-sender}))
    )
)
