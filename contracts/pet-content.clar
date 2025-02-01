;; Pet Content NFT contract
(define-non-fungible-token pet-content uint)

;; Constants
(define-constant ERR-NOT-AUTHORIZED (err u401))

;; Data vars
(define-map content
  { content-id: uint }
  {
    owner: principal,
    profile-id: uint,
    content-type: (string-utf8 20),
    content-hash: (buff 32),
    description: (string-utf8 500),
    timestamp: uint
  }
)

(define-data-var last-content-id uint u0)

;; Post new content
(define-public (post-content 
  (profile-id uint)
  (content-type (string-utf8 20))
  (content-hash (buff 32))
  (description (string-utf8 500)))
  (let ((new-id (+ (var-get last-content-id) u1)))
    (try! (nft-mint? pet-content new-id tx-sender))
    (map-set content
      { content-id: new-id }
      {
        owner: tx-sender,
        profile-id: profile-id,
        content-type: content-type,
        content-hash: content-hash,
        description: description,
        timestamp: block-height
      }
    )
    (var-set last-content-id new-id)
    (ok new-id)
  )
)
