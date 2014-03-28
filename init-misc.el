;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
;; user information
(setq user-full-name "zhenglj")
(setq user-mail-address "zhenglj89@gmail.com")

(setq suggest-key-bindings-1 t)    ;suggest-key-bindings in minibuffer

(fset 'yes-or-no-p 'y-or-n-p)

;; NO automatic new line when scrolling down at buffer bottom
(setq next-line-add-newlines nil)

;; @see http://stackoverflow.com/questions/4222183/emacs-how-to-jump-to-function-definition-in-el-file
(global-set-key (kbd "C-h C-f") 'find-function)

					;Ctrl-X, u/l  to upper/lowercase regions without confirm
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Don't disable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)


;; workspace
(setq default-directory "~/projects/")
;; (setq default-directory "~/.emacs.d/dotemacs")

(if (not (file-exists-p (expand-file-name "~/.backups")))
    (make-directory (expand-file-name "~/.backups")))
(setq
 backup-by-coping t                     ; don't clobber symlinks
 backup-directory-alist '(("." . "~/.backups"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t  ;use versioned backups
 )

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

(dolist (mode '(c-mode c++-mode objc-mode java-mode jde-mode
                       perl-mode cperl-mode php-mode python-mode ruby-mode
                       lisp-mode emacs-lisp-mode xml-mode nxml-mode html-mode
                       lisp-interaction-mode sh-mode sgml-mode))
  (font-lock-add-keywords
   mode
   '(("\\<\\(FIXME\\|TODO\\|Todo\\)\\>" 1 font-lock-warning-face prepend)
     ("\\<\\(FIXME\\|TODO\\|Todo\\):" 1 font-lock-warning-face prepend))))

;; ;; ---------------------------------------------------------------
;; ;; calendar
;; ;; ---------------------------------------------------------------
;; (setq calendar-chinese-all-holidays-flag t)
;; (setq mark-holidays-in-calendar t)
;; ;; (setq calendar-week-start-day 1)
;; ;; (setq mark-diary-entries-in-calendar t)
;; (setq diary-file "~/.emacs.d/diary")
;; ;; (add-hook 'diary-hook 'appt-make-list)
;; ;; (setq appt-display-format 'window)
;; ;; (setq appt-display-mode-line t)
;; ;; (setq appt-display-diary nil)
;; (setq appt-display-duration (* 365 24 60 60))
;; (unless (daemonp)
;;   (appt-activate 1)
;;   (delete-other-windows))
;; ;; (diary 0)

;; ;; cal-china-x
;; (eval-after-load "calendar"
;;   '(when (require 'cal-china-x nil 'noerror)
;;      (setq cal-china-x-priority1-holidays
;;            (append cal-china-x-chinese-holidays
;;                    '((holiday-fixed 2 14 "情人节")
;;                      (holiday-fixed 3 8 "妇女节")
;;                      (holiday-fixed 3 12 "植树节")
;;                      (holiday-fixed 5 4 "青年节")
;;                      (holiday-fixed 6 1 "儿童节")
;;                      (holiday-fixed 9 10 "教师节")
;;                      (holiday-lunar 1 15 "元宵节(正月十五)" 0)
;;                      (holiday-lunar 7 7 "七夕节")
;;                      (holiday-lunar 9 9 "重阳节(九月初九)"))))
;;      (setq cal-china-x-priority2-holidays
;;            (append cal-china-x-chinese-holidays
;; 		   '((holiday-fixed 2 22 "Miss Gu's birthday")
;; 		     (holiday-fixed 5 29 "zhenglj's birthday")
;; 		     ;; (holiday-fixed 10 16 "")
;; 		     ;; (holiday-fixed 11 13 "")
;; 		     )))
;;      (setq calendar-holidays
;;            (append calendar-holidays
;;                    cal-china-x-priority1-holidays
;;                    cal-china-x-priority2-holidays))))

;; from RobinH
;; Time management
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)
;; (display-time)

;; advanced comment function
(defun my-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command. If no region is selected and current line is not blank and we are not at the end of the line, then comment current line. Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "C-M-;") 'my-comment-dwim-line)

(defun format-region ()
  "Format region, if no region actived, format current buffer.
Like eclipse's Ctrl+Alt+F."
  (interactive)
  (let ((start (point-min))
        (end (point-max)))
    (if (and (fboundp 'region-active-p) (region-active-p))
        (progn (setq start (region-beginning))
               (setq end (region-end)))
      (progn (when (fboundp 'whitespace-cleanup)
               (whitespace-cleanup))
             (setq end (point-max))))
    (save-excursion
      (save-restriction
        (narrow-to-region (point-min) end)
        (push-mark (point))
        (push-mark (point-max) nil t)
        (goto-char start)
        (when (fboundp 'whitespace-cleanup)
          (whitespace-cleanup))
        (untabify start (point-max))
        (indent-region start (point-max) nil)))))

(defun cxx-file-p (file)
  (let ((file-extension (file-name-extension file)))
    (and file-extension
         (string= file (file-name-sans-versions file))
         (find file-extension
               '("h" "hpp" "hxx" "c" "cpp" "cxx")
               :test 'string=))))

(defun format-cxx-file (file)
  "Format a c/c++ file."
  (interactive "F")
  (if (cxx-file-p file)
      (let ((buffer (find-file-noselect file))) ;; open buffer
        (save-excursion
          (set-buffer buffer)
          ;; (mark-whole-buffer)
          (when (fboundp 'whitespace-cleanup)
            (whitespace-cleanup))
          (untabify (point-min) (point-max))
          (indent-region (point-min) (point-max))
          (save-buffer)
          (kill-buffer)
          (message "Formated c++ file:%s" file)))
    (message "%s isn't a c++ file" file)))

(defun format-cxx-dired (dirname)
  "Format all c/c++ file in a directory."
  (interactive "D")
  ;; (message "directory:%s" dirname)
  (let ((files (directory-files dirname t)))
    (dolist (x files)
      (if (not (string= "." (substring (file-name-nondirectory x) 0 1)))
          (if (file-directory-p x)
              (format-cxx-dired x)
            (if (and (file-regular-p x)
                     (not (file-symlink-p x))
                     (cxx-file-p x))
                (format-cxx-file x)))))))
(global-set-key (kbd "ESC <f8>") 'format-region) ; putty
(global-set-key (kbd "C-S-f") 'format-region)

;;fullscreen
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))
;; (defun toggle-fullscreen ()
;;   (interactive)
;;   (x-send-client-message
;;    nil 0 nil "_NET_WM_STATE" 32
;;    '(2 "_NET_WM_STATE_FULLSCREEN" 0))
;;   )
(global-set-key [f11] 'toggle-fullscreen)

;; ---------------------------------------------------------------
;; hide or show
;; ---------------------------------------------------------------
(defvar hs--overlay-keymap nil "keymap for folding overlay")
(let ((map (make-sparse-keymap)))
  (define-key map [mouse-1] 'hs-show-block)
  (setq hs--overlay-keymap map))
(setq hs-set-up-overlay
      (defun my-display-code-line-counts (ov)
        (when (eq 'code (overlay-get ov 'hs))
          (overlay-put ov 'display
                       (propertize
                        (format "...<%d>"
                                (count-lines (overlay-start ov)
                                             (overlay-end ov)))
                        'face 'mode-line))
          (overlay-put ov 'priority (overlay-end ov))
          (overlay-put ov 'keymap hs--overlay-keymap)
          (overlay-put ov 'pointer 'hand))))
(eval-after-load "hideshow"
  '(progn (define-key hs-minor-mode-map [(shift mouse-2)] nil)
          (define-key hs-minor-mode-map (kbd "C-+") 'hs-toggle-hiding)
          (define-key hs-minor-mode-map (kbd "C-;") 'hs-hide-all)
          (define-key hs-minor-mode-map (kbd "C-\'") 'hs-show-all)
          ;; (define-key hs-minor-mode-map (kbd "C-:") 'hs-hide-block)
          ;; (define-key hs-minor-mode-map (kbd "C-\"") 'hs-show-block)
          ;; (define-key hs-minor-mode-map [/C-c l] 'hs-hide-level)
          ;; (define-key hs-minor-mode-map [/C-c t] 'hs-toggle-hiding)
          (define-key hs-minor-mode-map (kbd "<left-fringe> <mouse-2>")
            'hs-mouse-toggle-hiding)))
;; (global-set-key (kbd "C-?") 'hs-minor-mode)

;; ---------------------------------------------------------------
;; eshell
;; ---------------------------------------------------------------
;;open (e)shell
(defun open-eshell-other-buffer ()
  "Open eshell in other buffer"
  (interactive)
  (split-window-vertically)
  (eshell))

(global-set-key [(f6)] 'open-eshell-other-buffer) ;open eshell in other buffer
(global-set-key [C-f6] 'eshell)                   ;open eshell in current buffer

(when *win32*
  ;; resize frame
  (defun w32-maximize-frame ()
    "Maximize the current frame."
    (interactive)
    (w32-send-sys-command 61488)
    (global-set-key (kbd "C-c z") 'w32-restore-frame))

  (global-set-key (kbd "C-c z") 'w32-maximize-frame)

  (defun w32-restore-frame ()
    "Restore a minimized frame."
    (interactive)
    (w32-send-sys-command 61728)
    (global-set-key (kbd "C-c z") 'w32-maximize-frame))

  )

;; M-x ct ENTER
(defun ct (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   ;; (format "ctags -f %s/TAGS -e -R %s" dir-name (directory-file-name dir-name))
   (format "ctags -f %s/TAGS -R %s" dir-name (directory-file-name dir-name)))
  )

					; @see http://xahlee.blogspot.com/2012/01/emacs-tip-hotkey-for-repeat-complex.html
;; (global-set-key [f2] 'repeat-complex-command)

					;effective emacs item 3
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\M-s" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'tags-search)
(global-set-key "\C-x\C-n" 'find-file-other-frame) ;open new frame with a file

;;a no-op function to bind to if you want to set a keystroke to null
(defun void () "this is a no-op" (interactive))

					;convert a buffer from dos ^M end of lines to unix end of lines
(defun dos2unix ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

					;vice versa
(defun unix2dos ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n")))

					;show ascii table
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 255))
  (let ((i 0))
    (while (< i 256)
      (insert (format "%4d %c|\n" i i))
      (setq i (+ i 1))))
  (beginning-of-buffer))
;; ;; ascii
;; (autoload 'ascii-on        "ascii" "Turn on ASCII code display."   t)
;; (autoload 'ascii-off       "ascii" "Turn off ASCII code display."  t)
;; (autoload 'ascii-display   "ascii" "Toggle ASCII code display."    t)
;; (autoload 'ascii-customize "ascii" "Customize ASCII code display." t)


;; I'm in Australia now, so I set the locale to "en_AU"
(defun insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
		 ((not prefix) "%d.%m.%Y")
		 ((equal prefix '(4)) "%Y-%m-%d")
		 ((equal prefix '(16)) "%d %B %Y")))
	)
    (insert (format-time-string format))))

;;compute the length of the marked region
(defun region-length ()
  "length of a region"
  (interactive)
  (message (format "%d" (- (region-end) (region-beginning)))))

(defalias 'list-buffers 'ibuffer)
					;KEYBOARD SECTION
					;global keyb maps
(global-set-key "\C-xc" 'clipboard-kill-ring-save)
(global-set-key "\C-cc" 'copy-region-as-kill)

;; @see http://www.emacswiki.org/emacs/BetterRegisters
;; This is used in the function below to make marked points visible
(defface register-marker-face '((t (:background "grey")))
  "Used to mark register positions in a buffer."
  :group 'faces)

					;effective emacs item 7; no scrollbar, no menubar, no toolbar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
					;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
					;effiective emacs item9
(defalias 'qrr 'query-replace-regexp)

(setq-default regex-tool-backend 'perl)

;;; {{ clipboard stuff
;; Use the system clipboard
(setq x-select-enable-clipboard t)

;; ;; you need install xsel under Linux
;; ;; xclip has some problem when copying under Linux
;; (defun copy-yank-str (msg)
;;   (kill-new msg)
;;   (with-temp-buffer
;;     (insert msg)
;;     (shell-command-on-region (point-min) (point-max)
;;                              (cond
;;                               ((eq system-type 'cygwin) "putclip")
;;                               ((eq system-type 'darwin) "pbcopy")
;;                               (t "xsel -ib")
;;                               ))))

;; (defun copy-filename-of-current-buffer ()
;;   "copy file name (NOT full path) into the yank ring and OS clipboard"
;;   (interactive)
;;   (let ((filename))
;;     (when buffer-file-name
;;       (setq filename (file-name-nondirectory buffer-file-name))
;;       (kill-new filename)
;;       (copy-yank-str filename)
;;       (message "filename %s => clipboard & yank ring" filename)
;;       )))

;; (defun copy-full-path-of-current-buffer ()
;;   "copy full path into the yank ring and OS clipboard"
;;   (interactive)
;;   (when buffer-file-name
;;     (kill-new (file-truename buffer-file-name))
;;     (copy-yank-str (file-truename buffer-file-name))
;;     (message "full path of current buffer => clipboard & yank ring")
;;     ))

;; (global-set-key (kbd "C-x v f") 'copy-full-path-of-current-buffer)

;; (defun copy-to-x-clipboard ()
;;   (interactive)
;;   (if (region-active-p)
;;     (progn
;;      ; my clipboard manager only intercept CLIPBOARD
;;       (shell-command-on-region (region-beginning) (region-end)
;;         (cond
;;          (*cygwin* "putclip")
;;          (*is-a-mac* "pbcopy")
;;          (t "xsel -ib")
;;          )
;;         )
;;       (message "Yanked region to clipboard!")
;;       (deactivate-mark))
;;     (message "No region active; can't yank to clipboard!")))

;; (defun paste-from-x-clipboard()
;;   (interactive)
;;   (shell-command
;;    (cond
;;     (*cygwin* "getclip")
;;     (*is-a-mac* "pbpaste")
;;     (t "xsel -ob")
;;     )
;;    1)
;;   )
;; ;;; }}

(eval-after-load "speedbar" '(if (load "mwheel" t)
				 ;; Enable wheelmouse support by default
				 (cond (window-system
					(mwheel-install)))))

					; @see http://www.emacswiki.org/emacs/SavePlace
(require 'saveplace)
(setq-default save-place t)

;; {{expand-region.el
;; if emacs-nox, use C-@, else, use C-2;
(if window-system
    (progn
      (define-key global-map (kbd "C-2") 'er/expand-region)
      (define-key global-map (kbd "C-M-2") 'er/contract-region)
      )
  (progn
    (define-key global-map (kbd "C-@") 'er/expand-region)
    (define-key global-map (kbd "C-M-@") 'er/contract-region)
    )
  )
;; }}

;;iedit-mode
(global-set-key (kbd "C-c ; i") 'iedit-mode-toggle-on-function)

;;align text
(global-set-key (kbd "C-c C-l") 'align-regexp)

;; ;; my screen is tiny, so I use minimum eshell prompt
;; (setq eshell-prompt-function
;;        (lambda ()
;;          (concat (getenv "USER") " $ ")))

;; max frame, @see https://github.com/rmm5t/maxframe.el
(require 'maxframe)
;; (setq mf-max-width 1600) ;; Pixel width of main monitor. for dual-lcd only
(add-hook 'window-setup-hook 'maximize-frame t)

;; command-frequency
;; (require 'command-frequency)
;; (command-frequency-table-load)
;; (command-frequency-mode 1)
;; (command-frequency-autosave-mode 1)

(defun toggle-env-http-proxy ()
  "set/unset the environment variable http_proxy which w3m uses"
  (interactive)
  (let ((proxy "http://127.0.0.1:8000"))
    (if (string= (getenv "http_proxy") proxy)
        ;; clear the the proxy
        (progn
          (setenv "http_proxy" "")
          (message "env http_proxy is empty now")
          )
      ;; set the proxy
      (setenv "http_proxy" proxy)
      (message "env http_proxy is %s now" proxy)
      )
    ))

(defun strip-convert-lines-into-one-big-string (beg end)
  "strip and convert selected lines into one big string which is copied into kill ring.
When transient-mark-mode is enabled, if no region is active then only the
current line is acted upon.

If the region begins or ends in the middle of a line, that entire line is
copied, even if the region is narrowed to the middle of a line.

Current position is preserved."
  (interactive "r")
  (let (str (orig-pos (point-marker)))
    (save-restriction
      (widen)
      (when (and transient-mark-mode (not (use-region-p)))
	(setq beg (line-beginning-position)
	      end (line-beginning-position 2)))

      (goto-char beg)
      (setq beg (line-beginning-position))
      (goto-char end)
      (unless (= (point) (line-beginning-position))
	(setq end (line-beginning-position 2)))

      (goto-char beg)
      (setq str (replace-regexp-in-string "[ \t]*\n" "" (replace-regexp-in-string "^[ \t]+" "" (buffer-substring-no-properties beg end))))
      ;; (message "str=%s" str)
      (kill-new str)
      (goto-char orig-pos)))
  )

;; enable for all programming modes
;; http://emacsredux.com/blog/2013/04/21/camelcase-aware-editing/
(add-hook 'prog-mode-hook 'subword-mode)

;; { smarter navigation to the beginning of a line
;; http://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line/
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)
;; }

(defun open-readme-in-git-root-directory ()
  (interactive)
  (let (filename
        (root-dir (locate-dominating-file (file-name-as-directory (file-name-directory buffer-file-name)) ".git"))
        )
    ;; (message "root-dir=%s" root-dir)
    (and root-dir (file-name-as-directory root-dir))
    (setq filename (concat root-dir "README.org"))
    (if (not (file-exists-p filename))
        (setq filename (concat root-dir "README.md"))
      )
    ;; (message "filename=%s" filename)
    (if (file-exists-p filename)
        (switch-to-buffer (find-file-noselect filename nil nil))
      (message "NO README.org or README.md found!"))
    ))
(global-set-key (kbd "C-c C-q") 'open-readme-in-git-root-directory)

;; from http://emacsredux.com/blog/2013/05/04/rename-file-and-buffer/
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)))))))
(global-set-key (kbd "C-c C-r")  'rename-file-and-buffer)

;; (defun copy-file-and-rename-buffer ()
;; "copy the current buffer and file it is visiting.
;; if the old file is under version control, the new file is added into
;; version control automatically"
;;   (interactive)
;;   (let ((filename (buffer-file-name)))
;;     (if (not (and filename (file-exists-p filename)))
;;         (message "Buffer is not visiting a file!")
;;       (let ((new-name (read-file-name "New name: " filename)))
;;         (copy-file filename new-name t)
;;         (rename-buffer new-name)
;;         (set-visited-file-name new-name)
;;         (set-buffer-modified-p nil)
;;         (when (vc-backend filename)
;;           (vc-register)
;;          )))))
;; (global-set-key (kbd "C-c c")  'copy-file-and-rename-buffer)

;; @see http://wenshanren.org/?p=298
(defun wenshan-edit-current-file-as-root ()
  "Edit the file that is associated with the current buffer as root"
  (interactive)
  (if (buffer-file-name)
      (progn
        (setq file (concat "/sudo:root@localhost:" (buffer-file-name)))
        (find-file file))
    (message "Current buffer does not have an associated file.")))

;; {{ eval and replace anywhere
;; @see http://emacs.wordpress.com/2007/01/17/eval-and-replace-anywhere/
(defun fc-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))
(global-set-key (kbd "C-c e") 'fc-eval-and-replace)

(defun calc-eval-and-insert (&optional start end)
  (interactive "r")
  (let ((result (calc-eval (buffer-substring-no-properties start end))))
    (goto-char (point-at-eol))
    (insert " = " result)))

(defun calc-eval-line-and-insert ()
  (interactive)
  (calc-eval-and-insert (point-at-bol) (point-at-eol)))
(global-set-key (kbd "C-c C-e") 'calc-eval-line-and-insert)
;; }}

;; input open source license
(require 'legalese)

;; edit confluence wiki
(autoload 'confluence-edit-mode "confluence-edit" "enable confluence-edit-mode" t)
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . confluence-edit-mode))

;; {{string-edit.el
(autoload 'string-edit-at-point "string-edit" "enable string-edit-mode" t)
;; }}

;; {{ issue-tracker
(global-set-key (kbd "C-c C-t") 'issue-tracker-increment-issue-id-under-cursor)
;; }}

;; {{ messge buffer things
(defun erase-message-buffer (&optional num)
  "Erase the content of the *Messages* buffer in emacs.
    Keep the last num lines if argument num if given."
  (interactive "p")
  (let ((message-buffer (get-buffer "*Messages*"))
        (old-buffer (current-buffer)))
    (save-excursion
      (if (buffer-live-p message-buffer)
          (progn
            (switch-to-buffer message-buffer)
            (if (not (null num))
                (progn
                  (end-of-buffer)
                  (dotimes (i num)
                    (previous-line))
                  (set-register t (buffer-substring (point) (point-max)))
                  (erase-buffer)
                  (insert (get-register t))
                  (switch-to-buffer old-buffer))
              (progn
                (erase-buffer)
                (switch-to-buffer old-buffer))))
        (error "Message buffer doesn't exists!")
        ))))

;; }}

;; vimrc
(require 'vimrc-mode)
(add-to-list 'auto-mode-alist '("\\.?vim\\(rc\\)?$" . vimrc-mode))

(require 'highlight-symbol)

;; {{ ack
(autoload 'ack-same "full-ack" nil t)
(autoload 'ack "full-ack" nil t)
(autoload 'ack-find-same-file "full-ack" nil t)
(autoload 'ack-find-file "full-ack" nil t)
;; }}

;; {{ show email sent by `git send-email' in gnus
(require 'gnus-article-treat-patch)
(setq gnus-article-patch-conditions
      '( "^@@ -[0-9]+,[0-9]+ \\+[0-9]+,[0-9]+ @@" ))
;; }}

;; (defun toggle-full-window()
;;   "Toggle the full view of selected window"
;;   (interactive)
;;   ;; @see http://www.gnu.org/software/emacs/manual/html_node/elisp/Splitting-Windows.html
;;   (if (window-parent)
;;       (delete-other-windows)
;;     (winner-undo)
;;     ))

;; {{ copy the file-name/full-path in dired buffer into clipboard
;; `w` => copy file name
;; `C-u 0 w` => copy full path
(defadvice dired-copy-filename-as-kill (after dired-filename-to-clipboard activate)
  (with-temp-buffer
    (insert (current-kill 0))
    (shell-command-on-region (point-min) (point-max)
                             (cond
                              ((eq system-type 'cygwin) "putclip")
                              ((eq system-type 'darwin) "pbcopy")
                              (t "xsel -ib")
                              )))
  (message "%s => clipboard" (current-kill 0))
  )

;; }}

(defun insert-file-link-from-clipboard ()
  "Make sure the full path of file exist in clipboard. This command will convert
The full path into relative path insert it as a local file link in org-mode"
  (interactive)
  (let (str)
    (with-temp-buffer
      (shell-command
       (cond
        (*cygwin* "getclip")
        (*is-a-mac* "pbpaste")
        (t "xsel -ob")
        )
       1)
      (setq str (buffer-string))
      )

    ;; convert to relative path (relative to current buffer) if possible
    (let ((m (string-match (file-name-directory (buffer-file-name)) str) ))
      (when m
        (if (= 0 m )
            (setq str (substring str (length (file-name-directory (buffer-file-name)))))
          )
        )
      (insert (format "[[file:%s]]" str))
      )
    ))

(defun convert-image-to-css-code ()
  "convert a image into css code (base64 encode)"
  (interactive)
  (let (str
        rlt
        (file (read-file-name "The path of image:"))
        )
    (with-temp-buffer
      (shell-command (concat "cat " file "|base64") 1)
      (setq str (replace-regexp-in-string "\n" "" (buffer-string)))
      )
    (setq rlt (concat "background:url(data:image/"
                      (car (last (split-string file "\\.")))
                      ";base64,"
                      str
                      ") no-repeat 0 0;"
                      ))
    (kill-new rlt)
    (copy-yank-str rlt)
    (message "css code => clipboard & yank ring")
    ))

(defun current-font-face ()
  "get the font face under cursor"
  (interactive)
  (let ((rlt (format "%S" (get-text-property (- (point) 1) 'face))))
    (kill-new rlt)
    (copy-yank-str rlt)
    (message "%s => clipboard & yank ring" rlt)
    ))

;; (when (< emacs-major-version 24)
;;   (require 'color-theme)
;;   (setq color-theme-is-global t)
;;   (color-theme-lethe)
;;   )

(defun add-pwd-into-load-path ()
  "add current directory into load-path, useful for elisp developers"
  (interactive)
  (let ((dir (expand-file-name default-directory)))
    (if (not (memq dir load-path))
        (add-to-list 'load-path dir)
      )
    (message "Directory added into load-path:%s" dir)
    )
  )

;; {{ save history
(setq history-length 8000)
(setq savehist-additional-variables '(search-ring regexp-search-ring kill-ring))
(savehist-mode 1)
;; }}

(setq system-time-locale "C")

;; ;; {{ unique lines
;; (defun uniquify-all-lines-region (start end)
;;   "Find duplicate lines in region START to END keeping first occurrence."
;;   (interactive "*r")
;;   (save-excursion
;;     (let ((end (copy-marker end)))
;;       (while
;;           (progn
;;             (goto-char start)
;;             (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
;;         (replace-match "\\1\n\\2")))))

;; (defun uniquify-all-lines-buffer ()
;;   "Delete duplicate lines in buffer and keep first occurrence."
;;   (interactive "*")
;;   (uniquify-all-lines-region (point-min) (point-max)))
;; ;; }}

;; {{start dictionary lookup
;; use below commands to create dicitonary
;; mkdir -p ~/.stardict/dic
;; # wordnet English => English
;; curl http://abloz.com/huzheng/stardict-dic/dict.org/stardict-dictd_www.dict.org_wn-2.4.2.tar.bz2 | tar jx -C ~/.stardict/dic
;; # Langdao Chinese => English
;; curl http://abloz.com/huzheng/stardict-dic/zh_CN/stardict-langdao-ec-gb-2.4.2.tar.bz2 | tar jx -C ~/.stardict/dic
;;
;; (setq sdcv-dictionary-simple-list '("朗道英汉字典5.0"))
;; (setq sdcv-dictionary-complete-list '("WordNet"))
;; (autoload 'sdcv-search-pointer "sdcv" "show word explanation in buffer" t)
;; (autoload 'sdcv-search-input+ "sdcv" "show word explanation in tooltip" t)
;; (global-set-key (kbd "C-c ; b") 'sdcv-search-pointer)
;; (global-set-key (kbd "C-c ; t") 'sdcv-search-input+)
;; }}

;; (defun evil-toggle-input-method ()
;;   "when toggle on input method, switch to evil-insert-state if possible.
;; when toggle off input method, switch to evil-normal-state if current state is evil-insert-state"
;;   (interactive)
;;   (if (not current-input-method)
;;       (if (not (string= evil-state "insert"))
;;           (evil-insert-state))
;;     (if (string= evil-state "insert")
;;         (evil-normal-state)
;;         ))
;;   (toggle-input-method))

;; (global-set-key (kbd "C-\\") 'evil-toggle-input-method)

;; color theme
(require 'color-theme)
(color-theme-molokai)

(global-set-key [f7] 'compile)
;; {{smart-compile: http://www.emacswiki.org/emacs/SmartCompile
(require 'smart-compile)
(global-set-key [C-f7] 'smart-compile)
;; }}

;; ;; auto-pair
;; (require 'autopair)
;; (autopair-global-mode)

(require 'undo-tree)
;; (global-undo-tree-mode)
;; (defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-/") 'undo) ; Ctrl+/
(global-set-key (kbd "C-?") 'undo-tree-redo) ; Ctrl+Shift+?

;; (require 'showtip)
(require 'sdcv)
(setq sdcv-dictionary-simple-path '("~/.stardict/dic/stardict-langdao-ec-gb-2.4.2/"))
(setq sdcv-dictionary-complete-path '("~/.stardict/dic/"))
(setq sdcv-dictionary-simple-list '("朗道英汉字典5.0"))
(setq sdcv-dictionary-complete-list
      '(
        "朗道英汉字典5.0"
        "懒虫简明英汉词典"
        "牛津现代英汉双解词典"
        "WordNet"))
(autoload 'sdcv-search-pointer+ "sdcv" "show word explanation in buffer" t)
(autoload 'sdcv-search-input "sdcv" "show word explanation in tooltip" t)
;; (autoload 'sdcv-search-pointer "sdcv" "show word explanation in buffer" t)
;; (autoload 'sdcv-search-input+ "sdcv" "show word explanation in tooltip" t)
(global-set-key (kbd "C-c ; b") 'sdcv-search-input)
(global-set-key (kbd "C-c ; t") 'sdcv-search-pointer+)
;; (global-set-key (kbd "C-c ; b") 'sdcv-search-pointer)
;; (global-set-key (kbd "C-c ; t") 'sdcv-search-input+)
;; (global-set-key (kbd "<f3> s") 'sdcv-search-pointer+)
;; (global-set-key (kbd "<f3> S") 'sdcv-search-input)

;; recent-jump
(when (require 'recent-jump nil 'noerror)
  (global-set-key (kbd "<M-S-left>") 'recent-jump-jump-backward)
  (global-set-key (kbd "<M-S-right>") 'recent-jump-jump-forward))

;; vlf
(autoload 'vlf "vlf" "View a Large File in Emacs." t)

(provide 'init-misc)
