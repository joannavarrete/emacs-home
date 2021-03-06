;;; varioref.el --- AUCTeX style file with support for varioref.sty

;; Copyright (C) 1999, 2013 Free Software Foundation, Inc.

;; Author: Carsten Dominik <dominik@strw.leidenuniv.nl>
;;         Mads Jensen <mje@inducks.org>
;; Maintainer: auctex-devel@gnu.org

;; This file is part of AUCTeX.

;; AUCTeX is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; AUCTeX is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with AUCTeX; see the file COPYING.  If not, write to the Free
;; Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Code:

(TeX-add-style-hook "varioref"
   (lambda ()

     (TeX-add-symbols

      ;; The macros with label arguments
      '("vref" TeX-arg-label)
      '("Vref" TeX-arg-label)
      '("vrefrange" [ "Same page text" ] TeX-arg-label TeX-arg-label)
      '("vrefrange*" [ "Same page text" ] TeX-arg-label TeX-arg-label)
      '("vref*" TeX-arg-label)
      '("Vref" TeX-arg-label)
      '("Ref" TeX-arg-label)
      '("vpageref" [ "Same page text" ] [ "Different page text" ] TeX-arg-label)
      '("vpageref*" [ "Same page text" ] [ "Different page text" ]
        TeX-arg-label)
      '("fullref" TeX-arg-label)
      '("labelformat" TeX-arg-counter t)

      '("vpagerefrange" [ "Same page text" ] TeX-arg-label TeX-arg-label)
      '("vpagerefrange*" [ "Same page text" ] TeX-arg-label TeX-arg-label)

      ;; And the other macros used for customization
      "reftextbefore" "reftextfacebefore"
      "reftextafter"  "reftextfaceafter" "reftexlabelrange"
      "reftextfaraway" "vreftextvario" "vrefwarning"
      "vpagerefnum" "vrefshowerrors")

     ;; Install completion for labels.  Only offer completion for
     ;; commands that take only one reference as an argument
     (setq TeX-complete-list
	   (append
	    '(("\\\\[Vv]ref{\\([^{}\n\r\\%,]*\\)" 1 LaTeX-label-list "}")
              ("\\\\vref\\*?{\\([^{}\n\r\\%,]*\\)" 1 LaTeX-label-list "}")
              ("\\\\Ref{\\([^{}\n\r\\%,]*\\)" 1 LaTeX-label-list "}")
              ("\\\\vref\\*{\\([^{}\n\r\\%,]*\\)" 1 LaTeX-label-list "}")
              ("\\\\fullref{\\([^{}\n\r\\%,]*\\)" 1 LaTeX-label-list "}")
              ("\\\\vpageref\\*?\\(\\[[^]]*\\]\\)*{\\([^{}\n\r\\%,]*\\)"
	       2 LaTeX-label-list "}"))
	    TeX-complete-list))))

(defvar LaTeX-varioref-package-options
  '("draft" "final" "afrikaans" "american" "austrian" "naustrian" "basque"
    "brazil" "breton" "bahasam" "catalan" "croatian" "czech" "danish"
    "dutch" "english" "esperanto" "finnish" "french" "galician" "german"
    "icelandic" "ngerman" "greek" "italian" "magyar" "norsk" "nynorsk"
    "polish" "portuges" "romanian" "russian" "slovak" "slovene"
    "spanish" "swedish" "turkish" "ukrainian" "francais" "germanb")
  "Package options for the varioref package.")

;;; varioref.el ends here
