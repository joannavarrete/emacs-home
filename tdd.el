(defconst is-test-regex
  "[tT]est$"
  "regex to see if a buffer is a regex")

(defun remove-extension(file-name)
  "remove file extension"
  (substring file-name 0 (string-match "\\..?" file-name)))

(defun buffer-name-without-ext(buffer)
  "get the buffer name and remove the extension"
  (remove-extension (buffer-name buffer)))

(defun is-test(buffer)
  "true if the buffer name is a test file"
  (string-match is-test-regex (buffer-name-without-ext buffer)))

(defun substring-till-first-occurrence(regex string)
  "returns the substring till the first occurrence"
  (substring string 0 (string-match regex string) ))

(defun is-my-test(candidate-buffer source-buffer)
  "true if candidate is the testaj file of source"
  (let ((candidate (buffer-name-without-ext candidate-buffer))
        (regex (concat (buffer-name-without-ext source-buffer) ".?" is-test-regex)))
    (string-match regex candidate)))

(defun is-my-source(candidate-buffer test-buffer)
  "true if candidate is the soruce file of test"
  (let ((candidate (buffer-name-without-ext candidate-buffer)))
    (string-match candidate (substring-till-first-occurrence is-test-regex (buffer-name-without-ext test-buffer)))))

(defun my-filter (condp lst)
  "filters a sequence"
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

(defun get-my-source(buffer-lst test-buffer)
  "returns the source for the test if exists"
  (my-filter (lambda(candidate-buffer) (is-my-source candidate-buffer test-buffer)) buffer-lst))

(defun get-my-test(buffer-lst source-buffer)
  "return the test for the source if exists"
  (my-filter (lambda(candidate-buffer) (is-my-test candidate-buffer source-buffer)) buffer-lst))


(defun toggle-test()
  "toggle between test and source"
  (interactive)
  (if (is-test (current-buffer))
      (set-window-buffer (selected-window) (first(get-my-source (buffer-list) (current-buffer))))   (set-window-buffer (selected-window) (first(get-my-test (buffer-list) (current-buffer))))))

  