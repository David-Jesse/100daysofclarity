;; ;; NFT-simple
;; ;; The most simple NFT
;; ;; Written by David-Jesse


;; ;;;;;;;;;;;;;;;;;;;;;;
;; ;; Cons, Vars, Maps ;;
;; ;;;;;;;;;;;;;;;;;;;;;;

;; ;; Define NFT
;; (define-non-fungible-token simple-nft int)

;; ;; Adhere to SIP-09
;; (impl-trait .sip-09.nft-trait)

;; ;; Collection Limit
;; (define-constant collection-limit u100)

;; ;; Collection index
;; (define-data-var collection-index uint u1)

;; ;; Root URI
;; (define-constant collection-root-uri "ipfs://ipfs/QmYcrELFT5c9pjSygFFXkbjfbMHB5cBoWJDGaTvrP/")

;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; SIP-09 Functions ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Get last token ID
;; (define-public (get-last-token-id) 
;;     (ok (var-get collection-index))
;; )

;; ;; Get token URI
;; ;; (define-public (get-token-uri (id uint)) 
    
;; ;; )
;; ;;;;;;;;;;;;;;;;;;;;;;
;; ;; Core Functions ;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;



;; ;;;;;;;;;;;;;;;;;;;;;;
;; ;; Helper Functions;;;
;; ;;;;;;;;;;;;;;;;;;;;;;
