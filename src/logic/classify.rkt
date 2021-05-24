#lang rosette

(provide (all-defined-out))

; Takes as input a propositional formula and returns
; * 'TAUTOLOGY if every interpretation I satisfies F;
; * 'CONTRADICTION if no interpretation I satisfies F;
; * 'CONTINGENCY if there are two interpretations I and I′ such that I satisfies F and I' does not.
(define (classify F)
  (clear-vc!)
  (match (solve (assert F))
    ; if F is unsat then no I satisfies F
    [(? unsat? f) 'CONTRADICTION]
    ; if we get a model let's decide between tautology vs contingency
    [(model found-solution)
     ; if no solution verifies otherwise we have a tautology, else a contingency
     (if (unsat? (verify (assert F))) 'TAUTOLOGY 'CONTIGENCY)]))


; define our boolean variables of interest
(define-symbolic* p q r boolean?)

; (p → (q → r)) → (¬r → (¬q → ¬p)) CONTINGENCY
(define f0 (=> (=> p (=> q r)) (=> (! r) (=> (! q) (! p)))))

; (p ∧ q) → (p → q) TAUTOLOGY
(define f1 (=> (&& p q) (=> p q)))

; (p ↔ q) ∧ (q → r) ∧ ¬(¬r → ¬p) CONTRADICTION
(define f2 (&& (<=> p q) (=> q r) (! (=> (! r) (! q)))))

; p || -p TAUTOLOGY
(define f3 (|| p (! p)))


(classify f0)
(classify f1)
(classify f2)
(classify f3)

