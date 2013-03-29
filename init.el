
(add-to-list 'load-path "~/.emacs.d/")  ;
(add-to-list 'load-path "~/.emacs.d/slime")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(require 'iso-transl)
(set-keyboard-coding-system 'utf-8) 

;NO DISTRACTIONS
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;MAX LINES
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
(setq-default fill-column 80)

;SELECTION
(setq x-select-enable-clipboard t)
(delete-selection-mode 1)

; INDENTATION
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;EL-GET
(require 'el-get)
(el-get 'sync)

(require 'auto-complete)
(global-auto-complete-mode t)

;THEME
(color-theme-solarized-dark)

(defun turn-on-paredit () (paredit-mode 1))

(add-hook 'prog-mode-hook (lambda ()
                       (auto-complete-mode)
                       (rainbow-mode)
                       (rainbow-delimiters-mode)
                       (my-keys-minor-mode)
                       (linum-mode)))

;PYTHON
(defun annotate-pdb ()
  (interactive)
  (highlight-lines-matching-regexp "import pdb")
  (highlight-lines-matching-regexp "pdb.set_trace()"))

(add-hook 'python-mode-hook (lambda () 
                              (jedi:setup)
                              (autopair-mode)
                              (annotate-pdb)))

(defun python-add-breakpoint ()
  (interactive)
  (py-newline-and-indent)
  (insert "import ipdb; ipdb.set_trace()")
  (highlight-lines-matching-regexp "^[ ]*import ipdb; ipdb.set_trace()"))

(define-key python-mode-map (kbd "C-c SPC") 'python-add-breakpoint)
(define-key python-mode-map (kbd "C-c C-c") #'py-execute-buffer-python3)

;JEDI
(setq jedi:setup-keys t)

;MACROS
(fset 'remove-spaces
   [?\M-m ?\C-  ?\C-e ?\M-x ?r ?e ?p ?l ?a ?c ?e ?- ?r ?e ?g ?e ?x ?p return ?\\ ?s ?- ?+ return ?  return ?\M-m])

;; ;AUCTEXT 
(setq-default TeX-PDF-mode t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;SLIME
(add-hook 'slime-mode-hook (lambda ()
                             (set-up-slime-ac)
                             (turn-on-paredit)))

(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

(setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
;(setq inferior-lisp-program "/usr/bin/ccl64") ; your Lisp system
(require 'slime)
(slime-setup '(slime-fancy)) ; 

;MARKDOWN
(add-hook 'markdown-mode-hook
          (lambda ()
            (flyspell-mode)
            (autopair-mode)
            (auto-fill-mode)))


;DIRED
;same buffer
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "<return>")
              'dired-find-alternate-file)
            (define-key dired-mode-map (kbd "^")
              (lambda () (interactive) (find-alternate-file "..")))
            ))

(defun open-in-external-app ()
  "Open the current file or dired marked files in external app.
Works in Microsoft Windows, Mac OS X, Linux."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )
    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList)
        )
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "open" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList) ) ) ) ) )


;SEMANTIC
(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-mru-bookmark-mode))
(semantic-mode 1)

; IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-file-extensions-order '(".java" ".js"))
(setq ido-ignore-extensions t)

(defun cycle-windows()
  "cycle the buffer of the windows in cyclic ordering"
  (interactive)
  (mapcar  (lambda(window)
                  (let ((next-window-buffer (window-buffer (next-window window 0))))
                      (set-window-buffer (next-window window 0) (window-buffer window))
                      (set-window-buffer window next-window-buffer))) (butlast (window-list nil 0))))
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "C-c C-w") 'cycle-windows)

(define-minor-mode my-keys-minor-mode
       "My mode to overwrite keys"
      :init-value nil
      ;; The indicator for the mode line.
      :lighter "My-Keys"
      ;; The minor mode bindings.
      :keymap my-keys-minor-mode-map
      :group 'mine)

(my-keys-minor-mode 1)

(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;;; Windows related operations
;; Split & Resize
(define-key global-map (kbd "C-c C-w") 'cycle-windows)
(define-key global-map (kbd "C-x |") 'split-window-horizontally)
(define-key global-map (kbd "C-x _") 'split-window-vertically)
(define-key global-map (kbd "C-{") 'shrink-window-horizontally)
(define-key global-map (kbd "C-}") 'enlarge-window-horizontally)
(define-key global-map (kbd "C-^") 'enlarge-window)
;; Navgating: Windmove uses C-<up> etc.
(define-key global-map (kbd "C-<up>"   ) 'windmove-up)
(define-key global-map (kbd "C-<down>" ) 'windmove-down)
(define-key global-map (kbd "C-<right>") 'windmove-right)
(define-key global-map (kbd "C-<left>" ) 'windmove-left)
;; Swap buffers: M-<up> etc.
(define-key global-map (kbd "M-<up>"   ) 'buf-move-up)
(define-key global-map (kbd "M-<down>" ) 'buf-move-down)
(define-key global-map (kbd "M-<right>") 'buf-move-right)
(define-key global-map (kbd "M-<left>" ) 'buf-move-left)
;; Tile
(define-key global-map (kbd "C-\\") 'tiling-cycle) ; accepts prefix number
(define-key global-map (kbd "C-M-<up>") 'tiling-tile-up)
(define-key global-map (kbd "C-M-<down>") 'tiling-tile-down)
(define-key global-map (kbd "C-M-<right>") 'tiling-tile-right)
(define-key global-map (kbd "C-M-<left>") 'tiling-tile-left)

;; Another type of representation of same keys, in case your terminal doesn't
;; recognize above key-binding. Tip: C-h k C-up etc. to see into what your
;; terminal tranlated the key sequence.
(define-key global-map (kbd "M-[ a"     ) 'windmove-up)
(define-key global-map (kbd "M-[ b"     ) 'windmove-down)
(define-key global-map (kbd "M-[ c"     ) 'windmove-right)
(define-key global-map (kbd "M-[ d"     ) 'windmove-left)
(define-key global-map (kbd "ESC <up>"   ) 'buf-move-up)
(define-key global-map (kbd "ESC <down>" ) 'buf-move-down)
(define-key global-map (kbd "ESC <right>") 'buf-move-right)
(define-key global-map (kbd "ESC <left>" ) 'buf-move-left)
(define-key global-map (kbd "ESC M-[ a" ) 'tiling-tile-up)
(define-key global-map (kbd "ESC M-[ b" ) 'tiling-tile-down)
(define-key global-map (kbd "ESC M-[ c" ) 'tiling-tile-right)
(define-key global-map (kbd "ESC M-[ d" ) 'tiling-tile-left)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))
 
;; get rid of `find-file-read-only' and replace it with something more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
 
;; enable recent files mode.
(recentf-mode t)
 
; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(setq enable-recursive-minibuffers t)

;BROWSER
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")

(defun read-only-if-symlink ()
  (if (file-symlink-p buffer-file-name)
      (progn
        (setq buffer-read-only t)
        (message "File is a symlink"))))

(defun visit-target-instead ()
  "Replace this buffer with a buffer visiting the link target."
  (interactive)
  (if buffer-file-name
      (let ((target (file-symlink-p buffer-file-name)))
        (if target
            (find-alternate-file target)
          (error "Not visiting a symlink")))
    (error "Not visiting a file")))

(add-hook 'find-file-hooks 'read-only-if-symlink)

;PACKAGES
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;CLOJURE
(add-hook 'clojure-mode-hook 'turn-on-paredit)

;Hiding the splash screen and banner
(setq inhibit-startup-message t
  inhibit-startup-echo-area-message t)

(tooltip-mode -1)
(setq tooltip-use-echo-area t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "microsoft" :slant normal :weight normal :height 143 :width normal)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-linum-mode nil)
 '(jabber-alert-presence-message-function (quote jabber-presence-only-chat-open-message))
 '(jabber-chat-buffer-show-avatar nil)
 '(jabber-message-alert-same-buffer nil)
 '(linum-eager t)
 '(safe-local-variable-values (quote ((eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook" (add-hook (quote write-contents-functions) (lambda nil (delete-trailing-whitespace) nil)) (require (quote whitespace)) "Sometimes the mode needs to be toggled off and on." (whitespace-mode 0) (whitespace-mode 1)) (whitespace-line-column . 80) (whitespace-style face trailing lines-tail) (require-final-newline . t))))
 '(show-paren-mode t)
 '(show-paren-style (quote parenthesis)))
(put 'dired-find-alternate-file 'disabled nil)
