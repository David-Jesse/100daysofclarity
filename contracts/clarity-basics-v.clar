;; title: clarity-basics-v
;; Reviewing more Clarity fundamentals
;; Written by David-Jesse

;; Day 45 - Introduction to private functions
(define-read-only (say-hello-world-read) 
    (say-hello-world)
)

(define-public (say-hello-world-public) 
    (ok (say-hello-world))
)

(define-private (say-hello-world) 
    "Hello world"
)

;; Day 46 - Filter
(define-constant test-list (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10))
(define-read-only (test-filter-remove-smallerthan-5) 
    (filter filter-smaller-than-5 test-list)
)

(define-private (filter-smaller-than-5 (item uint)) 
    (< item u5)
)

(define-read-only (test-filter-remove-odd-nums) 
    (filter filter-remove-odd test-list)
)

(define-private (filter-remove-odd (item uint)) 
    (is-eq (mod item u2) u0)
)

(define-read-only (test-filter-remove-even-nums) 
    (filter test-filter-remove-even test-list)
)

(define-private (test-filter-remove-even (item uint)) 
    (not (is-eq (mod item u2) u0))
)

;; Day 47 - Map
;; Map is best used when we want the length of the list unchanged 
;; Iterates items through passed function, returns a sequence of exact same length
(define-constant test-list-string (list "Dave" "Charles" "John" "Basil" "Alicia"))
(define-read-only (test-map-increase-by-one) 
    (map add-by-one test-list)
)

(define-read-only (test-map-double) 
    (map map-double test-list)
)

(define-read-only (test-map-names) 
    (map hello-name test-list-string)
)

(define-private (add-by-one (item uint)) 
    (+ item u1)
)

(define-private (map-double (item uint)) 
    (* item u2)
)

(define-private (hello-name (item (string-ascii 24))) 
    (concat "Hello " item)
)

;; Day 48 - Map Revisited
(define-constant test-list-principals (list 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC))
(define-constant test-list-tuple (list {user: "Christine", balance: u40} {user: "Bolu", balance: u44} {user: "Betty", balance: u25}))

(define-public (test-send-stx-multiple) 
     (ok (map send-stx-multiple test-list-principals))
)

(define-private (send-stx-multiple (item principal)) 
    (stx-transfer? u100000000 tx-sender item)
)

(define-read-only (test-get-users) 
    (map get-user test-list-tuple)
)

(define-read-only (test-get-balance) 
    (map get-balance test-list-tuple)
)

(define-private (get-balance (item {user: (string-ascii 24), balance: uint}))
    (get balance item)
)

(define-private (get-user (item {user: (string-ascii 24), balance: uint}))
    (get user item)
)

;; Day 49 - Fold
;; Fold always returns with a single element
(define-constant test-list-ones (list u1 u1 u1 u1 u1))
(define-constant test-list-two (list u1 u2 u3 u4 u5))
(define-constant test-alphabets (list "e" "s" "s" "e"))

(define-read-only (fold-start-add-zero) 
    (fold + test-list-ones u0)
)

(define-read-only (fold-add-start-ten) 
    (fold + test-list-ones u10)
)

(define-read-only (fold-multiply-one) 
    (fold * test-list-two u1)
)

(define-read-only (fold-multiply-two) 
    (fold * test-list-two u2)
)

(define-read-only (fold-characters) 
    (fold concat-string test-alphabets "J")
)

(define-private (concat-string (a (string-ascii 10)) (b (string-ascii 10)))
     (unwrap-panic (as-max-len? (concat b a) u10))
)

;; Day 50 - Contract call
(define-read-only (call-basics-i-multiply) 
    (contract-call? .clarity-basics-i multiply )
)

(define-read-only (call-basics-i-hello-world) 
    (contract-call? .clarity-basics-i say-hello-world)
)

(define-public (call-basics-ii-hello-world (name (string-ascii 26))) 
    (contract-call? .clarity-basics-ii set-and-say-hello name)
)

(define-public (call-basics-iii-set-second-map (new-username (string-ascii 24)) (new-balance uint))
(begin 
    (try! (contract-call? .clarity-basics-ii set-and-say-hello new-username))
    (contract-call? .clarity-basics-iii set-second-map new-username new-balance none)
)
)


;; Day 52 - Native NFT Functions
;; (impl-trait .sip-09.nft-trait)
(define-non-fungible-token nft-test uint)
(define-public (test-mint) 
    (nft-mint? nft-test u0 tx-sender)
)

(define-read-only (test-get-owner (id uint)) 
    (nft-get-owner? nft-test id)
)
 (define-public (test-burn (id uint) (sender principal)) 
    (nft-burn? nft-test id sender)
 )

(define-public (test-transfer (id uint) (sender principal) (recipient principal)) 
    (nft-transfer? nft-test id sender recipient)
)

;; Day 53 - Basic Minting Logic
(define-non-fungible-token nft-test-2 uint)
(define-data-var nft-index uint u1)
(define-constant nft-limit u6)
(define-constant nft-price u10000000)
(define-constant nft-admin tx-sender)

(define-public (free-limited-mint (metadata-url (string-ascii 256)))  
    (let  
        (
            (current-index (var-get nft-index))
            (next-index (+ current-index u1))
        )

            ;; Assert that index < limit
            (asserts! (< current-index nft-limit) (err "No more NFTs"))

            ;; Charge 10 STX
            (unwrap! (stx-transfer? nft-price tx-sender nft-admin) (err "stx-transfer"))

            ;; Mint NFT to tx-sender
            (unwrap! (nft-mint? nft-test-2 current-index tx-sender) (err "nft-mint"))

            ;; Update and store Metadata URL
            (map-set nft-metadata current-index metadata-url)

            ;; Var-set NFT index increasing it by 1
            (ok (var-set nft-index next-index))

    )
)

;; Day 54 - Basic NFT Metadata Logic
(define-constant static-url "https://example.com/")
(define-map nft-metadata uint (string-ascii 256))


 (define-public (get-token-uri-test-1 (id uint)) 
    (ok static-url)
 )
 
(define-public (get-token-uri-2 (id uint)) 
    (ok (concat 
            static-url 
            (concat (uint-to-ascii id) ".json")

        )
    
    )
)

(define-public (get-token-uri (id uint)) 
    (ok (map-get? nft-metadata id))
)


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

