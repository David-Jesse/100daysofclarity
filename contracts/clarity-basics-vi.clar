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
(define-map market uint {price: uint, owner: principal})
(define-public (list-in-ustx (item uint) (price uint)) 
    (let   
        (
            (nft-owner (unwrap! (nft-get-owner? test-nft item) (err "err-nft-doesnt-exist")))
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
    (ok true) 
)
(define-public (buy-in-ustx (item uint)) 
    (ok true)
)