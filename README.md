# PCF-redex
* An implementation of the Formal Semantics of the PCF Language, including Type-Inference Rules and Reduction Semantics.
* The _majority_ of this code is inspired from [OPLSS-2017](https://www.cs.uoregon.edu/research/summerschool/summer17/) by [Prof. David Van-Horn](https://www.cs.umd.edu/~dvanhorn/)'s lecture on [Operational Semantics and Redex]().
* I am working to extend the Semantics (Static *and* Dynamic) to add [Higher-Order Contract Semantics](https://www.eecs.northwestern.edu/~robby/pubs/papers/ho-contracts-techreport.pdf) and various other operators (both `(Op)` and `a (Op) b`)

# Installation
* `git clone git@github.com:jssandh2/pcf-redex.git`
* Install [DrRacket](https://racket-lang.org/)
* **Run** the file in `DrRacket`'s REPL by clicking the `Run` button (afer Opening it).
* For instructions on how to play with the language, refer here : [Redex Tutorial](https://docs.racket-lang.org/redex/tutorial.html)

# Semantics 
* The semantics correspond to that of [PCF]()
* _**TODO**_ :: Addition of Semantics and Reductions for :
    * `(Op)` and `a (Op) b`
    * `is-zero` and `plus` operators
    * Contract Semantics

# Running PCF-redex
* _**TODO**_ :: Implementation of the helper functions `ext` _and_ `lookup`
* Coming Soon!
