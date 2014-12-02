(require 'evernote-mode)
(setq evernote-username "zjzhenglj@163.com")
(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8"))
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)

;; (setq evernote-mode-hook
;;   '(lambda ()
;;      (...)))

(setq evernote-developer-token "S=s215:U=2cf95a1:E=15161d0cc7d:C=14a0a1f9e60:P=1cd:A=en-devtoken:V=2:H=4775ff03aaa4e19d35f0d94a353100be")

(provide 'init-evernote)
