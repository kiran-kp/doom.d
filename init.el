;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       doom-dashboard
       (emoji +unicode +github)
       hl-todo
       indent-guides
       ligatures
       modeline
       ophints
       (popup +defaults)
       treemacs
       unicode
       (vc-gutter +pretty)
       vi-tilde-fringe
       window-select

       :editor
       file-templates
       fold
       lispy
       multiple-cursors
       ;;objed
       parinfer
       snippets

       :emacs
       (dired +dirvish)
       electric
       ibuffer
       undo
       ;

       :term
       eshell
       ;;shell
       ;;term
       ;;vterm

       :checkers
       syntax

       :tools
       debugger
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
       org
       python
       ;;racket
       ;;rest
       ;;(rust +lsp)
       ;;(scheme +guile)
       sh
       yaml
       ;;zig

       :app
       ;;calendar
       ;;everywhere

       :config
       (default +bindings +smartparens))
