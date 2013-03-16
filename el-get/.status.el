((ac-slime status "installed" recipe
           (:name ac-slime :website "https://github.com/purcell/ac-slime" :description "Emacs auto-complete plugin for Slime symbols" :type github :pkgname "purcell/ac-slime"))
 (auctex status "installed" recipe
         (:name auctex :website "http://www.gnu.org/software/auctex/" :description "AUCTeX is an extensible package for writing and formatting TeX files in GNU Emacs and XEmacs. It supports many different TeX macro packages, including AMS-TeX, LaTeX, Texinfo, ConTeXt, and docTeX (dtx files)." :type cvs :module "auctex" :url ":pserver:anonymous@cvs.sv.gnu.org:/sources/auctex" :build
                `(("./autogen.sh")
                  ("./configure" "--without-texmf-dir" "--with-lispdir=`pwd`" ,(concat "--with-emacs=" el-get-emacs))
                  "make")
                :load-path
                ("." "preview")
                :load
                ("tex-site.el" "preview/preview-latex.el")
                :info "doc"))
 (auto-complete status "installed" recipe
                (:name auto-complete :website "http://cx4a.org/software/auto-complete/" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
                       (popup fuzzy)))
 (auto-complete-latex status "installed" recipe
                      (:name auto-complete-latex :description "A LaTeX extention for auto-complete-mode" :website "https://bitbucket.org/tequilasunset/auto-complete-latex" :url "https://bitbucket.org/tequilasunset/auto-complete-latex" :type hg :depends auto-complete))
 (buffer-move status "installed" recipe
              (:name buffer-move :description "Swap buffers without typing C-x b on each window" :type emacswiki :features buffer-move))
 (clojure-mode status "installed" recipe
               (:name clojure-mode :website "https://github.com/technomancy/clojure-mode" :description "Emacs support for the Clojure language." :type github :pkgname "technomancy/clojure-mode"))
 (color-theme status "installed" recipe
              (:name color-theme :description "An Emacs-Lisp package with more than 50 color themes for your use. For questions about color-theme" :website "http://www.nongnu.org/color-theme/" :type http-tar :options
                     ("xzf")
                     :url "http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz" :load "color-theme.el" :features "color-theme" :post-init
                     (progn
                       (color-theme-initialize)
                       (setq color-theme-is-global t))))
 (color-theme-solarized status "installed" recipe
                        (:name color-theme-solarized :description "Emacs highlighting using Ethan Schoonover's Solarized color scheme" :type github :pkgname "sellout/emacs-color-theme-solarized" :depends color-theme :prepare
                               (progn
                                 (add-to-list 'custom-theme-load-path default-directory)
                                 (autoload 'color-theme-solarized-light "color-theme-solarized" "color-theme: solarized-light" t)
                                 (autoload 'color-theme-solarized-dark "color-theme-solarized" "color-theme: solarized-dark" t))))
 (ctable status "installed" recipe
         (:name ctable :description "Table Component for elisp" :type github :pkgname "kiwanami/emacs-ctable"))
 (deferred status "installed" recipe
   (:name deferred :description "Simple asynchronous functions for emacs lisp" :website "https://github.com/kiwanami/emacs-deferred" :type github :pkgname "kiwanami/emacs-deferred" :features "deferred"))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :info "." :load "el-get.el"))
 (epc status "installed" recipe
      (:name epc :description "An RPC stack for Emacs Lisp" :type github :pkgname "kiwanami/emacs-epc" :depends
             (deferred ctable)))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (ifind-mode status "installed" recipe
             (:name ifind-mode :auto-generated t :type emacswiki :description "A minor mode based on isearch, for interactively finding" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/ifind-mode.el"))
 (jedi status "installed" recipe
       (:name jedi :description "An awesome Python auto-completion for Emacs" :type github :pkgname "tkf/emacs-jedi" :build
              (("make" "requirements"))
              :submodule nil :depends
              (epc auto-complete)))
 (markdown-mode status "installed" recipe
                (:name markdown-mode :description "Major mode to edit Markdown files in Emacs" :type git :url "git://jblevins.org/git/markdown-mode.git" :before
                       (add-to-list 'auto-mode-alist
                                    '("\\.\\(md\\|mdown\\|markdown\\)\\'" . markdown-mode))))
 (package status "installed" recipe
          (:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin "24" :type http :url "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el" :shallow nil :features package :post-init
                 (progn
                   (setq package-user-dir
                         (expand-file-name
                          (convert-standard-filename
                           (concat
                            (file-name-as-directory default-directory)
                            "elpa")))
                         package-directory-list
                         (list
                          (file-name-as-directory package-user-dir)
                          "/usr/share/emacs/site-lisp/elpa/"))
                   (make-directory package-user-dir t)
                   (unless
                       (boundp 'package-subdirectory-regexp)
                     (defconst package-subdirectory-regexp "^\\([^.].*\\)-\\([0-9]+\\(?:[.][0-9]+\\)*\\)$" "Regular expression matching the name of\n a package subdirectory. The first subexpression is the package\n name. The second subexpression is the version string."))
                   (setq package-archives
                         '(("ELPA" . "http://tromey.com/elpa/")
                           ("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("SC" . "http://joseito.republika.pl/sunrise-commander/"))))))
 (paredit status "installed" recipe
          (:name paredit :description "Minor mode for editing parentheses" :type http :prepare
                 (progn
                   (autoload 'enable-paredit-mode "paredit")
                   (autoload 'disable-paredit-mode "paredit"))
                 :url "http://mumble.net/~campbell/emacs/paredit.el"))
 (popup status "installed" recipe
        (:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :pkgname "auto-complete/popup-el"))
 (rainbow-delimiters status "installed" recipe
                     (:name rainbow-delimiters :website "https://github.com/jlr/rainbow-delimiters#readme" :description "Color nested parentheses, brackets, and braces according to their depth." :type github :pkgname "jlr/rainbow-delimiters"))
 (rainbow-mode status "installed" recipe
               (:name rainbow-mode :description "Colorize color names in buffers" :minimum-emacs-version 24 :type elpa))
 (solarized-theme status "installed" recipe
                  (:name solarized-theme :type github :pkgname "sellout/emacs-color-theme-solarized" :description "Solarized themes for Emacs" :prepare
                         (add-to-list 'custom-theme-load-path default-directory)))
 (tiling status "installed" recipe
         (:name tiling :auto-generated t :type emacswiki :description "changing window layout" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/tiling.el")))
