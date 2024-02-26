#lang racket

(require racket/set json threading racket/pretty)
(require "state.rkt")

(define (main-loop)
  (define state (read-json))
  (cond
    [(investing? state)
     (game-output 0)
     (main-loop)]
    [(attacking? state)
     (attacker state)
     (main-loop)]
    [(buying? state)
     (buyer state)
     (main-loop)]
    [else #f]))

(define (game-output thing)
  (printf "~a\n" (jsexpr->string (list thing)))
  (flush-output))

(define (attacker state)
  (define my-deck (my-cards state))
  (define unused-cards
    (for/list ([card (in-list my-deck)]
               [idx (in-naturals)]
               #:when (and (>= idx 1) (zero? (hash-ref card 'uses))))
      idx))
  (~> unused-cards
      shuffle
      first
      game-output))

(define (buyer state)
  (define coins (my-coins state))
  (cond
    [(= coins 1) (buy-random state 'Worker '|Magic Bean Stock|)]
    [(= coins 2) (buy-random state '|Senior Worker| 'Monopoly 'Bubble 'Ghost)]
    [(= coins 3) (buy-random state '|Gold Fish|)]
    [(>= coins 4) (buy-random state 'Incantation)]))

(define (buy-random state . cards)
  (define shop (game-shop state))
  (define available-cards
    (for/list ([(card uses) (in-hash shop)]
               #:when (not (zero? uses)))
      card))
  (define cards-to-buy (set-intersect cards available-cards))
  (if (zero? (length cards-to-buy))
    (game-output "Pass")
    (~> cards-to-buy
        shuffle
        first
        symbol->string
        game-output)))

(main-loop)
