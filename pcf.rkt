#lang racket
;; Redex -> DSL : Allows you to specify the (Formal) Semantics of Programming Languages
(require redex)
(require scribble/latex-properties)
(require redex/tut-subst)
(provide PCF)
(provide red)
(provide -->red ⊢)
(provide ext lookup different)

;; Definition of the PCF Language
(define-language PCF
  (e :: = v
     x
     (e e)
     (μ (x τ) e)  ;; (TODO) :: Semantics for 'operators' : (op e) (e op e)
     (if e e e))
  (v ::= b (λ (x τ) e))
  (b ::= true false n)
  (n ::= number)
  (τ ::= B N (τ → τ))
  
  (x ::= variable-not-otherwise-mentioned)
  
  ;; Context
  (Γ ::= ((x : τ) ...))
  
  ;; Evaluation Context
  (E ::= hole (E e) (v E) (if E e e))) ;; (TODO) :: (@jus, @adam) - Eval Contexts for 'operators' : (op E) (E op e) (v op E)))


;; "Meta" :: Allows you to change and add functionality to the context \Gamma

;; Extends the Context \Gamma with a new Term
(define-metafunction PCF  
  [(ext ((x_0 : τ_0) ...) (x : τ))
   ((x : τ) (x_0 : τ_0) ...)])

;; Looks up the Context to find the type \tau for a particular x \in \Gamma 
(define-metafunction PCF
  [(lookup ((x : τ) (x_0 : τ_0) ...) x) τ]
  [(lookup ((x_0 : τ_0) (x_1 : τ_1) ...) x)
   (lookup ((x_1 : τ_1) ...) x)])

;; Checks to see if two variables x_1, x_2 are different or the same in a Context
(define-metafunction PCF
  [(different x_1 x_1) #f]
  [(different x_1 x_2) #t])

;; Having defined the Context, we can derive the Typing Rules
(define-judgment-form PCF
  #:mode (⊢ I I I O)
  #:contract (⊢ Γ e : τ)

  ;; (intro-number)
  [----------------
   (⊢ Γ n : N)]

  ;; (intro-true)
  [---------------
   (⊢ Γ true : B)]

  ;; (intro-false)
  [----------------
   (⊢ Γ false : B)]

  ;; (intro-var)
  [(where τ (lookup Γ x))
   --------------------
   (⊢ Γ x : τ)]

  ;; (abst)
  [(⊢ (ext Γ (x : τ)) e : τ_0)
   ------------------------------
   (⊢ Γ (λ (x τ) e) : (τ → τ_0))] 

  ;; (appl)
  [(⊢ Γ e_0 : (τ_0 → τ_1))
   (⊢ Γ e_1 : τ_0)
   ----------------------
   (⊢ Γ (e_0 e_1) : τ_1)]

  ;; (if-then-else)
  [(⊢ Γ e_0 : τ)
   (⊢ Γ e_1 : τ)
   (⊢ Γ e_2 : τ)
   ---------------------------
   (⊢ Γ (if e_0 e_1 e_2) : τ)]

  ;; (rec)
  [(⊢ ((x : τ) Γ) e : τ)
   -----------------------
   (⊢ Γ (μ (x τ) e) : τ)])



;; Define the metafunction to lift Substitution into Redex
(define x? (redex-match PCF x)) ;; Verifies that the given 'x' belongs to the Grammar of PCF

(define-metafunction PCF
  subst : x v e -> e
  [(subst x v e)
   ,(subst/proc x? (list (term x)) (list (term v)) (term e))])

(define red
  (reduction-relation
   PCF
   #:domain e ;; Hints as to which sub-term to begin reducing
   (--> (if true e_1 e_2) e_1 "ift")
   (--> (if false e_1 e_2) e_2 "iff")
   (--> ((λ (x τ) e) v) (subst x v e) "βv")
   (--> ((μ (x τ) e)) (subst x (μ (x τ) e) e) "μv"))) ;; (TODO) :: (@jus,@adam) - Add the Reduction Rules for (Op)

(define -->red
  (compatible-closure red PCF e)) ;; e --> Pattern that's allowed for Reduction