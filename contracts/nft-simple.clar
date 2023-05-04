;; Day 55
;; NFT-simple
;; The most simple NFT
;; Written by David-Jesse


;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Define NFT
(define-non-fungible-token simple-nft uint)

;; Adhere to SIP-09
(impl-trait .sip-09.nft-trait)

;; Collection Limit
(define-constant collection-limit u100)

;; Root URI
(define-constant collection-root-uri "ipfs://ipfs/QmYcrELFT5c9pjSygFFXkbjfbMHB5cBoWJDGaTvrP/")

;; NFT Price
(define-constant simple-nft-price u1000000)

;; Collection index
(define-data-var collection-index uint u1)



;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SIP-09 Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Get last token ID
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

;; Get token Owner
(define-public (get-owner (id uint)) 
    (ok (nft-get-owner? simple-nft id))
)

;; Transfer Function
(define-public (transfer (id uint) (sender principal) (recipient principal)) 
   (begin 
       ;; (asserts! (is-eq tx-sender sender) (err u1))
        (nft-transfer? simple-nft id sender recipient)
   )
)

;;;;;;;;;;;;;;;;;;;;;;
;; Core Functions ;;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Core Minting function
;; @desc: Core function for minting one nft-simple
(define-public (mint) 
    (let  
        (
            (current-index (var-get collection-index))
            (next-index (+ current-index u1))
        )
            ;; Assert that current-index is lower than collection-limit
            (asserts! (< current-index collection-limit)  (err "err-minted-out"))

            ;; Charge tx-sender for simple NFT
            (unwrap! (stx-transfer? simple-nft-price tx-sender (as-contract tx-sender)) (err "err-stx-transfer"))

            ;; Mint Simple NFT
             (unwrap! (nft-mint? simple-nft current-index tx-sender) (err "err-minting"))

             ;; Var-set collection index to next index
             (ok (var-set collection-index next-index))

    )
)

;;;;;;;;;;;;;;;;;;;;;;
;; Helper Functions;;;
;;;;;;;;;;;;;;;;;;;;;;

;; @desc utility function that takes in a uint & returns a string
;; @params value; the uint we're casting into a string to concatenate
;; thanks to Setzeus for guidiance

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