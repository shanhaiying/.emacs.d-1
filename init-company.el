(require 'company)

;; (add-hook 'after-init-hook 'global-company-mode)

;; does not matter, I never use this hotkey
;; (global-set-key (kbd "TAB") 'company-complete)
;; (global-set-key (kbd "C-c o") 'company-complete)
(define-key company-mode-map (kbd "M-n") 'company-complete)
(setq company-require-match nil)

(if (fboundp 'evil-declare-change-repeat)
    (mapc #'evil-declare-change-repeat
          '(company-complete-common
            company-select-next
            company-select-previous
            company-complete-selection
            )))

(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-cmake)
     ;; I donot like the downcase code in company-dabbrev
     (setq company-backends (delete 'company-dabbrev company-backends))
     (setq company-begin-commands '(self-insert-command))
     (setq company-idle-delay 0.2)
     ))

(require 'color)

(let ((bg (face-attribute 'default :background)))
  (custom-set-faces
   `(company-tooltip ((t (:inherit default :background ,(color-lighten-name bg 10)))))
   `(company-scrollbar-bg ((t (:background ,(color-lighten-name bg 20)))))
   `(company-scrollbar-fg ((t (:background ,(color-lighten-name bg 15)))))
   `(company-tooltip-selection ((t (:inherit font-lock-function-name-face :background ,(color-lighten-name bg 5)))))
   `(company-tooltip-common ((t (:inherit font-lock-constant-face))))))

(provide 'init-company)
