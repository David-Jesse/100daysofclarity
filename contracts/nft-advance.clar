;; NFT Advance
;; An advanced NFt that has all modern functions required for a high-quality NFT project
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

;;;;;;;;;;;;;;;;;;;;;;
;; SIP-09 Functions ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Get last token id


;; Get token URI


;; Transfer Token


;; Get Owner




;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Noncustodial Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List in ustx


;; Unlist in ustx


;; Buy in ustx


;; Check Listing



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