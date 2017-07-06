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
     (zero? t))
  (p ::= t)
  (b ::= true false)
  (v ::= b n)
  (n ::= number)
  (err ::= mismatch underflow)
  (o ::= p err)

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
   #:domain o
   (--> (in-hole E (if true p_1 p_2)) (in-hole E p_1) "ift")
   (--> (in-hole E (if false p_1 p_2)) (in-hole E p_2) "iff")
   (--> (in-hole E (if p_1 p_2 p_3)) mismatch
        (side-condition (not
                         (cond
                          [(equal? (term p) true) "mismatch"]
                          [(equal? (term p) false) "mismatch"])))
        "mismatch")
   (--> (in-hole E (pred 0)) underflow "underflow")
   (--> (in-hole E (pred n))
        ,(- (term n) 1)
        (side-condition (not (equal? (term n) 0)))
        "predecessor")
   (--> (in-hole E (succ n)) ,(+ (term n) 1) "successor")
   (--> (in-hole E (zero? n)) ,(if (equal? (term n) 0) (term true) (term false)))))

(define -->red
  (compatible-closure red BA o))