;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: For Emacs >= 23.2, you must place this *before* any
;; CEDET component (including EIEIO) gets activated by another
;; package (Gnus, auth-source, ...).
;; (load-file "~/.emacs.d/cedet-1.1/common/cedet.el")

;; Enable EDE (Project Management) features
;; (global-ede-mode 1)

;; Enable EDE for a pre-existing C++ project
;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")


;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:

;; * This enables the database and idle reparse engines
;; (semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode,
;;   imenu support, and the semantic navigator
;; (semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as intellisense mode,
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-gaudy-code-helpers)

;; * This enables the use of Exuberant ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)
;;   Or, use one of these two types of support.
;;   Add support for new languages only via ctags.
;; (semantic-load-enable-primary-exuberent-ctags-support)
;;   Add support for using ctags as a backup parser.
;; (semantic-load-enable-secondary-exuberent-ctags-support)

;; Enable SRecode (Template management) minor-mode.
;; (global-srecode-minor-mode 1)



;; c/c++ include dir (ffap use mingw dirs)
(defvar user-include-dirs
  '("." "./include" "./inc" "./common" "./public"
    ".." "../include" "../inc" "../common" "../public"
    "../.." "../../include" "../../inc" "../../common" "../../public"
    )
  "User include dirs for c/c++ mode")

(defvar c-preprocessor-symbol-files
  '(
    )
  "Preprocessor symbol files for cedet")

;;; emacs-rc-cedet.el ---

(load-file "~/.emacs.d/cedet-bzr/cedet-devel-load.el")
(load-file "~/.emacs.d/cedet-bzr/contrib/cedet-contrib-load.el")
(add-to-list 'load-path "~/.emacs.d/cedet-bzr/contrib/")
(add-to-list  'Info-directory-list "~/.emacs.d/cedet-bzr/doc/info")

(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
                                        ;(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-show-unmatched-syntax-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-highlight-edits-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)

;; Activate semantic
(semantic-mode 1)

(require 'semantic/bovine/c)
(require 'semantic/bovine/clang)

(mapc (lambda (dir)
        (semantic-add-system-include dir 'c++-mode)
        (semantic-add-system-include dir 'c-mode))
      user-include-dirs)

(require 'cedet-files)

;; loading contrib...
(require 'eassist)

(require 'semantic/ia)
(defadvice push-mark (around semantic-mru-bookmark activate)
  "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
If `semantic-mru-bookmark-mode' is active, also push a tag onto
the mru bookmark stack."
  (semantic-mrub-push semantic-mru-bookmark-ring
                      (point)
                      'mark)
  ad-do-it)

(defvar semantic-jump-depth 0)
(defun semantic-ia-fast-jump-back ()
  (interactive)
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (if (> semantic-jump-depth 0)
      (let* ((ring (oref semantic-mru-bookmark-ring ring))
             (alist (semantic-mrub-ring-to-assoc-list ring))
             (first (cdr (car alist))))
        ;; (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
        ;;     (setq first (cdr (car (cdr alist)))))
        (semantic-mrub-visit first)
        (ring-remove ring 0)
        (setq semantic-jump-depth (- semantic-jump-depth 1)))
    ))
(defun semantic-ia-fast-jump-or-back (&optional back)
  (interactive "P")
  (if back
      (semantic-ia-fast-jump-back)
    (progn
      (semantic-ia-fast-jump (point))
      (setq semantic-jump-depth (+ semantic-jump-depth 1)))))


(defun semantic-ia-insert-tag-default (tag)
  "Insert TAG into the current buffer based on completion."
  (insert (semantic-tag-name tag))
  (let ((tt (semantic-tag-class tag)))
    (cond ((eq tt 'function)
           (insert "()")
           (backward-char))
          (t nil))))

;; customisation of modes
(defun z/cedet-hook ()
  (local-set-key [(control tab)] 'semantic-ia-complete-symbol-menu)
  ;; (local-set-key "\M-n" 'semantic-ia-complete-symbol-menu)
  ;; (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
  ;; ;;
  ;; (local-set-key "\C-c>" 'semantic-comsemantic-ia-complete-symbolplete-analyze-inline)
  ;; (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  ;; (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  ;; (local-set-key "\C-cb" 'semantic-ia-fast-jump-back)
  (local-set-key "\C-c\C-d" 'semantic-ia-show-doc)
  (local-set-key "\C-c\C-s" 'semantic-ia-show-summary)
  ;; (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key [f12] 'semantic-ia-fast-jump-or-back)
  (local-set-key [C-f12] 'semantic-mrub-switch-tags)
  (local-set-key [S-f12] 'semantic-ia-fast-jump-back)
  (local-set-key (kbd "ESC <f12>") 'semantic-ia-fast-jump-back)
  ;; (local-set-key (kbd "ESC ESC <f12>")
  ;;   'semantic-ia-fast-jump-back)
  ;; (local-set-key [S-f12] 'pop-global-mark)
  ;; (local-set-key [mouse-2] 'semantic-ia-fast-jump-mouse)
  (local-set-key [S-mouse-2] 'semantic-ia-fast-jump-back)
  (local-set-key [double-mouse-2] 'semantic-ia-fast-jump-back)
  (local-set-key [M-S-f12] 'semantic-analyze-proto-impl-toggle)
  (local-set-key (kbd "C-c , ,") 'semantic-force-refresh)
  ;;  (local-set-key (kbd "C-c <left>") 'semantic-tag-folding-fold-block)
  ;;  (local-set-key (kbd "C-c <right>") 'semantic-tag-folding-show-block)

  ;; (add-to-list 'ac-sources 'ac-source-semantic)
  (local-set-key (kbd "C-c o") 'eassist-switch-h-cpp)
  )

;; (add-hook 'semantic-init-hooks 'z/cedet-hook)
(add-hook 'c-mode-common-hook 'z/cedet-hook)
(add-hook 'lisp-mode-hook 'z/cedet-hook)
(add-hook 'scheme-mode-hook 'z/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'z/cedet-hook)
(add-hook 'erlang-mode-hook 'z/cedet-hook)
(add-hook 'python-mode-hook 'z/cedet-hook)

;; (defun z/c-mode-cedet-hook ()
;;  ;; (local-set-key "." 'semantic-complete-self-insert)
;;  ;; (local-set-key ">" 'semantic-complete-self-insert)
;;   (local-set-key "\C-ct" 'eassist-switch-h-cpp)
;;   (local-set-key "\C-xt" 'eassist-switch-h-cpp)
;;   (local-set-key "\C-ce" 'eassist-list-methods)
;;   (local-set-key "\C-c\C-r" 'semantic-symref)

;;   (add-to-list 'ac-sources 'ac-source-gtags)
;;   )
;; (add-hook 'c-mode-common-hook 'z/c-mode-cedet-hook)

(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'c-mode t)
  (semanticdb-enable-gnu-global-databases 'c++-mode t))

(when (cedet-ectag-version-check t)
  (semantic-load-enable-primary-ectags-support))

;; SRecode
(global-srecode-minor-mode 1)

;; EDE
(global-ede-mode 1)
(ede-enable-generic-projects)

;; helper for boost setup...
(defun c++-setup-boost (boost-root)
  (when (file-accessible-directory-p boost-root)
    (let ((cfiles (cedet-files-list-recursively boost-root "\\(config\\|user\\)\\.hpp")))
      (dolist (file cfiles)
        (add-to-list 'semantic-lex-c-preprocessor-symbol-file file)))))


;; my functions for EDE
(defun z/ede-get-local-var (fname var)
  "fetch given variable var from :local-variables of project of file fname"
  (let* ((current-dir (file-name-directory fname))
         (prj (ede-current-project current-dir)))
    (when prj
      (let* ((ov (oref prj local-variables))
             (lst (assoc var ov)))
        (when lst
          (cdr lst))))))

;; ;; setup compile package
;; (require 'compile)
;; (setq compilation-disable-input nil)
;; (setq compilation-scroll-output t)
;; (setq mode-compile-always-save-buffer-p t)

;; (defun z/compile ()
;;   "Saves all unsaved buffers, and runs 'compile'."
;;   (interactive)
;;   (save-some-buffers t)
;;   (let* ((fname (or (buffer-file-name (current-buffer)) default-directory))
;;          (current-dir (file-name-directory fname))
;;          (prj (ede-current-project current-dir)))
;;     (if prj
;;         (project-compile-project prj)
;;       (compile compile-command))))
;; (global-set-key [f7] 'z/compile)

;; ;;
;; (defun z/gen-std-compile-string ()
;;   "Generates compile string for compiling CMake project in debug mode"
;;   (let* ((current-dir (file-name-directory
;;                        (or (buffer-file-name (current-buffer)) default-directory)))
;;          (prj (ede-current-project current-dir))
;;          (root-dir (ede-project-root-directory prj)))
;;     (concat "cd " root-dir "; make -j2")))

;; ;;
;; (defun z/gen-cmake-debug-compile-string ()
;;   "Generates compile string for compiling CMake project in debug mode"
;;   (let* ((current-dir (file-name-directory
;;                        (or (buffer-file-name (current-buffer)) default-directory)))
;;          (prj (ede-current-project current-dir))
;;          (root-dir (ede-project-root-directory prj))
;;          (subdir "")
;;          )
;;     (when (string-match root-dir current-dir)
;;       (setf subdir (substring current-dir (match-end 0))))
;;     (concat "cd " root-dir "Debug/" "; make -j3")))

;;; Projects

;; cpp-tests project definition
(when (file-exists-p "~/projects/lang-exp/cpp/CMakeLists.txt")
  (setq cpp-tests-project
        (ede-cpp-root-project "cpp-tests"
                              :file "~/projects/lang-exp/cpp/CMakeLists.txt"
                              :system-include-path '("/home/ott/exp/include"
                                                     boost-base-directory)
                              :compile-command "cd Debug && make -j2"
                              )))

(when (file-exists-p "~/projects/squid-gsb/README")
  (setq squid-gsb-project
        (ede-cpp-root-project "squid-gsb"
                              :file "~/projects/squid-gsb/README"
                              :system-include-path '("/home/ott/exp/include"
                                                     boost-base-directory)
                              :compile-command "cd Debug && make -j2"
                              )))

;; Setup JAVA....
(require 'semantic/db-javap)

;; example of java-root project

;; (ede-ant-project "Lucene"
;;             :file "~/work/lucene-solr/lucene-4.0.0/build.xml"
;;             :srcroot '("core/src")
;;             :classpath (cedet-files-list-recursively "~/work/lucene-solr/lucene-4.0.0/" ".*\.jar$")
;;             )

(provide 'init-cedet)