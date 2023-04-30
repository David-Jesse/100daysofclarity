;; Staking - Simple
;; A barebone simple staking contract
;; User stakes "simple-nft" in exchange for "clarity-token"
;; Written by David-Jesse
;; Day 80

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Map that keeps track of the status of an NFT
(define-map NFT-status uint {staked: bool, last-staked-or-claimed: uint})

;; Map that keeps track of all the NFTs a user stakes
(define-map user-stakes principal (list 100 uint))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Check unclaimed balance
(define-read-only (get-unclaimed-balance) 
    (let      
        (
            (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "err-no-stakes")))
            (current-user-height-differences (map map-from-ids-to-height-difference current-user-stakes))
        )

            (ok (fold + current-user-height-differences u0))
            
    )
)

;; Private function that maps list of ids to list of height differences
(define-private (map-from-ids-to-height-difference (item uint)) 
    (let       
        (
            (current-item-status (default-to {staked: true, last-staked-or-claimed: block-height} (map-get? NFT-status item)))
            (current-item-height (get last-staked-or-claimed current-item-status))
        )
            (- block-height current-item-height)
            
    )
)

;; Check NFT stack status
;; @desc - Read only function that gets the current stake status-map (aka NFT status)
;; params - Item (uint), NFT identifier that we are checking status
(define-read-only (get-stake-status (item uint)) 
    (map-get? NFT-status item)
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

        )

        ;; Assert that user owns the NFT submitted

        ;; Assert that NFT submitted is not already staked

        (ok 1)
    )
)
;; Unstake NFT

;; Claim FT Reward

