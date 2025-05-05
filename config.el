;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq-default fill-column 120
              cursor-type 'bar)

(set-face-attribute 'default nil :family "Iosevka")
(set-face-attribute 'variable-pitch nil :family "Iosevka Aile")

(after! org-modern
  (set-face-attribute 'org-modern-symbol nil :family "Iosevka"))

(after! avy
  (setq avy-keys '(?a ?o ?e ?e ?u ?i ?d ?h ?t ?n ?s)))

(map! "C-z" 'undo-fu-only-undo
      "C-S-z" 'undo-fu-only-redo
      "M-j" 'join-line
      "M-o" 'ace-window
      "M-z" 'zap-up-to-char
      "M-g c" 'avy-goto-char
      "M-g M-c" 'avy-goto-char
      "C-<tab>" 'switch-to-prev-buffer)

(map! :map lispy-mode-map
      "M-o" 'ace-window
      "M-j" 'join-line)

(map! :when (equal user-login-name "kiran")
      "C-c o a" 'aidermacs-transient-menu)

(use-package! async
  :config
  (defvar async-maximum-parallel-procs 4)
  (defvar async--parallel-procs 0)
  (defvar async--queue nil)
  (defvar-local async--cb nil)
  (advice-add #'async-start :around
              (lambda (orig-func func &optional callback)
                (if (>= async--parallel-procs async-maximum-parallel-procs)
                    (push `(,func ,callback) async--queue)
                  (cl-incf async--parallel-procs)
                  (let ((future (funcall orig-func func
                                         (lambda (re)
                                           (cl-decf async--parallel-procs)
                                           (when async--cb (funcall async--cb re))
                                           (when-let (args (pop async--queue))
                                             (apply #'async-start args))))))
                    (with-current-buffer (process-buffer future)
                      (setq async--cb callback)))))
              '((name . --queue-dispatch))))

(defun my/p4-exec-p4 (output-buffer
                      args
                      &optional clear-output-buffer)
  "Internal function called by various p4 commands."
  (save-excursion
    (if clear-output-buffer
        (progn
          (set-buffer output-buffer)
          (delete-region (point-min) (point-max))))
    (apply 'call-process
           "p4"
           (if (memq system-type '(ms-dos windows-nt)) "NUL" "/dev/null")
           output-buffer
           nil
           args)))


(defun my/p4-edit-file (&optional buffer)
  (interactive)
  (shell-command (format "p4 edit %s" (buffer-file-name buffer)))
  (revert-buffer))

(defun my/p4-add-file (&optional buffer)
  (interactive)
  (shell-command (format "p4 add %s" (buffer-file-name buffer))))

(defun my/p4-revert-file (&optional buffer)
  (interactive)
  (shell-command (format "p4 revert %s" (buffer-file-name buffer)))
  (revert-buffer nil t))

(defun my/p4-diff ()
  (interactive)
  (shell-command (format "p4vc diff %s" (buffer-file-name))))

(defvar my/p4-output-buffer-name "*P4 Output*" "P4 Output Buffer.")

(defun my/p4-noinput-buffer-action (cmd
                                    do-revert
                                    show-output
                                    &optional argument)
  "Internal function called by various p4 commands."
  (save-excursion
    (if (not (stringp cmd))
        (error "p4-noinput-buffer-action: Command not a string."))
    (save-excursion
      (if argument
          (my/p4-exec-p4 (get-buffer-create my/p4-output-buffer-name)
                         (append (list cmd) argument) t)
        (my/p4-exec-p4 (get-buffer-create my/p4-output-buffer-name)
                       (list cmd) t)))
    (if do-revert (revert-buffer t t))
    (if show-output
        (progn
          (delete-other-windows)
          (display-buffer my/p4-output-buffer-name t)))))

(defun my/p4-ediff ()
  "Use ediff to compare file with its original client version."
  (interactive)
  (require 'ediff)
  (my/p4-noinput-buffer-action "print"
                               nil
                               nil
                               (list "-q"
                                     (concat (buffer-file-name) "#have")))
  (let ((local (current-buffer))
        (depot (get-buffer-create my/p4-output-buffer-name)))
    (ediff-buffers depot
                   local
                   `((lambda ()
                       (make-local-variable 'ediff-cleanup-hook)
                       (setq ediff-cleanup-hook
                             (cons (lambda ()
                                     (kill-buffer ,depot))
                                   ediff-cleanup-hook)))))))

(map! "C-c v 4 e" 'my/p4-edit-file
      "C-c v 4 r" 'my/p4-revert-file
      "C-c v 4 d" 'my/p4-ediff
      "C-c v 4 a" 'my/p4-add-file)

(use-package! org
  :config
  (require 'org-crypt)
  (require 'org-id)
  (require 'org-attach)

  (org-crypt-use-before-save-magic)

  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'before-save-hook
                        (lambda ()
                          (org-align-tags t)
                          (org-map-entries 'org-id-get-create))
                        nil
                        t)))

  (setq org-link-make-description-function
        (lambda (link desc)
          (if (s-starts-with-p "file:" link)
              (string-replace ".org" "" (string-replace "file:" "" link))
            desc)))

  (let ((my-refile-file (expand-file-name "~/org/Inbox.org")))
    (setq
     org-directory "~/org"
     org-agenda-files '("~/org")
     org-default-notes-file my-refile-file
     org-capture-templates `(("t" "todo" entry (file ,my-refile-file)
                              "* TODO %?\n")
                             ("n" "note" entry (file ,my-refile-file)
                              "* %?\n")
                             ("m" "meeting" entry (file ,my-refile-file)
                              "* Meeting with %?\n")
                             ("h" "highlight" entry (file ,my-refile-file)
                              "* HIGHLIGHT %?\n")
                             ("l" "log" item (clock)
                              "Note taken on %U \\\ \n%?"
                              :prepend t))
     org-log-into-drawer t
     ;; org-log-state-notes-insert-after-drawers t
     org-blank-before-new-entry '((heading . nil) (plain-list-item . nil))
     org-use-tag-inheritance nil
     org-todo-keywords '((sequence "TODO(t)"
                                   "NEXT(n@/!)"
                                   "BLOCKED(b@/!)"
                                   "|"
                                   "DONE(d!)"
                                   "CANCELED(c@)"
                                   "HIGHLIGHT"))
     org-src-tab-acts-natively t
     org-refile-targets '((org-agenda-files :maxlevel . 1))
     org-refile-use-outline-path 'file
     org-outline-path-complete-in-steps nil
     org-plantuml-jar-path "/home/kiran/bin/plantuml.jar"
     org-adapt-indentation nil
     org-startup-indented t
     org-tags-column -117
     org-agenda-start-with-log-mode t
     org-html-head-include-default-style nil
     org-html-head-include-scripts nil
     org-export-with-sub-superscripts (quote {})
     org-agenda-window-setup 'only-window
     org-agenda-custom-commands '(("n" "Custom agenda view"
                                   ((tags-todo "meeting")
                                    (todo "BLOCKED")
                                    (todo "NEXT")
                                    (todo "TODO")
                                    (agenda "" ((org-agenda-span 1)
                                                (org-agenda-log-mode t)
                                                (org-agenda-log-mode-items '(closed clock state))))
                                    (agenda ""))))
     org-publish-project-alist
     '(("website"
        :base-directory "/home/kiran/projects/website"
        :base-extension "org"
        :exclude "navbar.org\\|build"
        :publishing-directory "/home/kiran/projects/website/build"
        :recursive t
        :publishing-function org-html-publish-to-html
        :headline-levels 6)
       ("website-static"
        :base-directory "/home/kiran/projects/website/static"
        :base-extension "css\\|pdf"
        :publishing-directory "/home/kiran/projects/website/build"
        :recursive t
        :publishing-function org-publish-attachment
        :headline-levels 6)))))

(use-package! async
  :config
  (defvar async-maximum-parallel-procs 4)
  (defvar async--parallel-procs 0)
  (defvar async--queue nil)
  (defvar-local async--cb nil)
  (advice-add #'async-start :around
              (lambda (orig-func func &optional callback)
                (if (>= async--parallel-procs async-maximum-parallel-procs)
                    (push `(,func ,callback) async--queue)
                  (cl-incf async--parallel-procs)
                  (let ((future (funcall orig-func func
                                         (lambda (re)
                                           (cl-decf async--parallel-procs)
                                           (when async--cb (funcall async--cb re))
                                           (when-let (args (pop async--queue))
                                             (apply #'async-start args))))))
                    (with-current-buffer (process-buffer future)
                      (setq async--cb callback)))))
              '((name . --queue-dispatch))))

(defun my/p4-exec-p4 (output-buffer
                      args
                      &optional clear-output-buffer)
  "Internal function called by various p4 commands."
  (save-excursion
    (if clear-output-buffer
        (progn
          (set-buffer output-buffer)
          (delete-region (point-min) (point-max))))
    (apply 'call-process
           "p4"
           (if (memq system-type '(ms-dos windows-nt)) "NUL" "/dev/null")
           output-buffer
           nil
           args)))


(defun my/p4-edit-file (&optional buffer)
  (interactive)
  (shell-command (format "p4 edit %s" (buffer-file-name buffer)))
  (revert-buffer))

(defun my/p4-add-file (&optional buffer)
  (interactive)
  (shell-command (format "p4 add %s" (buffer-file-name buffer))))

(defun my/p4-revert-file (&optional buffer)
  (interactive)
  (shell-command (format "p4 revert %s" (buffer-file-name buffer)))
  (revert-buffer nil t))

(defun my/p4-diff ()
  (interactive)
  (shell-command (format "p4vc diff %s" (buffer-file-name))))

(defvar my/p4-output-buffer-name "*P4 Output*" "P4 Output Buffer.")

(defun my/p4-noinput-buffer-action (cmd
                                    do-revert
                                    show-output
                                    &optional argument)
  "Internal function called by various p4 commands."
  (save-excursion
    (if (not (stringp cmd))
        (error "p4-noinput-buffer-action: Command not a string."))
    (save-excursion
      (if argument
          (my/p4-exec-p4 (get-buffer-create my/p4-output-buffer-name)
                         (append (list cmd) argument) t)
        (my/p4-exec-p4 (get-buffer-create my/p4-output-buffer-name)
                       (list cmd) t)))
    (if do-revert (revert-buffer t t))
    (if show-output
        (progn
          (delete-other-windows)
          (display-buffer my/p4-output-buffer-name t)))))

(defun my/p4-ediff ()
  "Use ediff to compare file with its original client version."
  (interactive)
  (require 'ediff)
  (my/p4-noinput-buffer-action "print"
                               nil
                               nil
                               (list "-q"
                                     (concat (buffer-file-name) "#have")))
  (let ((local (current-buffer))
        (depot (get-buffer-create my/p4-output-buffer-name)))
    (ediff-buffers depot
                   local
                   `((lambda ()
                       (make-local-variable 'ediff-cleanup-hook)
                       (setq ediff-cleanup-hook
                             (cons (lambda ()
                                     (kill-buffer ,depot))
                                   ediff-cleanup-hook)))))))

(map! "C-c v 4 e" 'my/p4-edit-file
      "C-c v 4 r" 'my/p4-revert-file
      "C-c v 4 d" 'my/p4-ediff
      "C-c v 4 a" 'my/p4-add-file)

(use-package! org
  :config
  (require 'org-crypt)
  (require 'org-id)
  (require 'org-attach)

  (org-crypt-use-before-save-magic)

  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'before-save-hook
                        (lambda ()
                          (org-align-tags t)
                          (org-map-entries 'org-id-get-create))
                        nil
                        t)))

  (setq org-link-make-description-function
        (lambda (link desc)
          (if (s-starts-with-p "file:" link)
              (string-replace ".org" "" (string-replace "file:" "" link))
            desc)))

  (let ((my-refile-file (expand-file-name "~/org/Inbox.org")))
    (setq
     org-directory "~/org"
     org-agenda-files '("~/org")
     org-default-notes-file my-refile-file
     org-capture-templates `(("t" "todo" entry (file ,my-refile-file)
                              "* TODO %?\n")
                             ("n" "note" entry (file ,my-refile-file)
                              "* %?\n")
                             ("m" "meeting" entry (file ,my-refile-file)
                              "* Meeting with %?\n")
                             ("h" "highlight" entry (file ,my-refile-file)
                              "* HIGHLIGHT %?\n")
                             ("l" "log" item (clock)
                              "Note taken on %U \\\ \n%?"
                              :prepend t))
     org-log-into-drawer t
     ;; org-log-state-notes-insert-after-drawers t
     org-blank-before-new-entry '((heading . nil) (plain-list-item . nil))
     org-use-tag-inheritance nil
     org-todo-keywords '((sequence "TODO(t)"
                                   "NEXT(n@/!)"
                                   "BLOCKED(b@/!)"
                                   "|"
                                   "DONE(d!)"
                                   "CANCELED(c@)"
                                   "HIGHLIGHT"))
     org-src-tab-acts-natively t
     org-refile-targets '((org-agenda-files :maxlevel . 1))
     org-refile-use-outline-path 'file
     org-outline-path-complete-in-steps nil
     org-plantuml-jar-path "/home/kiran/bin/plantuml.jar"
     org-adapt-indentation nil
     org-startup-indented t
     org-tags-column -117
     org-agenda-start-with-log-mode t
     org-html-head-include-default-style nil
     org-html-head-include-scripts nil
     org-export-with-sub-superscripts (quote {})
     org-agenda-window-setup 'only-window
     org-agenda-custom-commands '(("n" "Custom agenda view"
                                   ((todo "TALK")
                                    (tags-todo "meeting")
                                    (todo "BLOCKED")
                                    (todo "REVIEW")
                                    (todo "NEXT")
                                    (todo "TODO")
                                    (agenda "" ((org-agenda-span 1)
                                                (org-agenda-log-mode t)
                                                (org-agenda-log-mode-items '(closed clock state))))
                                    (agenda ""))))
     org-publish-project-alist
     '(("website"
        :base-directory "/home/kiran/projects/website"
        :base-extension "org"
        :exclude "navbar.org\\|build"
        :publishing-directory "/home/kiran/projects/website/build"
        :recursive t
        :publishing-function org-html-publish-to-html
        :headline-levels 6)
       ("website-static"
        :base-directory "/home/kiran/projects/website/static"
        :base-extension "css\\|pdf"
        :publishing-directory "/home/kiran/projects/website/build"
        :recursive t
        :publishing-function org-publish-attachment
        :headline-levels 6)))))
