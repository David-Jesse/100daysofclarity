;; title: clarity-basics-vi
;; Reviewing more clarity fundamentals
;; Written by David-Jesse

;; Day 57 - Whitelist Mint Logic
(define-non-fungible-token test-nft uint)
(define-constant collection-limit u10)
(define-constant admin tx-sender)
(define-data-var collection-index uint u1)

(define-map whitelist-map principal uint)

;; Minting Logic
(define-public (mint) 
    (let     
        (
            (current-index (var-get collection-index))
            (next-index (+ u1 current-index))
            (current-whitelist-mint (unwrap! (map-get? whitelist-map tx-sender) (err "err-whitelist-map-none")))
        )
            ;; Assert that current index is < collectiion limit
            (asserts! (< current-index collection-limit) (err "err-minted-out"))

            ;; Asserts that tx-sender has mints allocated remaining
            (asserts! (> current-whitelist-mint u0) (err "err-whitelist-mints-used-up"))

            ;; Mint NFT
            (unwrap! (nft-mint? test-nft current-index tx-sender) (err "err-minting"))
            
            ;; Update allocated whitelist mints
            (map-set whitelist-map tx-sender (- current-whitelist-mint u1))

            ;; Increase current index
            (ok (var-set collection-index next-index))
        
    )
)

;; Add principal to whitelist
(define-public (whitelist-principal (whitelist-address principal) (mints-allocated uint)) 
    (begin   
        
        ;; Assert that tx-sender is Admin
        (asserts! (is-eq tx-sender admin) (err "err-not-admin"))

        ;; Map set whitelist-map
        (ok (map-set whitelist-map whitelist-address mints-allocated))
    )
)   

;; Day 58 - Non-custodial Functions
;; Day 59 - Non custodial Functions contd.

(define-map market uint {price: uint, owner: principal})
(define-public (list-in-ustx (item uint) (price uint)) 
    (let   
        (
            (nft-owner (unwrap! (nft-get-owner? test-nft item) (err "err-nft-doesn't-exist")))
        )
            ;; Assert that tx-sender is-eq to NFT owner
            (asserts! (is-eq tx-sender nft-owner) (err "err-not-owner"))

            ;; Map-set market with new NFT
            (ok (map-set market item {price: price, owner: tx-sender}))   
    ) 
)

(define-read-only (get-list-in-ustx (item uint)) 
    (map-get? market item)
)

(define-public (unlist-in-ustx (item uint)) 
    (let    
        (
            (current-listing (unwrap! (map-get? market item) (err "err-listing-doesnt-exist")))
            (current-price (get price current-listing))
            (current-owner (get owner current-listing))
        )
            ;; Assert that tx-sender is current owner
            (asserts! (is-eq tx-sender current-owner) (err "err-not-owner"))

            ;; Map delete existing listing
            (ok (map-delete market item))
    ) 
)
(define-public (buy-in-ustx (item uint)) 
    (let    
        (
            (current-listing (unwrap! (map-get? market item) (err "err-listing-doesnt-exist")))
            (current-price (get price current-listing))
            (current-owner (get owner current-listing))
        )

            ;; Tx-sender buys by transfering STX
            (unwrap! (stx-transfer? current-price tx-sender current-owner) (err "err-stx-transfer"))

            ;; Transfer NFT to new owner
            (unwrap! (nft-transfer? test-nft item current-owner tx-sender) (err "err-nft-transfer"))

            ;; Map-delete listing
            (ok (map-delete market item))
    )
)

;; Day 66 - Use-traits To Make Dynamic Contract Calls

(use-trait nft .sip-09.nft-trait)

;; Get Last id
(define-public (get-last-id (nft-principal <nft>))
    (contract-call? nft-principal get-last-token-id)
)

;; Get Owner
(define-public (get-owner (nft-principal <nft>) (item uint)) 
    (contract-call? nft-principal get-owner item)
)

 ;; Day 76 - Native Fungible Token (FT) Functions
 (define-fungible-token test-token u100)
 (define-public (mint-test-token) 
    (ft-mint? test-token u1 tx-sender)
 )

 (define-read-only (get-test-token-balance (user principal)) 
    (ft-get-balance test-token user)
 )

 (define-read-only (get-test-token-supply) 
    (ft-get-supply test-token)
 )

 (define-public (transfer-test-token (amount uint) (recipient principal)) 
    (ft-transfer? test-token amount tx-sender recipient)
 )

 (define-public (burn-test-token (amount uint) (sender principal)) 
    (ft-burn? test-token amount sender)
 )

;; Day 90 - Buffers
(define-read-only (test-element-at (test-buff (buff 30))) 
    (element-at? test-buff u1)
)

(define-read-only (test-index-of (test-buff (buff 30))) 
    (index-of? test-buff 0x00)
)

(define-read-only (test-concat (test-buff (buff 30))) 
    (concat test-buff 0x000000)
)

;; Day 91 - Buffers Contd/Get-Block-Info? & Intro to VRF
(define-read-only (test-get-block (block uint)) 
    (get-block-info? vrf-seed block)
)
