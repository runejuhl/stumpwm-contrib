;;;; pass-list.asd

(asdf:defsystem #:pass-list
  :serial t
  :description "A simple password menu using pass (password-store.org)"
  :author "Rune Juhl Jacobsen <runejuhl@petardo.dk>"
  :license "GPLv3"
  :depends-on (#:stumpwm)
  :components ((:file "package")
               (:file "pass-list")))
