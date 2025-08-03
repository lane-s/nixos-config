
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; Set the default font size (comfortable for coding)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 21)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 30))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;;
(setq doom-localleader-key ",")

(setq ns-use-native-fullscreen 't)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(toggle-frame-fullscreen)

;; Also use SPC m for localleader
(defun lsp/call-localleader ()
  (interactive)
  (setq unread-command-events (listify-key-sequence ",")))
(map! :leader (:desc "localleader" "m" #'lsp/call-localleader))

(map! :leader
      "'" #'+vterm/here
      ";" #'lsp/comment-loc
      "SPC" #'execute-extended-command
      ;; Swap buffer selection commands so that
      ;; the most accessible binding searchs ALL buffers
      "b b" #'consult-buffer
      "b B" #'+vertico/switch-workspace-buffer
      "f o" #'projectile-find-other-file
      "s c" #'evil-ex-nohighlight
      "w m m" #'lsp/really-maximize-buffer
      "t d" #'toggle-debug-on-error)

;; Copilot l(Lm)
(map! :leader
      "l c c" #'copilot-complete
      "l c a" #'copilot-accept-completion
      "l c n" #'copilot-next-completion
      "l c p" #'copilot-previous-completion
      ;; TODO Add ask and replace selection
      ;; TODO Prompt prefix: only produce code with no explanation or other text
      "l f" #'copilot-chat-fix
      "l p" #'copilot-chat-ask-and-insert
      "l b a" #'copilot-chat-add-current-buffer
      "l b d" #'copilot-chat-del-current-buffer
      "l b r" #'copilot-chat-list-clear-buffers
      "l l" #'copilot-chat-list)

(map! "M-SPC" #'execute-extended-command)
(map! "M-i" #'embark-act)
(map! "M-o" #'embark-export)

(after! (org org-roam)
  (map! :map org-mode-map
        :localleader
        "i h" #'org-insert-heading
        "i s" #'org-insert-subheading)

  (setq evil-respect-visual-line-mode 't)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(t)" "PROJ(p)" "LOOP(r)" "STRT(s!)" "WAIT(w!)" "HOLD(h!)" "IDEA(i)" "|" "DONE(d!)" "KILL(k)")
          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
          (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

  (when (file-exists-p "~/org/daily-template.org")
    (setq org-roam-dailies-capture-templates
          (let ((head (f-read-text "~/org/daily-template.org")))
            `(("d" "default" entry "* %?"
               :if-new (file+head+olp "%<%Y-%m-%d>.org" ,head ()))))))

  (setq my-org-roam-context-alist
        `(("local" . ,(concat org-directory "/roam"))
          ("l30" . "~/src/catch.ideas/roam")
          ("shared" . ,(concat "~/.init-env" "/knowledge-base"))))

  (defun lsp/org-roam-switch-context (c)
    (interactive
     (list (completing-read "Choose: " my-org-roam-context-alist nil t)))
    (let* ((new-folder (cdr (assoc c my-org-roam-context-alist))))
      (message "Setting org-roam folder to `%s'" new-folder)
      (setq org-roam-directory new-folder)
      (org-roam-db-sync))
    c))

(map! "C-s" #'consult-line)

(map! :leader "j j" #'avy-goto-line-below)
(map! :leader "j k" #'avy-goto-line-above)
(map! :leader "j s" #'avy-goto-char-2)

(after! (magit)
  (map! :map git-rebase-mode-map
        "C-j" 'git-rebase-move-line-down
        "C-k" 'git-rebase-move-line-up))

(after! (lispy lispyville)
  (setq lispy-eval-display-style 'overlay)

  (setq lispyville-motions-put-into-special 't)
  (setq lispyville-preferred-lispy-state 'emacs)

  (lispy-define-key lispy-mode-map "s" 'lispy-different)
  (lispy-define-key lispy-mode-map "d" 'lispy-kill)
  (lispy-define-key lispy-mode-map "e" 'lispy-eval)
  (lispy-define-key lispy-mode-map "y" 'lispy-new-copy)
  (lispy-define-key lispy-mode-map "p" 'lispy-paste)
  (lispy-define-key lispy-mode-map "o" 'lispy-occur)
  (lispy-define-key lispy-mode-map "i" 'lispy-flow)
  (lispy-define-key lispy-mode-map "9" 'lispy-wrap-round)
  (lispy-define-key lispy-mode-map "A" 'lispy-ace-symbol-replace)
  (lispy-define-key lispy-mode-map ">" 'lispy-slurp-or-barf-left)
  (lispy-define-key lispy-mode-map "<" 'lispy-slurp-or-barf-right)

  (defun lsp/get-lisp-nesting-level ()
    "Return the current parenthesis nesting level at point."
    (interactive)
    (let ((depth (nth 0 (syntax-ppss))))
      (message "Current nesting level: %d" depth)
      depth))

  (defun lsp/lispy-ace-paren-top-level ()
    (interactive)
    (lispy-ace-paren (+ (lsp/get-lisp-nesting-level) 2)))

  (lispy-define-key lispy-mode-map "Q" 'lsp/lispy-ace-paren-top-level)

  (lispy-define-key lispy-mode-map "C-k" 'lispy-move-up)
  (lispy-define-key lispy-mode-map "C-j" 'lispy-move-down)

  ;; No auto-formatting
  (setq lispy-no-indent-modes '(scheme))

  (lispyville-set-key-theme
   '((operators normal)
     c-w
     (prettify insert)
     (atom-movement t)
     (additional-movement normal visual motion)
     mark-toggle
     slurp/barf-lispy additional additional-insert)))

;; Use system clangd
(setq lsp-clangd-binary-path "/usr/bin/clangd")
(setq lsp-auto-guess-root 't)


(setq user-name (getenv "USER"))

(when (string= user-name "lspangler")
  (setq inferior-lisp-program "/usr/local/bin/sbcl"))

(setq active-ssh-id-file "~/.ssh_id")

(when (not (file-exists-p active-ssh-id-file))
  (doom-file-write active-ssh-id-file "personal"))

(defun lsp/keychain-refresh-environment ()
  "Set ssh-agent and gpg-agent environment variables.

Set the environment variables `SSH_AUTH_SOCK', `SSH_AGENT_PID'
and `GPG_AGENT' in Emacs' `process-environment' according to
information retrieved from files created by the keychain script."
  (interactive)
  (let* ((ssh (shell-command-to-string "keychain -q --noask --agents ssh --eval"))
         (gpg (shell-command-to-string "keychain -q --noask --agents gpg --eval")))
    (list (and ssh
               (string-match "SSH_AUTH_SOCK[=\s]\\([^\s;\n]*\\)" ssh)
               (setenv       "SSH_AUTH_SOCK" (match-string 1 ssh)))
          (and ssh
               (string-match "SSH_AGENT_PID[=\s]\\([0-9]*\\)?" ssh)
               (setenv       "SSH_AGENT_PID" (match-string 1 ssh)))
          (and gpg
               (string-match "GPG_AGENT_INFO[=\s]\\([^\s;\n]*\\)" gpg)
               (setenv       "GPG_AGENT_INFO" (match-string 1 gpg))))))

(lsp/keychain-refresh-environment)

(defun lsp/switch-ssh-id ()
  (interactive)
  (let* ((current-id (doom-file-read active-ssh-id-file))
         (new-id (if (string= current-id "personal\n") "work" "personal"))
         (clear-identity-command "ssh-add -D && "))
    (shell-command (concat clear-identity-command
                           (if (string= new-id "personal")
                               "ssh-add ~/.ssh/id_personal"
                             "ssh-add ~/.ssh/id_work")))
    (doom-file-write active-ssh-id-file new-id)))

(map! :leader "t i" #'lsp/switch-ssh-id)

(when (file-exists-p "~/src/tools/Emacs")
  (setq ableton-live-repo-dir "~/src/live")
  (setq chariot-build-env "~/Library/Application\\ Support/chariot/shell_env/.debug")

  (setq chariot-gui-env "/Applications/chariot.app/Contents/Resources/gui_env_installed")
  (setq ableton-live-source-build-env-cmd (if (file-exists-p chariot-build-env)
                                              (concat "source " chariot-build-env)
                                            nil))

  (setq ableton-live-gui-env-dir (if (file-exists-p chariot-gui-env)
                                     chariot-gui-env
                                   "/Users/lspangler/src/chariot/gui_env_installed"))

  (use-package ableton :load-path "~/src/tools/Emacs")

  (map! :map ableton-acceptance-tests-mode-map
        :localleader
        "r" 'ableton-run-acceptance-test-at-point
        "b" 'ableton-run-acceptance-tests-for-file
        "d" 'ableton-run-acceptance-tests-for-directory))

(defun lsp/write-file-if-not-exists (file-path content)
  "Write CONTENT to FILE-PATH, but only if the file does not already exist."
  (unless (file-exists-p file-path)
    (with-temp-file file-path
      (insert content))
    (message "File '%s' created successfully." file-path)))

(defun lsp/comment-loc ()
  (interactive)
  (if (and (boundp 'lispy-mode) lispy-mode)
      (lispy-comment)
    (evilnc-comment-or-uncomment-lines 1)))

(defun lsp/really-maximize-buffer ()
  (interactive)
  (call-interactively 'doom/window-maximize-buffer)
  (call-interactively 'doom/window-maximize-horizontally))

;; treesitter
(setq treesit-language-source-alist
      '((cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
        (c . ("https://github.com/tree-sitter/tree-sitter-c"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))))

(setq lsp/is-function-definition
      (lambda (node)
        (string= (treesit-node-type node) "function_definition")))

(setq lsp/is-class-or-struct-specifier
      (lambda (node)
        (or
         (string= (treesit-node-type node) "class_specifier")
         (string= (treesit-node-type node) "struct_specifier"))))

(defun lsp/get-cpp-template-node (class-node)
  "Return parent template treesit node.

Return nil if is not in a template."
  (treesit-parent-until class-node
                        (lambda (NODE)
                          (string-equal (treesit-node-type NODE)
                                        "template_declaration"))))

(defun lsp/get-class-function-node-at-point ()
  "Return a treesit node of the current class function."
  (treesit-parent-until (treesit-node-at (point))
                        (lambda (NODE)
                          (string-equal (treesit-node-type NODE)
                                        "field_declaration"))
                        t))

(defun lsp/get-cpp-class-node-at-point ()
  "Return the current class treesit node."
  (treesit-parent-until (treesit-node-at (point))
                        lsp/is-class-or-struct-specifier
                        t))

(defun lsp/cpp-class-function-definition-for-declaration-at-point ()
  "Return the class function definition at point."
  (string-replace
   ";"
   "\n{\n}"
   (let* ((class-node (lsp/get-cpp-class-node-at-point))
          (func-node  (lsp/get-class-function-node-at-point))
          (template-node (lsp/get-cpp-template-node class-node))
          (class-text (treesit-node-text
                       (treesit-node-child-by-field-name
                        class-node
                        "name")
                       t))
          (func-text (treesit-node-text
                      func-node
                      t))
          (first-space-pos (string-match " "
                                         func-text))
          (insert-pos (string-match "[a-z]"
                                    func-text
                                    first-space-pos))         )
     (if template-node
         (let* ((template-parameter (treesit-node-text
                                     (treesit-node-child-by-field-name
                                      template-node
                                      "parameters")
                                     t))
                (template-head (concat "template "
                                       template-parameter
                                       "\n")))
           (concat template-head
                   (substring func-text 0 insert-pos)
                   class-text
                   (string-replace "typename " "" template-parameter)
                   "::"
                   (substring func-text insert-pos)))

       (concat (substring func-text 0 insert-pos)
               class-text
               "::"
               (substring func-text insert-pos))))))

(defun lsp/cpp-goto-previous-declaration ()
  (interactive)
  (let* ((func-node (lsp/get-class-function-node-at-point))
         (previous-func-node (treesit-search-forward
                              func-node
                              (lambda (node)
                                (message (treesit-node-type node))
                                (string= (treesit-node-type node)
                                         "function_declarator"))
                              'backward)))
    (if previous-func-node
        (progn
          (goto-char (treesit-node-start (treesit-parent-until
                                          previous-func-node
                                          (lambda (node)
                                            (string=
                                             (treesit-node-type node)
                                             "field_declaration")))))
          t)
      nil)))

(defun lsp/cpp-goto-definition-of-declaration-at-point ()
  (interactive)
  (let* ((class-node (lsp/get-cpp-class-node-at-point))
         (func-node (lsp/get-class-function-node-at-point))
         (func-name (treesit-node-text
                     (treesit-search-subtree
                      func-node
                      (lambda (node)
                        (string= (treesit-node-type node) "field_identifier")))
                     t))
         (class-text (treesit-node-text (treesit-node-child-by-field-name
                                         class-node
                                         "name")
                                        t)))
    (projectile-find-other-file)
    (let* ((root-node (treesit-parser-root-node (treesit-parser-create 'cpp (current-buffer))))
           (definition-identifier-node
            (treesit-search-subtree
             root-node
             (lambda (node)
               (string=
                (concat class-text "::" func-name)
                (treesit-node-text node t)))))
           (definition-node (if definition-identifier-node
                                (treesit-parent-until
                                 definition-identifier-node
                                 lsp/is-function-definition)
                              nil)))
      (if definition-node
          (progn
            (goto-char (treesit-node-start definition-node))
            't)
        (projectile-find-other-file)
        nil))))

(defun lsp/cpp-generate-implementation-for-declaration-at-point ()
  (interactive)
  (let ((implementation-text (lsp/cpp-class-function-definition-for-declaration-at-point)))
    (if (lsp/cpp-goto-previous-declaration)
        (progn
          (lsp/cpp-goto-definition-of-declaration-at-point)
          (let ((previous-definition-node
                 (treesit-parent-until
                  (treesit-node-at (point))
                  lsp/is-function-definition)))
            (goto-char (treesit-node-end previous-definition-node))))
      (projectile-find-other-file)
      (end-of-buffer))
    (insert (concat "\n\n\n" implementation-text))
    (previous-line)))

(defun lsp/cpp-goto-declaration-of-definition-at-point ()
  (interactive)
  (let* ((definition-node (treesit-parent-until
                           (treesit-node-at (point))
                           lsp/is-function-definition) ))

    (if (and definition-node
             (save-excursion
               (beginning-of-line)
               (= (point) (treesit-node-start definition-node))))
        (progn
          ;; Jump to function name
          (goto-char
           (treesit-node-start
            (treesit-search-subtree
             definition-node
             (lambda (node) (string= (treesit-node-type node) "identifier")))))
          (lsp-find-declaration)
          t)
      nil)))

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;; (add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))

(setq c++-mode-hook '())
(add-hook 'c++-mode-hook
          (lambda ()
            (treesit-parser-create 'cpp (current-buffer))
            (clang-format+-mode 't)
            (setq +lookup-implementations-functions
                  (list #'lsp/cpp-goto-definition-of-declaration-at-point 't))
            (setq +lookup-definition-functions
                  (list #'lsp/cpp-goto-declaration-of-definition-at-point 't))))

(setq clang-format-style "file:/Users/lspangler/Documents/live/.clang-format")
(setq clang-format-style nil)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-ts-mode))

(use-package! gptel
  :custom
  (gptel-model 'claude-3-5-sonnet-20241022)
  :config
  (defun read-file-contents (file-path)
    "Read the contents of FILE-PATH and return it as a string."
    (with-temp-buffer
      (insert-file-contents file-path)
      (buffer-string)))
  (defun gptel-api-key ()
    (read-file-contents "~/.keys/anthropic"))
  (setq
   gptel-backend (gptel-make-anthropic "Claude"
                   :stream t
                   :key #'gptel-api-key)))

(use-package! elysium
  :custom
  ;; Below are the default values
  (elysium-window-size 0.33) ; The elysium buffer will be 1/3 your screen
  (elysium-window-style 'vertical)) ; Can be customized to horizontal

(add-load-path! (file-name-directory load-file-name))

(require 'keyboard-monitor)

;; Watch for changes in keyboard setup to adjust bindings for macOS
(setup-keyboard-watcher)
(run-with-timer 2 nil #'start-keyboard-socket-server)
(toggle-keyboard-mappings)

(use-package! cider
  :config
  ;; For lispy-clojure
  (cider-add-to-alist 'cider-jack-in-dependencies
                      "org.clojure/tools.namespace"
                      "1.5.0")
  (add-hook 'cider-connected-hook
            (lambda ()
              (message "Loading lispy middleware...")
              (lispy--clojure-middleware-load))))

(defun l30-dev-restart ()
  (interactive)
  (cider-interactive-eval
   "(require 'l30.tools.repl)
 (l30.tools.repl/stop!)
 (require 'clj-reload.core)
 (clj-reload.core/reload)
(l30.tools.repl/start!)"))

(use-package! hydra
  :config
  (defhydra smerge-hydra ()
    "
^Navigate^                ^Actions
^^^^^^^^--------------------------------------
_n_: next conflict        _u_: keep upper
_p_: prev conflit         _l_: keep lower
^^                        _a_: keep all
^^"


    ("n" smerge-next)
    ("p" smerge-prev)
    ("u" smerge-keep-upper)
    ("l" smerge-keep-lower)
    ("a" smerge-keep-all))


  (map! :leader "g m" #'smerge-hydra/body))
