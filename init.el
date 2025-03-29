;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless)     ; complete with cap(f), cape and a flying feather!
       vertico                          ; the search engine of the future

       :ui
       doom                             ; what makes DOOM look the way it does
       doom-dashboard                   ; a nifty splash screen for Emacs
       (emoji +unicode +github)  ; 🙂
       hl-todo                ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides     ; highlighted indent columns
       ligatures         ; ligatures and symbols to make your code pretty again
       modeline   ; snazzy, Atom-inspired modeline, plus API
       ophints                    ; highlight the region an operation acts on
       (popup +defaults)          ; tame sudden yet inevitable temporary windows
       treemacs                      ; a project drawer, like neotree but cooler
       unicode           ; extended unicode support for various languages
       (vc-gutter +pretty)         ; vcs diff in the fringe
       vi-tilde-fringe             ; fringe tildes to mark beyond EOB
       window-select     ; visually switch windows

       :editor
       file-templates                   ; auto-snippets for empty files
       fold                             ; (nigh) universal code folding
       lispy                       ; vim for lisp, for people who don't like vim
       multiple-cursors            ; editing in many places at once
       ;;objed             ; text object editing for the innocent
       parinfer          ; turn lisp into python, sort of
       snippets   ; my elves. They type so I don't have to

       :emacs
       (dired +dirvish)  ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       ibuffer           ; interactive buffer management
       undo              ; persistent, smarter undo for your inevitable mistakes
       ;; vc                ; version-control and Emacs, sitting in a tree

       :term
       eshell         ; the elisp shell that works everywhere
       ;;shell             ; simple shell REPL for Emacs
       ;;term              ; basic terminal emulator for Emacs
       ;;vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax        ; tasing you for every semicolon you forget

       :tools
       debugger              ; FIXME stepping through code, to help you add bugs
       direnv
       editorconfig      ; let someone else argue about tabs vs spaces
       (eval +overlay)          ; run code, run (also, repls)
       lookup                   ; navigate your code and its documentation
       lsp               ; M-x vscode
       magit                    ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       pdf               ; pdf enhancements
       prodigy           ; FIXME managing external services & code builders
       tree-sitter       ; syntax and parsing, sitting in a tree...

       :os
       (:if (featurep :system 'macos) macos) ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       (cc +lsp)                        ; C > C++ == 1
       ;;csharp            ; unity, .NET, and mono shenanigans
       data              ; config/data formats
       emacs-lisp                       ; drown in parentheses
       ;;(go +lsp)         ; the hipster dialect
       ;;hy                ; readability of scheme w/ speed of python
       json              ; At least it ain't XML
       javascript        ; all(hope(abandon(ye(who(enter(here))))))
       ;;lua               ; one-based indices? one-based indices
       markdown  ; writing docs for people to ignore
       ;;nix               ; I hereby declare "nix geht mehr!"
       org       ; organize your plain life in plain text
       python            ; beautiful is better than ugly
       ;;racket            ; a DSL for DSLs
       ;;rest              ; Emacs as a REST client
       ;;(rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;(scheme +guile)   ; a fully conniving family of lisps
       sh     ; she sells {ba,z,fi}sh shells on the C xor
       yaml              ; JSON, but readable
       ;;zig               ; C, but simpler

       :app
       ;;calendar
       ;;everywhere        ; *leave* Emacs!? You must be joking
       ;;irc               ; how neckbeards socialize

       :config
       (default +bindings +smartparens))
