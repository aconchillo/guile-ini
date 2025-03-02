(define-module (ini)
  #:use-module (ice-9 receive)
  #:use-module (ice-9 pretty-print)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-1)
  #:use-module (oop goops)
  #:use-module (smc fsm)
  #:use-module (ini fsm)
  #:use-module (ini fsm-context)
  #:export (ini->scm
            scm->ini))

(define* (ini->scm port #:key (debug-mode? #f))
  (let ((fsm (make <ini-fsm>)))
    (fsm-debug-mode-set! fsm debug-mode?)
    (let loop ((context (make <ini-context>
                          #:module (list (resolve-module '(smc guards char))
                                         (resolve-module '(smc puml))
                                         (resolve-module '(smc fsm))))))
      (receive (new-state new-context)
          (fsm-run! fsm (get-char port) context)
        (if new-state
            (loop new-context)
            (begin
              (when debug-mode?
                (pretty-print (fsm-statistics fsm) (current-error-port)))
              (ini-context-result new-context)))))))



(define (%write-section section port)
  (let ((title (car section))
        (props (cdr section)))
    (when title
      (format port "[~a]~%" title))
    (for-each (lambda (prop)
                (format port "~a=~a~%" (car prop) (cdr prop)))
              props))
  (newline port))

(define (scm->ini data port)
  "Write DATA to a PORT in the INI format. "
  (let* ((global (find (lambda (section)
                         (not (car section)))
                       data))
         (data   (if global
                     (delete global data equal?)
                     data)))

    (when global
      (%write-section global port))

    (for-each (lambda (section)
                (%write-section section port))
              data)))
