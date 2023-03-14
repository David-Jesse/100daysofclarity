;; community-hello-world
;; contract that provides a simple community billboard,readable by anyone but

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Constant that sets deployer principal as Admin
(define-constant admin tx-sender)

;; Error messages
(define-constant ERR-TX-SENDER-NOT-NEXT-USER (err u0))
(define-constant ERR-UPDATED-USER-NOT-EMPTY (err u1))
(define-constant ERR-TX-SENDER-IS-ADMIN (err u2))
(define-constant ERR-UPDATED-USER-PRINCIPAL-IS-NOT-ADMIN (err u3))
(define-constant ERR-UPDATED-USER-PRINCIPAL-NOT-CURRENT-USER (err u4))

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
(define-public (update-billboard (updated-user-name (string-ascii 24))) 

(ok (begin  

     ;; Assert that tx-sender is not the next-user (approved by Admin)
    (asserts! (is-eq tx-sender (var-get next-user)) ERR-TX-SENDER-NOT-NEXT-USER)

     ;; Assert that updated user-name is not empty
     (asserts! (not (is-eq updated-user-name "")) ERR-UPDATED-USER-NOT-EMPTY)

     ;; Var-set billboard with new keys
     (var-set billboard {
        new-user-principal: tx-sender,
        new-user-name: updated-user-name
     })
    ))
)

;; Admin set-new-user
;; @desc - Function used by admin to set / give permission to new-user
;; @params - Updated user-principal: principal
(define-public (admin-set-new-user (updated-user-principal principal)) 
   (ok (begin  

        ;; Assert that tx-sender is admin
        (asserts! (is-eq tx-sender admin) ERR-TX-SENDER-IS-ADMIN)

        ;; Assert that updated-user-principal is NOT admin
        (asserts! (not (is-eq tx-sender updated-user-principal)) ERR-UPDATED-USER-PRINCIPAL-IS-NOT-ADMIN)

        ;; Assert that updated user-principal is NOT current next-user
        (asserts! (not (is-eq updated-user-principal (var-get next-user))) ERR-UPDATED-USER-PRINCIPAL-NOT-CURRENT-USER)

        ;; Var-set next-user with updated-user-principal
        (var-set next-user updated-user-principal)
    ))
)
 