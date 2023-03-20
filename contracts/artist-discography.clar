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
            (test u0)
        )

        ;; Assert that tx-sender is either artist or admin

        ;; Assert that album exists in discography

        ;; Assert that duration is less than 600 (10mins)

        ;; Map-set new track

        ;; Map-set append track to album

        (ok test)
    )
)


;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;

;; add admin
;; Remove admin
