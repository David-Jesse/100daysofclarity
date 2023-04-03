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
