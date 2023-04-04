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
