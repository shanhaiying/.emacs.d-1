(setq flymake-gui-warnings-enabled nil)


;; Stop flymake from breaking when ruby-mode is invoked by mmm-mode,
;; at which point buffer-file-name is nil
(eval-after-load 'flymake
  '(progn
     (global-set-key (kbd "C-`") 'flymake-goto-next-error)

     (defun flymake-can-syntax-check-file (file-name)
       "Determine whether we can syntax check FILE-NAME.
Return nil if we cannot, non-nil if we can."
       (if (and file-name (flymake-get-init-function file-name)) t nil))
     ))

;; http://blog.urth.org/2011/06/02/flymake-versus-the-catalyst-restarter/
;; This function replaced the use of “flymake-create-temp-inplace” with “flymake-create-temp-intemp”, defined below.
;; It tells flymake to make its files in a temp directory. It make all *_flymake.* files in a temp directory.
(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking
   FILE-NAME. This is a replacement for
   `flymake-create-temp-inplace'. The difference is that it gives
   a file name in `temporary-file-directory' instead of the same
   directory as FILE-NAME.

   For the use of PREFIX see that function.

   Note that not making the temporary file in another directory
   \(like here) will not if the file you are checking depends on
   relative paths to other files \(for the type of checks flymake
   makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))

(setq temporary-file-directory "~/.emacs.d/tmp/")

;; Redefine this function in /usr/local/share/emacs/24.3/lisp/progmodes/flymake.el.gz
(defun flymake-simple-make-init ()
  (flymake-simple-make-init-impl 'flymake-create-temp-intemp t t "Makefile" 'flymake-get-make-cmdline))

(provide 'init-flymake)
