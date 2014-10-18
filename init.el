;; -*- coding: utf-8 -*-
(setq emacs-load-start-time (current-time))
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *spell-check-support-enabled* t)
(setq *macbook-pro-support-enabled* t)
(setq *is-a-mac* (eq system-type 'darwin))
(setq *is-carbon-emacs* (and *is-a-mac* (eq window-system 'mac)))
(setq *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))
(setq *win32* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *linux-x* (and window-system *linux*) )
(setq *xemacs* (featurep 'xemacs) )
(setq *emacs23* (and (not *xemacs*) (or (>= emacs-major-version 23))) )
(setq *emacs24* (and (not *xemacs*) (or (>= emacs-major-version 24))) )

;; ----------------------------------------------------------------------------
;;  Load configs for specific features and modes
;; ----------------------------------------------------------------------------
(require 'init-modeline)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
(require 'init-cedet)                   ;from official bzr
;; (require 'init-cedet-buildin)

(require 'cl-lib)
;; (require 'init-compat)
;; (require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el

;; win32 auto configuration, assuming that cygwin is installed at "c:/cygwin"
(condition-case nil
    (when *win32*
      (setq cygwin-mount-cygwin-bin-directory "D:/cygwin/bin")
      (require 'setup-cygwin)
      ;; better to set HOME env in GUI
      ;; (setenv "HOME" "c:/cygwin/home/someuser")
      )
  (error
   (message "setup-cygwin failed, continue anyway")
   )
  )

(require 'init-elpa)                    ;App Store
(require 'init-exec-path)               ;Set up $PATH

;; -----------------------------------------------------------------
;;  basic configs
;; -----------------------------------------------------------------
(require 'init-fonts)
(if (not *cygwin*) (require 'init-popup))
(require 'init-parens)
(require 'init-frame-hooks)
(require 'init-xterm)
;; (require 'init-osx-keys)
;; (require 'init-gui-frames)
;; (require 'init-maxframe)
(require 'init-proxies)
;; (require 'init-dired)
(require 'init-isearch)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flymake)
;; (require 'init-artbollocks-mode)
(require 'init-recentf)
(require 'init-ido)
;; (require 'init-smex)
(if *emacs24* (require 'init-helm))
;; (require 'init-hippie-expand)
(require 'init-windows)
(require 'init-sessions)
;; (require 'init-growl)
;; (require 'init-editing-utils)           ;use with evil-mode
(require 'init-bm)
(require 'init-git)
(require 'init-emacspeak)
;; Chinese inut method
;; The interface python-ibus is broken with ibus 1.5, and the emacs interface ibus.el is non longer usable.
;; We can continue to use emacs with ibus letting the XIM do the input
;; (require 'init-ibus)
;; (if (not (boundp 'light-weight-emacs)) (require 'init-eim))

;; (require 'init-ctags)
(require 'init-gtags)
(require 'init-speedbar)

(require 'init-misc)
(require 'init-auto-insert)
(require 'init-linum-mode)

;; -----------------------------------------------------------------
;;  mode configs
;; -----------------------------------------------------------------
;; (require 'init-crontab)
;; (require 'init-textile)
(require 'init-markdown)
;; (require 'init-csv)
;; (require 'init-erlang)
(require 'init-javascript)
(require 'init-sh)
;; (require 'init-php)
(require 'init-org)
;; (require 'init-org-mime)
(require 'init-css)
;; (require 'init-haml)
(require 'init-python-mode)
;; (require 'init-haskell)
;; (require 'init-ruby-mode)
;; (require 'init-yari);; yari.el provides an Emacs frontend to Ruby's `ri' documentation tool. It offers lookup and completion.
;; (require 'init-lua-mode)
;; (require 'init-term-mode)
(require 'init-web-mode)
(require 'init-tex-mode)
(require 'init-lisp)
(require 'init-elisp)

(require 'init-cc-mode)
(require 'init-cmake-mode)
;; (require 'init-csharp-mode)

(require 'init-mode-hook)

;; ---------------------------------------------------------------------------
;; (require 'init-xref)

;; (require 'init-better-registers) ; C-x j - jump to register
(require 'init-zencoding-mode) ;emmet-mode, behind init-better-register to override C-j

;; (require 'init-fill-column-indicator) ;make auto-complete dropdown wierd
;; (if (not (boundp 'light-weight-emacs)) (require 'init-yasnippet))
(require 'init-yasnippet)
(when *emacs24*
  ;; Choose either auto-complete or company-mode by commenting one of below two lines!
  (require 'init-company)
  (require 'init-auto-complete) ; after init-yasnippeta to override TAB
  )

;; (require 'init-org2blog)

(when *spell-check-support-enabled*
  (require 'init-spelling))

;; (require 'init-marmalade)

;; Use bookmark instead

(require 'init-rcirc)                   ;IRC, Internet Relay Communication
;; (require 'init-delicious)               ;make startup slow, I don't use delicious in w3m
(require 'init-emacs-w3m)
;; (require 'init-thing-edit)
(require 'init-which-func)
(require 'init-keyfreq)
;; (require 'init-gist)
;; (require 'init-pomodoro)
;; (require 'init-moz)
;; use evil mode (vi key binding)
;; (if (not (boundp 'light-weight-emacs)) (require 'init-evil))
;; (require 'init-ace-jump-mode)
;; (require 'init-sunrise-commander)
;; (require 'init-bbdb)
;; (require 'init-gnus)
;; (require 'init-twittering-mode)
(require 'init-weibo)
;; itune cannot play flac, so I use mplayer+emms instead (updated, use mpd!)
(require 'init-emms)
(require 'init-doxygen)

;; (require 'init-workgroups2)

(require 'init-move-window-buffer)
;; (require 'init-slime)
;; (require 'init-stripe-buffer)
;; (require 'init-elnode)
(require 'init-zeal)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
;; Don't use emacsclient, and this code make emacs start up slow
;;(defconst --batch-mode (member "--batch-mode" command-line-args)
;;          "True when running in batch-mode (--batch-mode command-line switch set).")
;;
;;(unless --batch-mode
;;  (require 'server)
;;  (when (and (= emacs-major-version 23)
;;             (= emacs-minor-version 1)
;;             (equal window-system 'w32))
;;    ;; Suppress error "directory ~/.emacs.d/server is unsafe" on Windows.
;;    (defun server-ensure-safe-dir (dir) "Noop" t))
;;  (condition-case nil
;;      (unless (server-running-p) (server-start))
;;    (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
;;    (error
;;     (let* ((server-dir (if server-use-tcp server-auth-dir server-socket-dir)))
;;       (when (and server-use-tcp
;;                  (not (file-accessible-directory-p server-dir)))
;;         (display-warning
;;          'server (format "Creating %S" server-dir) :warning)
;;         (make-directory server-dir t)
;;         (server-start))))))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(if (file-readable-p (expand-file-name "~/.emacs.d/custom.el"))
    (load-file (expand-file-name "~/.emacs.d/custom.el"))
  nil)

;; load email configuration explicitly
(if (file-readable-p (expand-file-name "~/.gnus.el"))
    (load-file (expand-file-name "~/.gnus.el"))
  nil)
;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(require 'init-local nil t)

;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
					;(require 'init-locales) ;does not work in cygwin


(when (require 'time-date nil t)
  (message "[Emacs startup time]: %d seconds."
	   (time-to-seconds (time-since emacs-load-start-time)))
  )

(put 'erase-buffer 'disabled nil)
