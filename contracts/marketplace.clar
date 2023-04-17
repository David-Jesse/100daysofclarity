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
(define-map whitelisted-collections principal bool)

;; Whitelist collection
(define-map collection principal {
    name: (string-ascii 64),
    royalty-percent: uint,
    royalty-address: principal
})

;; List of all for sale in collection
(define-map collection-listing principal (list 10000 uint))

;; Item status
(define-map item-status {collection: principal, item: uint} {
    name: principal,
    price: uint
})


;;;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Get all whitelist collections
(define-read-only (is-collection-whitelisted (nft-collection principal)) 
    (map-get? whitelisted-collections nft-collection)
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
;; @param - nft-collecion: nft-trait, nft-item: uint
(define-public (buy-item (nft-collection <nft>) (nft-item uint)) 
    (let    
        (
            (okay true) 
        )   
            ;; Assert that NFT collection is whitelisted

            ;; Assert that item is listed

            ;; Assert tx-sender is NOT owner

            ;; Send STX (price - royalty) to owner

            ;; Send STX royalty to artist/royalty-address

            ;; Transfer NFT from custodial/contract to buyer/NFT

            ;; Map-delete item-listing


            (ok 1)
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
            (ok 1)
        )
            ;; Assert that tx-sender is current NFT owner

            ;; Assert that collection is whitelisted

            ;; Assert nft-item is not in collection listing

            ;; Assert that item-staus is none

            ;; Transfer NFT from tx-sender to contraxt

            ;; Map-set item-status with new price & owner (tx-sender)

            ;; Map-set item collection-listing




            (ok 1)
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
            
        )
            ;; Assert nft-item is in collection-listing

            ;; Assert nft-item item-status map-get is-some

            ;; Assert nft current owner is contract

            ;; Assert that tx-sender is owner from item-status tuple

            ;; Map-set merge item-status with new price

            
            (ok 1)
    )
)


;;;;;;;;;;;;;;;;;;;;;;
;; Artist Functions;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Submit collection

;; Change royalty address

;;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Accept/reject whitelisting

;; Add admin

;; Remove admin
