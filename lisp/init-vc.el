(require-package 'diff-hl)
(add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)

;(require-package 'diff-hl-dired)
(add-hook 'dired-mode-hook 'diff-hl-dired-mode)

(provide 'init-vc)
