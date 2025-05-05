;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       indent-guides
       ligatures
       modeline
       ophints
       ;; (popup +defaults)
       unicode
       (vc-gutter +pretty)
       vi-tilde-fringe
       window-select

       :editor
       file-templates
       fold
       lispy
       multiple-cursors
       parinfer
       snippets

       :emacs
       (dired +dirvish)
       electric
       ibuffer
       tramp
       undo

       :term
       eshell

       :checkers
       syntax

       :tools
       (:if (featurep :system 'gnu/linux) debugger)
       direnv
       editorconfig
       (eval +overlay)
       lookup
       lsp
       magit
       make
       pdf
       prodigy
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)
       tty

       :lang
       (cc +lsp)
       ;;csharp
       data
       emacs-lisp
       ;;(go +lsp)
       ;;hy
       json
       javascript
       ;;lua
       markdown
       ;;nix
       (org +pretty +present +pandoc)
       python
       ;;racket
       ;;rest
       ;;(rust +lsp)
       ;;(scheme +guile)
       sh
       yaml
       ;;zig

       :config
       (default +bindings +smartparens))
