(**

* Thinking About Induction over Natural Numbers

*)

(**

** The Problem

Proof assistants offer two promises to their users. First, they offer
proofs as in their most important feature is recognising arguments
that demonstrate a theorem. A give proof assistant can only recognise
carefully constructed and very precise arguments. Constructing proofs
in sufficient detail is the main challenge when using a proof
assistant. Second, they promise some assistance, this is assistance is
needed because otherwise their use would be unfeasible and require
heroic levels of effort even for the simplest statement. The help
offered by contemporary proof assistants requires some ingenuity (from
the part of the user) to be able to accomplish interesting results.

In this document we attempt a familiar proof. I say familiar, because
we attempt a proof about natural numbers, using induction of a common
introductory proof done in a class where one learns these things.

Concretely, the problem is:

1- Define a function 'sum' that adds the first n natural numbers
2- Prove that: 'sum n = n * (n + 1) / 2' for all n.

*)

(* begin hide *)

(**

We import some definitions and facts about arithmetic that we will
need. These facts will provide most of the 'assistance' for proofs.

*)
Require Import Arith.

(* end hide *)

(**

** The Solution

*** Defining the function

First we define the function 'sum(n)' that computes the sum of first
'n' natural numbers up to 'n' itself.

*)
Fixpoint sum (n : nat) : nat :=
n
.

(** This is a recursive function so we defining using the 'Fixpoint'
keyword and we tell Coq that it takes a natural number 'n' and that it
also returns a natural number.

The implementation is very simple as it checks the parameter which if
it is 0 then we are done and just return 0. Otherwise, it returns that
number plus the sum of the numbers up-to its predecessor.

All this is nice and simple, but is it correct? Correct is a very big
word in the context of formal proofs. But before tackling interesting
facts about this functions let's check if it behaves as we expect.

We expect sum(4) = 4+3+2+1 = 10. So let's state that as a simple
anonymous lemma:

*)

Goal sum(4) = 10.

(** To prove this lemma, we simplify the left side, and then compare
with the expected result. *)
Proof.
 (* ? *)
Admitted.

(** This worked! Well, it's a good first step, if this had been wrong
we would have needed to revisit our definition of the function. But a
test is always welcome before embarking in proofs. *)


(** Let's see how this proof goes, first let's state the theorem, that
is straightforward enough. *)
Goal forall n, sum n = n * (n + 1) /2.
(** for the proof we proceed by induction as expected.  *)
Proof.
  induction n. (* we perform induction on the parameter *)
  - simpl.
    admit.
  - simpl. (* for the recursive case we simplify to make progress with
              the recursive call *)
    (* rewrite -> IHn. *) (* that enables us to use the inductive hypothesis *)
    (* Oh, and we get so much arithmetic! *)
Abort.

(** We did not get stuck on the proof, the equality should be
provable. But it would also be more effort than if we stop and think
 for a bit.

If we were to continue the previous proof, we would need to reason
about division, and particularly hairy details of division of natural
numbers. But we do not really need division, we only divide by a
constant, and with a modicum of algebra we can move that divisor as a
factor to the other side of the equation.

Let's try that approach next:

*)

Lemma double_what_we_want: forall n,
    2 * sum n = n * (n + 1).
Proof.
  (* ? *)
Abort.

(** If we recap, everything was going well until got to the inductive
case, there we need to work on the goal to be able to use the
induction hypothesis.

We have to pay attention to two things:

- the recursive call appears as '2 * sum (S n)' on the goal

- it should be possible to reduce using this branch of the pattern
  match: '| S n => (S n) + sum n'

So after a bit of consideration it should be clear why we choose the
following helper lemma:
*)

Lemma simplify_sum : forall n,
    2 * sum (S n) = 2 * (S n) + 2 * sum n .
Proof.
  (* ? *)
Abort.

(**

if we pay attention, in the last step of the proof, all occurrences of
'sum' are 'sum n' and as such if we think of those as 'some number' we
can consider the whole thing a somewhat cumbersome but not too
complicated algebraic proof.

We could try an elementary proof of it using properties like: 'n + 0 =
0' and all the usual algebraic properties of natural numbers.

A good thing about proof assistants is that they provide powerful
automation for common problems (and provide the tools to develop more
automation for our own domains). The 'ring' tactic is a powerful
solver for these kinds of equations that takes advantage of the fact
that natural numbers form a ring with the usual notions of
multiplication and addition. So instead of a lengthy argument, we as
Coq to figure it out itself using the ring tactic.
*)

(** Now, we are ready to tackle the theorem again. We will use the
form that avoid division (to enable us to use the ring tactic) and the
helper lemma that we just proved. *)

Lemma double_what_we_want: forall n,
    2 * sum n = n * (n + 1).
Proof.
  (* ? *)
Admitted.

(** And we are done! or are we?

We proved the result we wanted, but we changed the shape of the
theorem a bit to make it easier to prove (concretely we avoided the
division to be able to use the ring automation).

Let's try to show that the transformation we performed is valid.
Concretely we want to show that we can pass a non-zero factor from one
side as a divisor on the other side. The lemma looks like this: *)
Lemma half_to_double: forall n m,
    2 * m  = n -> m = n/2 .
Proof.
  intros.
  (* for the proof instead of automation we'll use facts from the library *)
  Search (_ / 2).
  About Nat.div2_div.
  Search Nat.div2.
  About Nat.div2_double.

Admitted.

(** So finally we can do the theorem in the exact way we wanted: *)

Theorem summation: forall n,
    sum n = n * (n + 1) /2.
Proof.

Admitted.

(** Well, I hope that was fun! There is much more fun to be had.
  Getting a program to run is always nice, getting a proof assistant
  to accept a proof is exhilarating! *)
