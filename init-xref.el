;; Xrefactory configuration part ;;
;; some Xrefactory defaults can be set here
;; (defvar xref-current-project nil) ;; can be also "my_project_name"
;; (defvar xref-key-binding 'none)
(defvar xref-key-binding 'local) ;; can be also 'local or 'global
(setq load-path (cons "/home/zhenglj/xref/emacs" load-path))
(setq exec-path (cons "/home/zhenglj/xref" exec-path))
(load "xrefactory")
;; end of Xrefactory configuration part ;;
(message "xrefactory loaded")

(provide 'init-xref)