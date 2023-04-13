;; Day 60
;; NFT Advance
;; An advanced NFT that has all modern functions required for a high-quality NFT project
;; Written by David-Jesse

;; Unique Properties & Features
;; 1. Implements non-custodial marketplace functions
;; 2. Implements a whitelist minting system
;; 3. Option to mint 1,2 or 5
;; 4. Multiple Admin system


;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Define NFT
(define-non-fungible-token advance-nft uint)

;; Adhere to SIP-09
;; (impl-trait .sip-09.nft-trait)

;; Collection Limit
(define-constant collection-limit u10)

;; Root URI
(define-constant collection-root-uri "ipfs://ipfs/QmYcrELFT5c9pjSygFFXkbjfbMHB5cBoWJDGaTvrP/")

;; NFT Price
(define-constant simple-nft-price u100000000)

;; Collection index
(define-data-var collection-index uint u1)

;; Admin List
(define-data-var admins (list 10 principal) (list tx-sender))

;; Marketplace Map
(define-map market uint {
    price: uint,
    owner: principal
})

;; Whitelist map
(define-map whitelistmap principal uint)

;; Day 61
;;;;;;;;;;;;;;;;;;;;;;
;; SIP-09 Functions ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Get last token id
(define-public (get-last-token-id) 
    (ok (var-get collection-index))
)


;; Get token URI
(define-public (get-token-uri (id uint))
    (ok ( some (concat 
        collection-root-uri
        (concat (uint-to-ascii id) 
        ".json"
        ))
     ))
)

;; Transfer Token
(define-public (transfer (id uint) (sender principal) (recipient principal)) 
   (begin 
        (asserts! (is-eq tx-sender sender) (err u1))
        (if (is-some (map-get? market id))
            (map-delete market id)
            false
        )
        (nft-transfer? advance-nft id sender recipient)
   )
)

;; Get Owner
(define-public (get-owner (id uint)) 
    (ok (nft-get-owner? advance-nft id))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Noncustodial Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List in ustx
(define-public (list-in-ustx (item uint) (price uint)) 
    (let    
        (
            (nft-owner (unwrap! (nft-get-owner? advance-nft item) (err "err-nft-doesnt-exist")))

        )
            ;; Assert that tx-sender is nft owner
            (asserts! (is-eq nft-owner tx-sender) (err "err-not-owner"))

            ;; Map-set & update market
            (ok (map-set market item {
                owner: tx-sender,
                price: price 
            }))
    )
)

;; Unlist in ustx
(define-public (unlist-in-ustx (item uint)) 
    (let    
        (
            (current-listing (unwrap! (map-get? market item) (err "err-not-listed")))
            (current-price (get price current-listing))
            (current-owner (get owner current-listing))
        )

            ;; Assert that tx-sender is-eq current owner
            (asserts! (is-eq tx-sender current-owner) (err "err-not-owner"))

            ;; Delete the listing
            (ok (map-delete market item))
    )
)

;; Buy in ustx
(define-public (buy-in-ustx (item uint)) 
    (let    
        (
            (current-listing (unwrap! (map-get? market item) (err "err-not-listed")))
            (current-price (get price current-listing))
            (current-owner (get owner current-listing))
        )
            ;; Send STX to start purchase
            (unwrap! (stx-transfer? current-price tx-sender current-owner) (err "err-sending-stx"))

            ;; Send NFT to purchaser
            (unwrap! (nft-transfer? advance-nft item current-owner tx-sender) (err "err-nft-transfer"))

            ;; Delete listing
            (ok (map-delete market item))
            
    )
)

;; Check Listing
(define-read-only (check-listing (item uint)) 
    (map-get? market item)
)


;;;;;;;;;;;;;;;;;;;;;;;
;; Minting Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Mint one


;; Mint two


;; Mint five



;;;;;;;;;;;;;;;;;;;;;;;;;
;; Whitelist Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add whitelist


;; Check whitelist status


;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; Add admin


;; Remove admin

;;;;;;;;;;;;;;;;;;;;;;
;; Helper Functions ;;
;;;;;;;;;;;;;;;;;;;;;;

(define-read-only (uint-to-ascii (value uint)) 
    (if (<= value u9) 
        (unwrap-panic (element-at "0123456789" value))
        (get r (fold uint-to-ascii-inner
            0x00000000000000000000000000000000
            {v: value, r: ""}
        ))
    )
)

(define-read-only (uint-to-ascii-inner (i (buff 1)) (d {v: uint, r: (string-ascii 39)})) 
    (if (> (get v d) u0)
        {
            v: (/ (get v d) u10),
            r: (unwrap-panic (as-max-len? (concat (unwrap-panic (element-at "0123456789" (mod (get v d) u10))) (get r d)) u39))
        }
        d
    )
)