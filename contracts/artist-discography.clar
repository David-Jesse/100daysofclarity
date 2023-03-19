;; Day 27 - Creating a smart contract that replicates the data structure required to make a streaming service
;; title: artist-discography
;; Contract that models an artist's discography (discography -> albums -. tracks)
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
(define-map track { artist: principal, album: (string-ascii 26),  track-id: uint } {
     title: (string-ascii 26),
     duration: uint,
     featured:(optional principal)
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


;;;;;;;;;;;;;;;;;;;;;
;; Write Functions ;;
;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;
;; Admin Functions ;;
;;;;;;;;;;;;;;;;;;;;;