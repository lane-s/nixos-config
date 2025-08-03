;;; ../.init-env/.doom.d/macos-external-keyboard.el -*- lexical-binding: t; -*-

;; Handle macOS keyremapping with external keyboards
(defun external-keyboard-connected-p ()
  "Return t if an external keyboard is connected, nil otherwise."
  (let ((ioreg-output
         (shell-command-to-string "ioreg -p IOUSB -w0 | grep -i keyboard")))
    (> (length ioreg-output) 0)))

(defun toggle-keyboard-mappings ()
  "Toggle key mappings based on external keyboard presence."
  (interactive)
  (if (external-keyboard-connected-p)
      (progn
        ;; External keyboard connected - swap CMD and CTRL
        (setq mac-command-modifier 'control
              mac-control-modifier 'command))
    (progn
      ;; Internal keyboard - use default mappings
      (setq mac-command-modifier 'command
            mac-control-modifier 'control))))

(defvar keyboard-socket-name (expand-file-name "keyboard-status-socket" temporary-file-directory))
(defvar keyboard-server-process nil)

(defun keyboard-status-server (proc string)
  "Handle incoming keyboard status messages."
  (message "Keyboard connection status changed")
  (toggle-keyboard-mappings))

(defun start-keyboard-socket-server ()
  "Start the Unix domain socket server for keyboard status."
  (when (file-exists-p keyboard-socket-name)
    (delete-file keyboard-socket-name))
  (setq keyboard-server-process
        (make-network-process
         :name "keyboard-status-server"
         :server t
         :family 'local
         :service keyboard-socket-name
         :filter 'keyboard-status-server)))

(defun setup-keyboard-watcher ()
  (let ((script-content
         (concat "#!/bin/bash\n"
                 "last_status=\"\"\n"
                 "while true; do\n"
                 "  current_status=$(ioreg -p IOUSB -w0 | grep -i keyboard)\n"
                 "  if [ \"$current_status\" != \"$last_status\" ]; then\n"
                 "    echo \"change\" | nc -U " keyboard-socket-name "\n"
                 "    last_status=\"$current_status\"\n"
                 "  fi\n"
                 "  sleep 1\n"
                 "done")))
    (with-temp-file "/tmp/watch-keyboards.sh"
      (insert script-content))
    (shell-command "chmod +x /tmp/watch-keyboards.sh")
    (start-process "keyboard-watcher" nil "/tmp/watch-keyboards.sh")))

(provide 'keyboard-monitor)
