(defpackage 412fe
  (:use cl)
  (:import-from :parser :parse-file)
  (:import-from :412fe.cli
                :output-help
                :parse-args)
  (:import-from :renamer
                :rename-registers)
  (:import-from :global
                :compile-start)
  (:import-from :scheduler
                :schedule)
  (:import-from :ir
                :output-parallel-ir)
  (:export :entry))

(in-package :412fe)

(defun main (argl)
  (compile-start)
  (destructuring-bind (f . s) (parse-args argl)
    (case f
      ;;(:|-g| (output-ir (rename-registers (parse-file s))
      ;;                  #'ir::virtual))
      (:|-h| (output-help))
      (t (let* ((ir (parse-file s)))
           (rename-registers ir)
           (output-parallel-ir (schedule ir)
                               #'ir::virtual))))))

(defun entry ()
  (main sb-ext:*posix-argv*))
