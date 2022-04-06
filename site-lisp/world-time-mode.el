;;; world-time-mode.el --- show whole days of world-time diffs

;; Copyright (C) 2013  Nic Ferrier

;; Author: Nic Ferrier <nferrier@ferrier.me.uk>
;; Keywords: tools, calendar
;; Version: 0.0.6

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Very useful productivity tool if you work in different time zones.

;;; Code:

(require 'cl)
(require 'time)

(defun world-time/zone-list (this-time)
  "Return the vector of zoned times for TIME."
  (apply 'vector
         (mapcar
          (lambda (zone)
            (let ((original (getenv "TZ")))
              (unwind-protect
                   (progn
                     (setenv "TZ" (car zone))
                     (list (format-time-string "%R %Z" this-time)))
                (setenv "TZ" original))))
          display-time-world-list)))


(defun world-time/table-entrys ()
  "Make the entry table for the list.

Based on the next hour after the current time."
  (let* ((currently (current-time))
         (time-now (time-to-seconds currently))
         (hours-since-epoch (/ time-now 3600))
         (last-hour (* 3600.00 (floor hours-since-epoch)))
         (next-hour (+ 3600.00 last-hour))
         (ref-time (seconds-to-time next-hour))
         (ref-list
          (mapcar
           (lambda (i)
             (list nil
                   (world-time/zone-list 
                    (time-add ref-time (seconds-to-time (* 3600.00 i))))))
           (number-sequence 0 23))))
    (append (list (list nil (world-time/zone-list currently))) ref-list)))

(define-derived-mode
    world-time-table-mode tabulated-list-mode "World Time"
    "Major mode for seeing your world time list as a day."
    (setq tabulated-list-entries 'world-time/table-entrys)
    ;; This is wrong! it needs to be derived from display-time-world-list
    (setq tabulated-list-format
          (loop for time in display-time-world-list
             vconcat (list (list (car time) 20 nil))))
    (tabulated-list-init-header))

;;;###autoload
(defun world-time-list ()
  "Show `display-time-world-list' full day comparison."
  (interactive)
  (with-current-buffer (get-buffer-create "*world-time*")
    (world-time-table-mode)
    (tabulated-list-print)
    (switch-to-buffer (current-buffer))))

;;;###autoload
(defun list-world-time ()
  "Show `display-time-world-list' full day comparison."
  (interactive)
  (call-interactively 'world-time-list))

(provide 'world-time-mode)

;;; world-time-mode.el ends here
