;;;; pass-list.lisp

(in-package #:pass-list)

(defun select-window-from-menu (windows fmt &optional prompt
                                              (filter-pred *window-menu-filter*))
  "Allow the user to select a window from the list passed in @var{windows}.  The
@var{fmt} argument specifies the window formatting used.  Returns the window
selected."
  (second (select-from-menu (current-screen)
                            (mapcar (lambda (w)
                                      (list (format-expand *window-formatters* fmt w) w))
                                    windows)
                            prompt
                            (or (position (current-window) windows) 0)  ; Initial selection
                            nil  ; Extra keymap
                            filter-pred)))

(split-string (run-shell-command "pass" t))

(select-from-menu (current-screen)
                  (split-string (run-shell-command "pass" t)))

(defun pass-list-files ()
  "Get list of files in pass"
    (mapcar (lambda (l)
              (string-trim " " l))
     (split-string
      (run-shell-command "pass git ls-files" t))))

(defun pass-list-entries ()
  "Get list of entries in pass"
  (mapcar (lambda (l)
            (subseq l 0 (- (length l) 4) ))
          (remove-if (lambda (l) (char= #\. (char l 0)))
                  (pass-list-files))))

(defun default-pass-menu-filter (item-string what user-input)
  "The default filter predicate for password menus."
  (menu-item-matches-regexp item-string what user-input))

(defvar *pass-menu-filter* #'default-pass-menu-filter
  "FIXME: The filter predicate used to filter menu items in window menus
  created by SELECT-WINDOW-FROM-MENU. The interface for filter
  predicates is described in the docstring for SELECT-FROM-ITEM.")

(defcommand pass-select-from-menu (&optional (qr nil)) ()
  "Copy a password to clipboard. Shows a QR code instead if QR is non-nil."
  (let* ((pass (car (select-from-menu (current-screen)
                                     (mapcar (lambda (l) (list l l)) (pass-list-entries))
                                     "Select password entry:"
                                     0 ; Initial selection
                                     nil  ; Extra keymap
                                     *pass-menu-filter*)))
           (command (if qr
                        "-q"
                        "-c")))
    (when pass
      (message "starting")
      (let ((p (sb-ext:run-program "/usr/bin/pass" (list "show" command pass)
                         :wait nil)))
        (setq pass-process p)
        (message "started pass")
        (sb-ext::process-wait p)
        (message "process exited")
        (let ((exit-code (sb-ext::process-exit-code p)))
          (cond
            ((= 0 exit-code) (message (format nil "Copied ~S" pass)))
            ((= 1 exit-code) (message (format nil "~S not in store" pass)))))))))

(defvar p (run-shell-command "pass show -c www/gitlab.com"))

run-prog
(defvar p (run-prog "/usr/bin/pass" :args (list "show" "-c" "www/gitlab.com") :wait nil))
(sb-ext::process-exit-code pass-process)
(sb-ext::process-error pass-process)
(sb-ext::process-output pass-process)
(sb-ext::process-pid pass-process)
(sb-ext::process-status pass-process)
(sb-ext:posix-environ)
(setq pass-process nil)
