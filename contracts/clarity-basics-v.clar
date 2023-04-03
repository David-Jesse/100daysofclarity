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

