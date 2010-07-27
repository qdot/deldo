(setq org-deldo-pattern-list
      '(("STARTED" .  ( (255 1) (0 0)))
        ("DONE" . ( (255 .25) (0 .25) (255 .25) (0 .25) (255 .25) (0 .25)  (0 0) ))
        )
)

(defun deldo-speed-for-time (element)
  (deldo-set-speed (car element))
  (sleep-for (cadr element))
)

(defun org-state-deldo-hook ()
  (mapc 'deldo-speed-for-time (cdr (assoc state org-deldo-pattern-list)))
)

(add-hook 'org-after-todo-state-change-hook 'org-state-deldo-hook)