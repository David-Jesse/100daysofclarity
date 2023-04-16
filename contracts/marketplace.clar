;; Marketplace
;; Simple NFT Marketplace
;; Written by David-Jesse

;; Unique Properties
;; All Custodial
;; Multiple Admins
;; Collections *Have* to be whitelisted by admins
;; Only STX (no FT)

;; Selling an NFT Lifecycle
;; i. NFT is listed
;; ii. NFT is purchased
;; iii. STX is transfered
;; iv. NFT is Transfered
;; v. Listing is deleted

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


;;;;;;;;;;;;;;;;;;;;;;
;; Owner Functions ;;;
;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions;;;;
;;;;;;;;;;;;;;;;;;;;;;

