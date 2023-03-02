;; community-hello-world
;; contract that provides a simple community billboard,readable by anyone but

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Constant that sets deployer principal as Admin
(define-constant admin tx-sender)

;; Variable that keeps track of the next user that'll introduce themselves to the billboard
(define-data-var next-user principal tx-sender)

;; Variable tuple that contains new member info
(define-data-var billboard {new-user-principal: principal, new-user-name: (string-ascii 24)} {
    new-user-principal: tx-sender,
    new-user-name: ""
})

;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;
;;;;;;;;;;;;;;;;;;;;

;; Get community billboard
(define-read-only (get-billboard) 
    (var-get billboard)
)

;; Get next user
(define-read-only (get-next-user) 
    (var-get next-user)
)

;;;;;;;;;;;;;;;;;;;;;
;; Write Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; Update-billboard
;; Function used by next user to update the community billboard
;; Params - new-user-name (string-ascii 24)
(define-private (update-billboard (updated-user-name (string-ascii 24))) 
    (begin  
     ;; Assert that tx-sender is not the next-user (approved by Admin)

     ;; Assert that updated user-name is not empty

     ;; Var-set billboard with new keys

        (ok true)
    )
)

;; Admin set-new-user
;; @desc - Function used by admin to set / give permission to new-user
;; @params - Updated user-principal: principal
(define-public (admin-set-new-user (updated-user-principal principal)) 
    (begin  

        ;; Assert that tx-sender is admin

        ;; Assert that updated-user-principal is NOT admin

        ;; Assert that updated user-principal is NOT current next-user

        ;; Var-set next-user with updated-user-principal

        (ok true)
        
    )
)