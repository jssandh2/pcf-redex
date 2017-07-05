#lang racket
(require redex)
(require redex/tut-subst)

(define-language BA
  (t ::= true
     false
     (if t t t)
     (n)
     (succ n)
     (pred n)
     (zero t))
  (p ::= t)
  (b ::= true false)
  (v ::= b n)
  (n ::= number)
  (err ::= mismatch underflow)
  (o ::= v err)

  ;; Evaluation Context
  (E ::= hole (if E p p) (succ E) (pred E) (zero? E)))

;; Define the metafunction to lift Substitution into Redex
(define x? (redex-match BA x)) ;; Verifies that the given 'x' belongs to the Grammar of PCF

(define-metafunction BA
  subst : x v e -> e
  [(subst x v e)
   ,(subst/proc x? (list (term x)) (list (term v)) (term e))])

(define red
  (reduction-relation
   BA
   #:domain t
   (--> (in-hole E (if true t_1 t_2)) t_1 "ift")
   (--> (in-hole E (if false t_1 t_2)) t_2 "iff")
   (--> (in-hole E (pred 0)) underflow "underflow")
   (--> (pred n) (- (term n) 1) "predecessor")
   (--> (succ n) (+ (term n) 1) "successor")))

  

  

  
     
     