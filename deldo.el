;; deldo.el --- Time-stamp: <2009-11-05 17:00:17 qdot>

;; DelDO - Trancevibe control and hooking for emacs
;; Copyright 2009 Kyle Machulis <kyle at nonpolynomial dot com>
;; 

;; This file is *NOT* part of GNU Emacs

;; This file is distributed under the DO WHAT THE FUCK YOU WANT license.
;; If you did not receive a text of this license with the software source, eh.

(require 'osc)

(defcustom deldo-exec "python"
  "*Command to start external vibrator control program
Change to whatever you are using to control your vibrator"
  :type 'string
  :group 'deldo)

;; Open a connection to the vibration control process

(defun deldo-start-process()
  "Open connection to external vibrator control process"
  (interactive)  
  (start-process "DeldoControlProcess" "*DeldoControlProcess*"
                 "/Users/qdot/git-projects/deldo/deldo_server.py")
  )

;; Close connection to vibration control process

(defun deldo-end-process()
  "Close connection to external vibrator control process"
  (interactive)
  (when (get-process "DeldoControlProcess")
    (shell-command (concat deldo-exec " " "--die"))
    )
  )

;; Set speed of vibration

(defun deldo-set-speed(speed)
  "If connection open, send speed to vibration control process"
  (interactive)
  (when (not (get-process "DeldoControlProcess"))
    (deldo-start-process))
  (setq my-client (osc-make-client "127.0.0.1" 9001))
  (osc-send-message my-client "/deldo/speed" speed)
  (delete-process my-client)
  )

(defun scope-creep-count-scope-level ()
  (interactive)
  (let ((scope-count 0))
    (set 'one 1)
    (point-to-register 999)
    (condition-case paren-exit
        (while (> one 0) 
          (backward-up-list)
          (setq scope-count (+ 1 scope-count))
          )
      (error scope-count)
      )
    (jump-to-register 999)
    scope-count
    )
  )

(defun scope-creep-post-command-hook ()
  (deldo-set-speed (* 20 (scope-creep-count-scope-level)))
)

(define-minor-mode scope-creep-minor-mode "Turns on sexp evaluation for DelDO usage"
  'scope-creep-minor-mode
  " Scope-Creep"
  nil
  (if scope-creep-minor-mode
      (progn
        (message "Turning on Scope Creep minor mode")
        (add-hook 'post-command-hook 'scope-creep-post-command-hook)
        )
    (progn
      (message "Turning off Scope Creep minor mode")
      (remove-hook 'post-command-hook 'scope-creep-post-command-hook)
      )
    )
)

;; (defun deldo-getting-done-hook ()
;;   (if (string-equal "DONE" state)
;;       (progn
;;         (deldo-set-speed 255)
;;         (sit-for 1)
;;         (deldo-set-speed 0)
;;         )
;;     )
;; )

;; (add-hook 'org-after-todo-state-change-hook 'deldo-getting-done-hook) 
;; (remove-hook 'org-after-todo-state-change-hook 'deldo-getting-done-hook)

;; (add-to-list 'load-path "/Users/qdot/.emacs_files/elisp_src/rudel")
;; (add-to-list 'load-path "/Users/qdot/.emacs_files/elisp_src/rudel/jupiter")
;; (add-to-list 'load-path "/Users/qdot/.emacs_files/elisp_src/rudel/obby")

;; (require 'eieio)
;; (require 'rudel)
;; (require 'rudel-mode)
;; (require 'rudel-obby)
;; (require 'rudel-obby-server)
;; (require 'rudel-obby-client)

(defun deldo-reval-post-command-hook ()
  (eval-buffer)
)

(define-minor-mode deldo-reval-minor-mode "Turns on constant re-evaluation of current elisp buffer for DelDO usage"
  'deldo-reval-minor-mode
  " DelDO-reval"
  nil
  (if deldo-reval-minor-mode
      (progn
        (message "Turning on DelDO-reval minor mode")
        (add-hook 'post-command-hook 'deldo-reval-post-command-hook)
        )
    (progn
      (message "Turning off DelDO-reval minor mode")
      (remove-hook 'post-command-hook 'deldo-reval-post-command-hook)
      )
    )
)

