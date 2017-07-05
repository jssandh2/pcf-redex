#lang racket
(require redex)
(require redex/tut-subst)

(define-language BA
  (t ::= v
     true
     false
     (if t t t)
     (succ t)
     (pred t)
     (zero t))
  (p ::= t)
  (b ::= true false)
  (v ::= b n)
  (n ::= number)
  (err ::= mismatch underflow)
  (o ::= v err)

  ;; Evaluation Context
  (E ::= hole (if E p p) (succ E) (pred E) (zero E)))

;; Define the metafunction to lift Substitution into Redex
(define x? (redex-match BA x)) ;; Verifies that the given 'x' belongs to the Grammar of PCF

(define-metafunction BA
  subst : x v e -> e
  [(subst x v e)
   ,(subst/proc x? (list (term x)) (list (term v)) (term e))])

(define red
  (reduction-relation
   BA
   #:domain p
   (--> (in-hole E (if true p_1 p_2)) (in-hole E p_1) "ift")
   (--> (in-hole E (if false p_1 p_2)) (in-hole E p_2) "iff")
   (--> (in-hole E (pred 0)) underflow "underflow")
   (--> (in-hole E (pred n)) ,(- (term n) 1) "predecessor")
   (--> (in-hole E (succ n)) ,(+ (term n) 1) "successor")))








