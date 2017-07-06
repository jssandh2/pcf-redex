#lang racket
(require redex)
(require redex/tut-subst)

(define-language TBA
  (t ::= v
     true
     false
     (if t t t)
     (succ t)
     (pred t)
     (zero? t))
  (T ::= Nat Bool)
  (p ::= t)
  (b ::= true false)
  (v ::= b n)
  (n ::= number)
  (err ::= mismatch underflow)
  (c ::= p err)
  (o ::= p err)

;; Evaluation Context
  (E ::= hole (if E p p) (succ E) (pred E) (zero? E)))

;; Define the metafunction to lift Substitution into Redex
(define x? (redex-match TBA x)) ;; Verifies that the given 'x' belongs to the Grammar of PCF

(define-metafunction TBA
  subst : x v e -> e
  [(subst x v e)
   ,(subst/proc x? (list (term x)) (list (term v)) (term e))])

;; Type-Construction Rules
(define-judgment-form TBA
  #:mode (⊢ I I O)
  #:contract (⊢ e : T)

  ;;(intro-number)
  [------------
   (⊢ n : Nat)]

  ;;(succ-number)
  [(⊢ n : Nat)
   -------------------
   (⊢ (succ n) : Nat)]

  ;;(pred-number)
  [(⊢ n : Nat)
   -------------------
   (⊢ (pred n) : Nat)]

  ;;(intro-bool)
  [-----------
   (⊢ b : Bool)]

  ;;(if-then-else)
  [(⊢ t : Bool)
   (⊢ t_1 : T)
   (⊢ t_2 : T)
   -----------------------
   (⊢ (if t t_1 t_2) : T)]

  ;;(zero?)
  [(⊢ n : Nat)
   -----------
   (⊢ (zero? n) : Bool)])
   
   
   