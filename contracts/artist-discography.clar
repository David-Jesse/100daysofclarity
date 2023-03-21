;; Day 27 - Creating a smart contract that replicates the data structure required to make a streaming service
;; title: artist-discography
;; Contract that models an artist's discography (discography -> albums -> tracks)
;; Written by David-Jesse

;; Discography
;; An artists discography is a list of albums
;; The artist or admin can start a discography & can add/remove from the discography

;; Album
;; An album is a list of tracks + some additional information (such as when it was published)
;; The artist or an admin can start an album & can add remove tracks

;; Track
;; A track is made up of a name, a duration (in seconds), & a possible feature (optional feature)
;; The artist or an admin can start a track & can add/remove tracks


;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Admins list of principals
(define-data-var admin (list 10 principal) (list tx-sender))

;; Map that keeps track of a single track
(define-map track { artist: principal, album-id: uint,  track-id: uint } {
     title: (string-ascii 26),
     duration: uint,
     featured: (optional principal)
      }
)

;; Map that keeps track of a single album
(define-map album { artist: principal, album-id: uint } { 
   title: (string-ascii 26),
   tracks: (list 20 uint),
   height-published: uint
   })

;; Map that keeps track of a discography
(define-map discography principal (list 10 uint))

;; Day - 28
;;;;;;;;;;;;;;;;;;;;
;; Read Functions ;;
;;;;;;;;;;;;;;;;;;;;

;; Get track-data
(define-read-only (get-track-data (artist principal) (album-id uint) (track-id uint))
    (map-get? track {artist: artist, album-id: album-id, track-id: track-id})
)

;; Get album-data
(define-read-only (get-album-data (artist principal) (album-id uint)) 
    (get height-published (map-get? album {artist: artist, album-id: album-id}))
)

;; Get discography
(define-read-only (get-discography (artist principal))
    (map-get? discography artist)
)

;; Get published
(define-read-only (get-album-published-height (artist principal) (album-id uint)) 
    (map-get? album {artist: artist, album-id: album-id})
)

;; Get featured-artist
(define-read-only (get-featured-artist (artist principal) (album-id uint) (track-id uint)) 
    (get featured (map-get? track {artist: artist, album-id: album-id, track-id: track-id}))
)

;;;;;;;;;;;;;;;;;;;;;
;; Write Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; Add a track
;; @desc - Function that allows user or admin add a track
;; @params - (title (string-ascii 26) (duration uint) featured-artist (optional) album-id (uint))
(define-public (add-a-track (artist principal) (title (string-ascii 26)) (duration uint) (featured (optional principal)) (album-id uint))
    (let  
        (
            (current-discography (unwrap! (map-get? discography artist) (err u0)) )
            (current-album (unwrap! (index-of current-discography album-id) (err u1)))
            (current-album-data (unwrap! (map-get? album {artist: artist, album-id: album-id}) (err u3)))
            (current-album-tracks (get tracks current-album-data))
            (current-album-track-id (len current-album-tracks))
            (next-album-track-id (+ u1 current-album-track-id))
        )

        ;; Assert that tx-sender is either artist or admin
        (asserts! (or (is-eq tx-sender artist) (is-some (index-of (var-get admin) tx-sender))) (err u1))

        ;; Assert that album exists in discography
        (asserts! (is-some (index-of current-discography album-id)) (err u2))

        ;; Assert that duration is less than 600 (10mins)
        (asserts! (< duration u600) (err u3))

        ;; Map-set new track    
        (map-set track {artist: artist, album-id: album-id, track-id: next-album-track-id} 
            {
                title: title,
                duration: duration,
                featured: featured
            }
        )

        ;; Map-set album map by appending new track to album
        (map-set album {artist: artist, album-id: album-id} 
           (ok (merge 
                current-album-data
                {tracks: (unwrap! (as-max-len? (append current-album-tracks (next-album-track-id)) u4))}

            ))
        )

    )
)

;; Day 31
;; Add album
;; @desc - A function that allows an artist or admin add a new album or start a new discography and then add an album
(define-public (add-album-or-create-discography-and-add-album (artist principal) (album-title (string-ascii 26)))
    (ok (let  
        (
            (current-discography (default-to (list ) (map-get? discography artist)))
            (current-album-id (len current-discography))
            (next-album-id (+ u1 current-album-id))
        )

        ;; This where the body goes

            ;; Check whether discography exists / if discography is some
            (if (is-eq current-album-id u0)) 

                ;; Empty discography
                (begin  

                     (map-set discography artist (list current-album-id))
                     (map-set album {artist: principal, album-id: current-album-id} {

                        title: album-title,
                        tracks: (list ),
                        height-published: block-height

                     })

                
                )
               
        
                ;; Discography exists
                (begin  

                    (map-set discography (unwrap! (as-max-len? (append current-discography next-album-id) u4)))
                    (map-set album {artist: artist, album-id: next-album-id} {

                        title: album-title,
                        tracks: (list ),
                        height-published: block-height
                    })

                )
    ))

)


;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; add admin
;; @desc - Function that the exiting admin can call to add another admin
;; params - New admin (principal)

;; Remove admin
;; @desc - Function that removes an existing admin
;; params - removed-admin (principal)

(define-public (add-admin (new-admin principal)) 
    (let  
        (
            (test u0)

        )

        ;; Assert that tx-sender is an existing admin

        ;; Assert that new-admin does not exist in admin list

        ;; append new-admin to admin list

        (ok test)
    )
)

(define-public (remove-admin (removed-admin principal)) 
    (let   
        (
            (test u2)
        )
            ;; Assert that tx-sender is an existing Admin

            ;; Assert that removed admin IS an existing admin

            ;; Remove admin from admin-list
        

        (ok test)
    )
)