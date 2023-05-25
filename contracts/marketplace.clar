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

;; Helper principal
(define-data-var helper-principal principal tx-sender)

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
            (current-listing-royalty (* current-listing-price current-royalty-percent))
            (current-listing-owner (get owner current-listing))
            (current-tx-sender tx-sender)
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
            (unwrap! (as-contract (contract-call? nft-collection transfer nft-item tx-sender current-tx-sender)) (err "err-nft-transfer"))

            ;; Map-delete item-listing
            (map-delete item-status {collection: (contract-of nft-collection), item: nft-item})

            ;; Filter out nft-item from collection-listing
            (var-set helper-uint nft-item)

            ;; (filter remove-uint collection-listing)
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
            (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "err-not-whitelisted")))
            (current-collection-whitelist (get whitelisted current-collection))
            (current-tx-sender tx-sender)
        )
            ;; Assert that tx-sender is current NFT owner
            (asserts! (is-eq (some tx-sender) current-nft-owner) (err "err-nft-not-owner"))

            ;; Assert that collection is whitelisted
            (asserts! current-collection-whitelist (err "err-collection-not-whitelisted"))

            ;; Assert that item-status is none
            (asserts! (is-none (map-get? item-status {collection: (contract-of nft-collection), item: nft-item})) (err "err-item-already-listed"))

            ;; Transfer NFT from tx-sender to contract
            (unwrap! (contract-call? nft-collection transfer nft-item current-tx-sender (as-contract tx-sender)) (err "err-nft-transfer"))

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
            (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "err-not-whitelisted")))
            (current-royalty-percent (get royalty-percent current-collection))
            (current-royalty-address (get royalty-address current-collection))
            (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item: nft-item}) (err "err-item-not-listed")))
            (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-no-collection-listings")))
            (current-listing-price (get price current-listing))
            (current-listing-royalty (/ (* current-listing-price current-royalty-percent) u100))
            (current-listing-owner (get owner current-listing))   
            (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "err-get-owner")))
            (current-tx-sender tx-sender)
        )
            ;; Assert that current NFT owner is contract
            (asserts! (is-eq (some (as-contract tx-sender)) current-nft-owner) (err "err-contract-not-owner"))    

            ;; Assert that tx-sender is-eq current-listing-owner
            (asserts! (is-eq tx-sender current-listing-owner) (err "err-not-listed-owner"))

            ;; Assert that uint is in collection-listing map
            (asserts! (is-some (index-of? current-collection-listings nft-item)) (err "err-item-not-in-listings"))

            ;; Transfer NFT back from contract to tx-sender/original owner
            (unwrap! (as-contract (contract-call? nft-collection transfer nft-item  current-tx-sender tx-sender)) (err "err-returning-nft"))

            ;; Map-set item-status (delete entry)
            (map-delete item-status {collection: (contract-of nft-collection), item: nft-item})

            ;; Filter out nft-item from collection-listing
            ;; (filter remove-uint collection-listing)
            (var-set helper-uint nft-item)

            (ok (map-set collection-listing (contract-of nft-collection) (filter remove-uint-from-list current-collection-listings)))
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
    (begin          
        
            ;; Assert that both collection & collection-listings is-none
            (asserts! (and (is-none (map-get? collection (contract-of nft-collection))) (is-none (map-get? collection-listing (contract-of nft-collection)))) (err "err-collection-already-listed"))

            ;; Assert royalty is greater than u1 & lower than u20
            (asserts! (and (< royalty-percent u21) (> royalty-percent u0)) (err "err-bad-royalty-commision"))

            ;; Map-set whitelisted-collections to false
            (ok (map-set collection (contract-of nft-collection) {
                name: collection-name,
                royalty-percent: royalty-percent,
                royalty-address: tx-sender,
                whitelisted: false 
            }))    
    )
)

;; Change royalty address
(define-public (change-royalty-address (nft-collection principal) (new-royalty principal))
    (let      
        (
            (current-collection (unwrap! (map-get? collection nft-collection) (err "err-not-whitelisted")))
            (current-royalty-address (get royalty-address current-collection))
        )
    
            ;; Assert that tx-sender is current royalty-address
            (asserts! (is-eq current-royalty-address tx-sender) (err "err-not-current-royalty-address"))

            ;; Map-set / Merge exisiting collection tuple w/ new royalty-address
            (ok (map-set collection nft-collection 
                    (merge 
                        current-collection
                        {royalty-address: new-royalty}
                    )
            ))
    )
)

;;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Accept/reject whitelisting
(define-public (whitelisting-approval (nft-collection principal)) 
    (let         
        (
             (current-collection (unwrap! (map-get? collection nft-collection) (err "err-not-whitelisted")))
        )

            ;; Asserts that tx-sender is an admin
            (asserts! (is-some (index-of? (var-get admins) tx-sender)) (err "err-not-an-admin"))   

            ;; Map-set nft-collection with whitelisted
            (map-set collection nft-collection 
                (merge
                    current-collection
                    {whitelisted: true}  
                )
            )

            ;; Map-set collection-listings
            (ok (map-set collection-listing nft-collection (list )))

        
    )
)

;; Add admin
(define-public (add-admin (new-admin principal)) 
    (let      
        (
            (current-admin (var-get admins))
        )
            ;; Assert that tx-sender is an admin
            (asserts! (is-some (index-of? (var-get admins) tx-sender)) (err "err-not-admin"))

            ;; Assert that new-admin is not already admin
            (asserts! (is-none (index-of? (var-get admins) new-admin)) (err "err-already-admin"))

            ;; Var-set admins by appending new-admin
            (ok (var-set admins (unwrap! (as-max-len? (append current-admin new-admin) u20) (err "err-admin-overflow"))))
    )
)

;; Remove admin
(define-public (remove-admin (admin principal)) 
    (let       
        (
            (current-admin (var-get admins))
        )
            ;; Assert that tx-sender is admin
            (asserts! (is-some (index-of? (var-get admins) tx-sender)) (err "err-not-admin"))

            ;; Assert that remove admin exists
            (asserts! (is-some (index-of (var-get admins) admin)) (err "err-admin-does-not-exist"))

            ;; Var-set helper principal
            (var-set helper-principal admin)

            ;; Filter-set remove admin
            (ok (filter remove-principal-from-list current-admin))

    )
)


;;;;;;;;;;;;;;;;;;;;;;
;; Helper Function;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Filter uint from list
(define-private (remove-uint-from-list (helper-item uint)) 
    (not (is-eq helper-item (var-get helper-uint)))
)

(define-private (remove-principal-from-list (helper-remover principal)) 
    (not (is-eq helper-remover (var-get helper-principal)))
)


;; Things i'll test manually for : 
    ;; 1. Artist submits a collection
        ;; Submit single NFT
    ;; 2. Admin apporves whitelists collection
    ;; 3. User mints NFT
    ;; 4. User lists NFT
    ;; 5.1 User buys NFT
    ;; 5.2 User unlists NFT