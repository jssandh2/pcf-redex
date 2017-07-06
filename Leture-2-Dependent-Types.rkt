#lang racket
;; Lecture - 2 (Dependent Types and Linear Logic)

;; A = I | A ⊗ B | A --◇ B | !A    --◇ = lolli (Linear Logic)
;; [[1]] = !1
;; [[X × Y]] = ![[X]] × ![[Y]]
;;[[X → Y]] = !(![[X]] --◇ [[Y]])

;; return : A → T(A)
;; join : T(T(A)) → T(A)

;; ex : !A --◇ A
;; dup : !A --◇ !!A

;; L3 Language
;; -----------
;; X ::= .... | Ptr(x)
;; A ::= ... | Cap(x,X) | (T(A)

;; (new)  T(∃x. F(Ptr(x)) ⊗ Cap(x,1))
;;       
;; (free) F(Ptr(x)) ⊗ Cap(x,X) --◇ T(I)
;;
;; (read) F(Ptr(x)) ⊗ Cap(x,X) --◇ T(F(X) ⊗ Cap(x,X))
;;
;; (write) F(Ptr(x)) ⊗ Cap(x,X) ⊗ F(Y) --◇ T(Cap(x,Y))

;; Equational Theory
;; -----------------

;; if Γ ⊢ e : 1 and Γ ⊢ e' : 1 , then , Γ ⊢ e ≡ e' : 1

;; β-rules
;; -------
;; Π_1 (e1, e2) = e1 (β_1)
;; Π_2 (e1, e2) = e2 (β_2)
;; e = (Π_1 (e), Π_2 (e))

;; η-rule
;; ------
;;(λx : τ. e) e' = e[x := e']


;; v ::= () | (v,v') | λx.e | G(t) | l
;; u ::= () | (u,u') | λa.t | F(v) | * | val(t) | let val(x) = t in t'
;;     | let (x,a) = new() in t | free(e,t) in t' | let (x,a) = read(e,t) in t'
;;     | let a = e =_{t} e' in t'