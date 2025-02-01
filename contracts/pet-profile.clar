;; Pet Profile NFT contract
(define-non-fungible-token pet-profile uint)

;; Data vars
(define-map profiles
  { profile-id: uint }
  {
    owner: principal,
    name: (string-utf8 100),
    pet-type: (string-utf8 50),
    birth-date: uint,
    bio: (string-utf8 500)
  }
)

(define-data-var last-profile-id uint u0)

;; Create new pet profile
(define-public (create-profile 
  (name (string-utf8 100))
  (pet-type (string-utf8 50))
  (birth-date uint)
  (bio (string-utf8 500)))
  (let ((new-id (+ (var-get last-profile-id) u1)))
    (try! (nft-mint? pet-profile new-id tx-sender))
    (map-set profiles
      { profile-id: new-id }
      {
        owner: tx-sender,
        name: name,
        pet-type: pet-type,
        birth-date: birth-date,
        bio: bio
      }
    )
    (var-set last-profile-id new-id)
    (ok new-id)
  )
)

;; Get profile details
(define-read-only (get-profile (profile-id uint))
  (map-get? profiles { profile-id: profile-id })
)
