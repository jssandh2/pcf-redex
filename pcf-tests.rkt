#lang racket
(require redex)
(require "pcf.rkt")

;; Tests (Judgment Holds -> Tests for checking Type Semantics respect the Grammar and Typing
(judgment-holds (⊢ () (λ (x N) x) : (N → N)))
(judgment-holds (⊢ (ext (ext () (x_0 : N)) (x_1 : N)) (λ (x_0 N) (λ (x_1 N) x_1)) : (N → (N → N))))
(judgment-holds (⊢ (ext () (x_0 : (N → N))) (λ (x_1 B) (λ (x_2 ((N → N) → N)) (x_2 x_0))) : (B → (((N → N) → N) → N)))) 
