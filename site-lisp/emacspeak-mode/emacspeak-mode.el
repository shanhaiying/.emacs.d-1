
(defconst emacspeak-version "0.1")
(defvar emacspeak-hook nil)

(defun emacspeak-version()
  (interactive)
  (message "version %s : %s" emacspeak-mode-version "moorekang@gmail.com"))

(defun speak-this-string ()
  (interactive)
  (skip-chars-backward "^ \t\n\"\'\(\)\<\>\!\&\;\\\[\]")
  (setq low (point))
  (skip-chars-forward "^ \t\n\"\'\(\)\<\>\!\&\;\\\[\]")
  (setq high (point))
  (copy-region-as-kill low high)
  (setq cmd_str (buffer-substring low high))
  (start-process  "espeak" nil "espeak" "-s" "160" "-g" "10" "-v" "en/en-us" cmd_str))

(defun emacspeak-speak-current-string()
  (interactive)
  (let ((pos (point)))
    (speak-this-string)
    (goto-char pos)))

;;if last char is not blank, speak last word you have just input
(defun emacspeak-speak-last-string()
  (interactive)
  (setq input_char (buffer-substring (- (point) 1) (point)))
  (setq  prev_char (buffer-substring (- (point) 2) (- (point) 1)))
  ;;only when emacspeak-mode is on , speak this word
  (if (and emacspeak-mode (string= input_char " ") (eq nil (string= prev_char " ")))
      (let ((prev_pos (point)))
        (backward-word 1)
        (speak-this-string)
        (goto-char prev_pos))))

(defun emacspeak-speak-buffer()
  (interactive)
  (setq cmd_str (buffer-substring (point-min) (point-max)))
  (start-process  "espeak" nil "espeak" "-s" "160" "-g" "10" "-v" "en/en-us" cmd_str))
;; (start-process  "espeak" nil "espeak" "-s" "100" cmd_str))

(defun emacspeak-speak-stop()
  (interactive)
  (shell-command "pkill -9 espeak")
  (message "stop speaking buffer"))

(defvar emacspeak-mode-map nil
  "Keymap for emacspeak minor mode")
(unless emacspeak-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-cc" 'emacspeak-speak-current-string)
    (define-key map "\C-cp" 'emacspeak-speak-buffer)
    (define-key map "\C-ct" 'emacspeak-speak-stop)
    (setq emacspeak-mode-map map)))

(define-minor-mode emacspeak-mode
  "this is the emacspeak-mode for Linux,
   read the word you have inputed into Emacs"
  ;; The indicator for the mode line.
  :lighter " ESpeak"
  :group 'emacspeak
  :keymap emacspeak-mode-map
  (add-hook 'post-self-insert-hook 'emacspeak-speak-last-string))

(provide 'emacspeak-mode)
