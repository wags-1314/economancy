#lang racket

(require json threading)
(require "utils.rkt")

(provide (all-defined-out))

;; game-day :: jsexpr? -> number?
(define (game-day state)
  (hash-ref state 'day))

;; game-phase :: jsexpr? -> jsexpr?
(define (game-phase state)
  (hash-ref state 'phase))

;; game-shop :: jsexpr? -> jsexpr?
(define (game-shop state)
  (hash-ref state 'shop))

;; game-players :: jsexpr? -> list?
(define (game-players state)
  (hash-ref state 'players))

;; game-player :: jsexpr? -> number?
(define (game-player state)
  (hash-ref state 'player))

;; phase-name :: jsexpr? -> string?
(define (phase-name state)
  (hash-ref* state 'phase 'name))

;; investing? :: jsexpr? -> bool?
(define (investing? state)
  (equal? "investing" (phase-name state)))

;; attacking? :: jsexpr? -> bool?
(define (attacking? state)
  (equal? "attacking" (phase-name state)))

(define/contract (game-attacker state)
  (-> (and/c jsexpr? attacking?) number?)
  (hash-ref* state 'phase 'attacker))

(define/contract (game-attacker-card state)
  (-> (and/c jsexpr? attacking?) number?)
  (hash-ref* state 'phase 'attacker-card))

;; buying? :: jsexpr? -> bool?
(define (buying? state)
  (equal? "buy" (phase-name state)))

;; ending? :: jsexpr? -> bool?
(define (ending? state)
  (equal? "end" (phase-name state)))

;; my-coins :: jsexpr? -> number?
(define (my-coins state)
  (~> state
      (hash-ref _ 'players)
      (list-ref _ (game-player state))
      (hash-ref _ 'coins)))

;; my-buys :: jsexpr? -> number?
(define (my-buys state)
  (~> state
      (hash-ref _ 'players)
      (list-ref _ (game-player state))
      (hash-ref _ 'buys)))

;; my-cards :: jsexpr? -> jsexpr?
(define (my-cards state)
  (~> state
      (hash-ref _'players)
      (list-ref _ (game-player state))
      (hash-ref _ 'cards)))

;; player-cards :: jsexpr? -> number? -> jsexpr?
(define (player-cards state player)
  (~> state
      (hash-ref _ 'players)
      (list-ref _ player)
      (hash-ref _ 'cards)))
