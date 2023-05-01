;; Staking - Simple
;; A barebone simple staking contract
;; User stakes "simple-nft" in exchange for "clarity-token"
;; Written by David-Jesse
;; Day 80

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Map that keeps track of the status of an NFT
(define-map NFT-status uint {last-staked-or-claimed: (optional uint), staker: principal})

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
            (current-item-status (default-to {last-staked-or-claimed: (some block-height), staker: tx-sender} (map-get? NFT-status item)))
            (current-item-height (get last-staked-or-claimed current-item-status))
        )
            (- block-height (default-to u0 current-item-height))
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
            (current-nft-owner (unwrap! (contract-call? .nft-simple get-owner item) (err "err-item-not-minted")))

        )

        ;; Assert that user owns the NFT submitted
         (asserts! (is-eq (some tx-sender) current-nft-owner) (err "err-not-owner"))

        ;; Assert that NFT submitted is not already staked

        ;; Stake NFT custodially -> Transfer NFT from tx-sender to contrac

        ;; Update NFT-status map

        ;; Update user-status map

        (ok 1)
    )
)

;; Day 83
;; Unstake NFT
;; @desc - Function to unstake a staked NFT
;; @param - Item (uint), NFT identifier for unstaking a stacked item
(define-public (unstake-nft (item uint)) 
    (let         
        (

        )
            ;; Asserts that item is staked

            ;; Assert that tx-sender is the staker

            ;; Transfer NFT from contract to staker/tx-sender

            ;; If unstaked balance > 0
                ;; Send unclaimed balance
                ;; Dont send


            ;; Update NFT status map

            ;; Update users stake map


            (ok 1)
    )
)

;; Claim FT Reward
;; @desc - Function to claim unstaked / earned CT
;; @param - Item (uint), NFT identifier for claiming
(define-public (claim-reward (item uint)) 
    (let         
        (

        )
            ;; Assert that item is actively staked 

            ;; Assert that claimable balance > 0

            ;; Assert that tx-sender is staker in the stake-status map

            ;; Calculate reward & mint free FT contract

            ;; Update nft-status map

            (ok 1)
    )
)