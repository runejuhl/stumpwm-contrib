;;;; amixer.asd

(asdf:defsystem #:amixer
  :serial t
  :description "Manipulate the volume using amixer"
  :author "Amy Templeton, Jonathan Moore Liles, Ivy Foster"
  :license "GPL v3"
  :components ((:file "package")
               (:file "amixer")))

