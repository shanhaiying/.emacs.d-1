(require 'which-func)
(add-to-list 'which-func-modes 'org-mode)
(add-to-list 'which-func-modes 'c-mode)
(add-to-list 'which-func-modes 'c++-mode)
(add-to-list 'which-func-modes 'java-mode)
;; (add-to-list 'which-func-modes 'lisp-mode)
;; (add-to-list 'which-func-modes 'emacs-lisp-mode)
(which-func-mode 1)

;; @see http://emacs-fu.blogspot.com/2011/08/customizing-mode-line.html
;; But I need global-mode-string,
;; @see http://www.delorie.com/gnu/docs/elisp-manual-21/elisp_360.html
;; use setq-default to set it for /all/ modes
;; (setq-default mode-line-format
;;               (list
;;                "%e"
;;                ;; '(:eval (window-numbering-get-number-string))
;;                " "
;;                '(mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position)

;;                " "
;;                ;; the buffer name; the file name as a tool tip
;;                '(:eval (propertize "%b" 'face 'nil
;;                                    'help-echo (buffer-file-name)))
;;                ;; was this buffer modified since the last save?
;;                '(:eval (when (buffer-modified-p)
;;                          (propertize "*"
;; 	       			     'face nil
;; 	       			     'help-echo "Buffer has been modified")))

;;                ;; line and column
;;                "  (" ;; '%02' to set to 2 chars at least; prevents flickering
;;                ;; "%02l" "," "%01c"
;;                ;; (propertize "%02l" 'face 'font-lock-type-face) ","
;;                ;; (propertize "%02c" 'face 'font-lock-type-face)
;;                (propertize "%02l" 'face nil) ","
;;                (propertize "%02c" 'face nil)
;;                ") "

;;                '(vc-mode vc-mode)

;;                " "
;;                ;; the current major mode for the buffer.
;;                "["

;;                '(:eval (propertize "%m" 'face nil
;;                                    'help-echo buffer-file-coding-system))

;;                ;; insert vs overwrite mode, input-method in a tooltip
;;                '(:eval (propertize (if overwrite-mode " Ovr" " Ins")
;;                                    'face nil
;;                                    'help-echo (concat "Buffer is in "
;;                                                       (if overwrite-mode "overwrite" "insert") " mode")))

;;                ;; ;; was this buffer modified since the last save?
;;                ;; '(:eval (when (buffer-modified-p)
;;                ;;           (concat ","  (propertize "Mod"
;;                ;;                                    'face nil
;;                ;;                                    'help-echo "Buffer has been modified"))))

;;                ;; is this buffer read-only?
;;                '(:eval (when buffer-read-only
;;                          (concat ","  (propertize "RO"
;;                                                   'face nil
;;                                                   'help-echo "Buffer is read-only"))))
;;                "] "

;;                ;; ;;global-mode-string, org-timer-set-timer in org-mode need this
;;                ;; (propertize "%M" 'face nil)

;;                '(" " mode-line-misc-info mode-line-end-space)

;;                ;; " --"
;;                ;; ;; i don't want to see minor-modes; but if you want, uncomment this:
;;                ;; ;; minor-mode-alist  ;; list of minor modes
;;                ;; "%-" ;; fill with '-'
;;                ))

(custom-set-variables
 '(mode-line-format
   (quote ("%e"
	   ;; (:eval (window-numbering-get-number-string))
	   mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification
	   "  " mode-line-position
	   ;; "  (%02l,%02c) "
	   (vc-mode vc-mode)
	   " (%m) " mode-line-misc-info mode-line-end-spaces))))

(provide 'init-modeline)
