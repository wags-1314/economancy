#lang racket

(require json threading)

(provide hash-ref*)

(define-syntax hash-ref*
  (syntax-rules ()
    [(hash-ref* table key) (hash-ref table key)]
    [(hash-ref* table key keys ...)
     (hash-ref* (hash-ref table key) keys ...)]))
