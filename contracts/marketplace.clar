;; Marketplace
;; Simple NFT Marketplace
;; Written by David-Jesse

;; Unique Properties
;; All Custodial
;; Multiple Admins
;; Collections *Have* to be whitelisted by admins
;; Only STX (no FT)

;; Selling an NFT Lifecycle
;; Collection is submitted for whitelisting
;; Collection is whitelisted or rejected
;; NFT(s) are listed
;; NFT is purchased
;; STX/NFT is transfered
;; Listings are deleted


;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Define the NFT trait we'll use throughout
(use-trait nft .sip-09.nft-trait)

;; All admins
(define-data-var admins (list 20 principal) (list tx-sender))

;; Whitelist collections
;; Three States
;; i. Is-none -> collection not submitted
;; ii. False -> Collection has not been approved by admin
;; iii. True -> collection has been approved by admin

(define-map collection principal {
    name: (string-ascii 64),
    royalty-percent: uint,
    royalty-address: principal,
    whitelisted: bool
})

;; List of all for sale in collection
(define-map collection-listing principal (list 10000 uint))

;; Item status
(define-map item-status {collection: principal, item: uint} {
    owner: principal,
    price: uint
})

;; Helper uint
(define-data-var helper-uint uint u0)

;;;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Get all whitelist collections
(define-read-only (is-collection-whitelisted (nft-collection principal)) 
    (map-get? collection nft-collection)
)

(define-read-only (listed (nft-collection principal)) 
    (map-get? collection-listing nft-collection)
)

;; Get item status
(define-read-only (item (nft-collection principal) (nft-item uint)) 
    (map-get? item-status {collection: nft-collection, item: nft-item})
)


;;;;;;;;;;;;;;;;;;;;;;
;; Buyer Functions ;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Buy Item
;; @desc -  functions that allows principal to purchase a listed NFT
;; @param - nft-collection: nft-trait, nft-item: uint
(define-public (buy-item (nft-collection <nft>) (nft-item uint)) 
    (let    
        (
            (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "err-not-whitelisted")))
            (current-royalty-percent (get royalty-percent current-collection))
            (current-royalty-address (get royalty-address current-collection))
            (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item: nft-item}) (err "err-item-not-listed")))
            (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-no-collection-listings")))
            (current-listing-price (get price current-listing))
            (current-listing-royalty (/ (* current-listing-price current-royalty-percent) u100))
            (current-listing-owner (get owner current-listing))
        )   
            ;; Assert that item is listed
            (asserts! (is-some (index-of? current-collection-listings nft-item)) (err "err-item-not-listed"))

            ;; Assert that tx-sender is not owner
            (asserts! (not (is-eq tx-sender current-listing-owner)) (err "err-buyer-is-owner"))

            ;; Send STX (price) to owner
            (unwrap! (stx-transfer? current-listing-price tx-sender current-listing-owner) (err "err-stx-transfer"))

            ;; Send STX (royalty) to artist/royalty-address   
            (unwrap! (stx-transfer? current-listing-royalty  tx-sender current-royalty-address) (err "err-stx-transfer-royalty-fees"))

            ;; Transfer NFT from custodial/contract to buyer/NFT
            (unwrap! (contract-call? nft-collection transfer nft-item (as-contract tx-sender) tx-sender) (err "err-nft-transfer"))

            ;; Map-delete item-listing
            (map-delete item-status {collection: (contract-of nft-collection), item: nft-item})

            ;; Filter out nft-item from collection-listing
            ;; (filter remove-uint collection-listing)
            (var-set helper-uint nft-item)

            (ok (map-set collection-listing (contract-of nft-collection) (filter remove-uint-from-list current-collection-listings)))

    )
)


;;;;;;;;;;;;;;;;;;;;;;
;; Owner Functions ;;;
;;;;;;;;;;;;;;;;;;;;;;

;; List item
;; @desc - function that allows owner to list An NFT
;; @params - collection: <nft-trait>, item: uint

(define-public (list-item (nft-collection <nft>) (nft-item uint) (nft-price uint)) 
    (let        
        (
            (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "err-get-owner")))
            (current-collection-listing (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-no-collection-listing")))
        )
            ;; Assert that tx-sender is current NFT owner
            (asserts! (is-eq (some tx-sender) current-nft-owner) (err "err-nft-not-owner"))

            ;; Assert that collection is whitelisted
            (asserts! (is-some (map-get? collection (contract-of nft-collection))) (err "err-collection-not-whitelisted"))

            ;; Assert that item-staus is none
            (asserts! (is-none (map-get? item-status { collection: (contract-of nft-collection), item: nft-item})) (err "err-item-already-listed"))

            ;; Transfer NFT from tx-sender to contraxt
            (unwrap! (contract-call? nft-collection transfer nft-item tx-sender (as-contract tx-sender)) (err "err-nft-transfer"))

            ;; Map-set item-status with new price & owner (tx-sender)
            (map-set item-status {collection: (contract-of nft-collection), item: nft-item} 
                {
                    owner: tx-sender,
                    price: nft-item
                }
            )

            ;; Map-set item collection-listing
            (ok (map-set collection-listing (contract-of nft-collection) (unwrap! (as-max-len? (append current-collection-listing nft-item) u10000) (err "err-collection-item-overflow"))))
    )
)

;; Unlist item
(define-public (unlist-item (nft-collection <nft>) (nft-item uint)) 
    (let      
        (
            
        )
            ;; Assert that currebt NFT owner is contract

            ;; Assert that item-status is-some

            ;; Assert that owner property from item-status tuple is tx-sender

            ;; Assert that uint is in collection-listing map

            ;; Transfer NFT back from contract to tx-sender/original owner

            ;; Map-set collection-listing (remove uint)

            ;; Map-set item-status (delete entry)


            (ok 1)
    )
)

;; Change Price
(define-public (change-price (nft-collection <nft>) (nft-item uint) (nft-price uint)) 
    (let        
        (
            (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "err-not-whitelisted")))
            (current-royalty-percent (get royalty-percent current-collection))
            (current-royalty-address (get royalty-address current-collection))
            (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item: nft-item}) (err "err-item-not-listed")))
            (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-no-collection-listings")))
            (current-listing-price (get price current-listing))
            (current-listing-royalty (/ (* current-listing-price current-royalty-percent) u100))
            (current-listing-owner (get owner current-listing))
            (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "err-get-owner")))
        )
            ;; Assert nft-item is in collection-listing
            (asserts! (is-some (index-of? current-collection-listings nft-item)) (err "err-item-not-listed"))

            ;; Assert nft current owner is contract
            (asserts! (is-eq (some (as-contract tx-sender)) current-nft-owner) (err "err-contract-not-owner"))    

            ;; Assert that tx-sender is owner from item-status tuple
            (asserts! (is-eq tx-sender current-listing-owner) (err "err-not-listed-owner"))

            ;; Map-set merge item-status with new price
            (ok (map-set item-status {collection: (contract-of nft-collection), item: nft-item}
                (merge 
                    current-listing
                    {price: nft-price}
                )
            ))
    )
)


;;;;;;;;;;;;;;;;;;;;;;
;; Artist Functions;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Submit collection
(define-public (submit-collection (nft-collection <nft>) (royalty-percent uint) (collection-name (string-ascii 64))) 
    (let         
        (
            
        )

            ;; Assert that collection is not already whitelisted by making sure it's is-none


            ;; Assert that tx-sender is deployer of nft parameter


            ;; Map-set whitelisted-collections to false

            (ok 1)
    )
)

;; Change royalty address
(define-public (change-royalty-address (nft-collecion principal) (new-royalty principal))
    (let      
        (
            
        )
            ;; Assert that collection is whitelisted

            ;; Assert that tx-sender is current royalty-address

            ;; Map-set / Merge exisiting collection tuple w/ new royalty-address

            (ok 1)
    )
)

;;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Accept/reject whitelisting
(define-public (whitelisting-approval (nft-collection principal)) 
    (let         
        (

        )
            ;; Assert that whitelisting exists / is-some

            ;; Asserts that tx-sender is an admin
            
            ;; Map-set nft-collection with whitelisted


            (ok 1)
    )
)

;; Add admin
(define-public (add-admin (new-admin principal)) 
    (let      
        (

        )
            ;; Assert that tx-sender is an admin

            ;; Assert that new-admin is not already admin

            ;; Var-set admins by appending new-admin


            (ok 1)
    )
)

;; Remove admin

(define-public (remove-admin (admin principal)) 
    (let       
        (

        )
            ;; Assert that tx-sender is admin

            ;; Assert that remove admin exists

            ;; Var-set helper principal

            ;; Filter-set remove admin


            (ok 1)
    )
)


;;;;;;;;;;;;;;;;;;;;;;
;; Helper Function;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Filter uint from list
(define-private (remove-uint-from-list (helper-item uint)) 
    (not (is-eq helper-item (var-get helper-uint)))
)