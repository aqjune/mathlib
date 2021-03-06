/-
Copyright (c) 2017 Mario Carneiro. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mario Carneiro
-/
import algebra.ordered_group order.lattice

open lattice

universes u v
variables {α : Type u} {β : Type v}

section
variables [decidable_linear_order α] [decidable_linear_order β] {f : α → β} {a b c d : α}

-- translate from lattices to linear orders (sup → max, inf → min)
lemma le_min_iff : c ≤ min a b ↔ c ≤ a ∧ c ≤ b := le_inf_iff
lemma max_le_iff : max a b ≤ c ↔ a ≤ c ∧ b ≤ c := sup_le_iff
lemma max_le_max : a ≤ c → b ≤ d → max a b ≤ max c d := sup_le_sup
lemma min_le_min : a ≤ c → b ≤ d → min a b ≤ min c d := inf_le_inf
lemma le_max_left_of_le : a ≤ b → a ≤ max b c := le_sup_left_of_le
lemma le_max_right_of_le : a ≤ c → a ≤ max b c := le_sup_right_of_le
lemma min_le_left_of_le : a ≤ c → min a b ≤ c := inf_le_left_of_le
lemma min_le_right_of_le : b ≤ c → min a b ≤ c := inf_le_right_of_le
lemma max_min_distrib_left : max a (min b c) = min (max a b) (max a c) := sup_inf_left
lemma max_min_distrib_right : max (min a b) c = min (max a c) (max b c) := sup_inf_right
lemma min_max_distrib_left : min a (max b c) = max (min a b) (min a c) := inf_sup_left
lemma min_max_distrib_right : min (max a b) c = max (min a c) (min b c) := inf_sup_right

lemma min_le_iff : min a b ≤ c ↔ a ≤ c ∨ b ≤ c :=
have a ≤ b → (a ≤ c ∨ b ≤ c ↔ a ≤ c),
  from assume h, or_iff_left_of_imp $ le_trans h,
have b ≤ a → (a ≤ c ∨ b ≤ c ↔ b ≤ c),
  from assume h, or_iff_right_of_imp $ le_trans h,
by cases le_total a b; simp [*, min_eq_left, min_eq_right]

lemma le_max_iff : a ≤ max b c ↔ a ≤ b ∨ a ≤ c :=
have b ≤ c → (a ≤ b ∨ a ≤ c ↔ a ≤ c),
  from assume h, or_iff_right_of_imp $ assume h', le_trans h' h,
have c ≤ b → (a ≤ b ∨ a ≤ c ↔ a ≤ b),
  from assume h, or_iff_left_of_imp $ assume h', le_trans h' h,
by cases le_total b c; simp [*, max_eq_left, max_eq_right]

lemma max_lt_iff : max a b < c ↔ (a < c ∧ b < c) :=
by rw [lt_iff_not_ge]; simp [(≥), le_max_iff, not_or_distrib]

lemma lt_min_iff : a < min b c ↔ (a < b ∧ a < c) :=
by rw [lt_iff_not_ge]; simp [(≥), min_le_iff, not_or_distrib]

lemma lt_max_iff : a < max b c ↔ a < b ∨ a < c :=
by rw [lt_iff_not_ge]; simp [(≥), max_le_iff, not_and_distrib]

lemma min_lt_iff : min a b < c ↔ a < c ∨ b < c :=
by rw [lt_iff_not_ge]; simp [(≥), le_min_iff, not_and_distrib]

theorem min_right_comm (a b c : α) : min (min a b) c = min (min a c) b :=
right_comm min min_comm min_assoc a b c

theorem max.left_comm (a b c : α) : max a (max b c) = max b (max a c) :=
left_comm max max_comm max_assoc a b c

theorem max.right_comm (a b c : α) : max (max a b) c = max (max a c) b :=
right_comm max max_comm max_assoc a b c

lemma max_distrib_of_monotone (hf : monotone f) : f (max a b) = max (f a) (f b) :=
by cases le_total a b; simp [max_eq_right, max_eq_left, h, hf h]

lemma min_distrib_of_monotone (hf : monotone f) : f (min a b) = min (f a) (f b) :=
by cases le_total a b; simp [min_eq_right, min_eq_left, h, hf h]

end

section decidable_linear_ordered_comm_group
variables [decidable_linear_ordered_comm_group α] {a b c : α}

attribute [simp] abs_zero abs_neg

def abs_add := @abs_add_le_abs_add_abs

theorem abs_le : abs a ≤ b ↔ - b ≤ a ∧ a ≤ b :=
⟨assume h, ⟨neg_le_of_neg_le $ le_trans (neg_le_abs_self _) h, le_trans (le_abs_self _) h⟩,
  assume ⟨h₁, h₂⟩, abs_le_of_le_of_neg_le h₂ $ neg_le_of_neg_le h₁⟩

lemma abs_lt : abs a < b ↔ - b < a ∧ a < b :=
⟨assume h, ⟨neg_lt_of_neg_lt $ lt_of_le_of_lt (neg_le_abs_self _) h, lt_of_le_of_lt (le_abs_self _) h⟩,
  assume ⟨h₁, h₂⟩, abs_lt_of_lt_of_neg_lt h₂ $ neg_lt_of_neg_lt h₁⟩

lemma abs_sub_le_iff : abs (a - b) ≤ c ↔ a - b ≤ c ∧ b - a ≤ c :=
by rw [abs_le, neg_le_sub_iff_le_add, @sub_le_iff_le_add' _ _ b, and_comm]

lemma abs_sub_lt_iff : abs (a - b) < c ↔ a - b < c ∧ b - a < c :=
by rw [abs_lt, neg_lt_sub_iff_lt_add, @sub_lt_iff_lt_add' _ _ b, and_comm]

def sub_abs_le_abs_sub := @abs_sub_abs_le_abs_sub

lemma abs_abs_sub_le_abs_sub (a b : α) : abs (abs a - abs b) ≤ abs (a - b) :=
abs_sub_le_iff.2 ⟨sub_abs_le_abs_sub _ _, by rw abs_sub; apply sub_abs_le_abs_sub⟩

@[simp] lemma abs_eq_zero : abs a = 0 ↔ a = 0 :=
⟨eq_zero_of_abs_eq_zero, λ e, e.symm ▸ abs_zero⟩

lemma abs_pos_iff {a : α} : 0 < abs a ↔ a ≠ 0 :=
⟨λ h, mt abs_eq_zero.2 (ne_of_gt h), abs_pos_of_ne_zero⟩

lemma abs_le_max_abs_abs (hab : a ≤ b)  (hbc : b ≤ c) : abs b ≤ max (abs a) (abs c) :=
abs_le_of_le_of_neg_le
  (by simp [le_max_iff, le_trans hbc (le_abs_self c)])
  (by simp [le_max_iff, le_trans (neg_le_neg hab) (neg_le_abs_self a)])

end decidable_linear_ordered_comm_group

section decidable_linear_ordered_comm_ring
variables [decidable_linear_ordered_comm_ring α] {a b c d : α}

@[simp] lemma abs_one : abs (1 : α) = 1 := abs_of_pos zero_lt_one

lemma monotone_mul_of_nonneg (ha : 0 ≤ a) : monotone (λ x, a*x) :=
assume b c b_le_c, mul_le_mul_of_nonneg_left b_le_c ha

lemma mul_max_of_nonneg (b c : α) (ha : 0 ≤ a) : a * max b c = max (a * b) (a * c) :=
max_distrib_of_monotone (monotone_mul_of_nonneg ha)

lemma mul_min_of_nonneg (b c : α) (ha : 0 ≤ a) : a * min b c = min (a * b) (a * c) :=
min_distrib_of_monotone (monotone_mul_of_nonneg ha)

lemma max_mul_mul_le_max_mul_max (b c : α) (ha : 0 ≤ a) (hd: 0 ≤ d) :
  max (a * b) (d * c) ≤ max a c * max d b :=
have ba : b * a ≤ max d b * max c a,
  from mul_le_mul (le_max_right d b) (le_max_right c a) ha (le_trans hd (le_max_left d b)),
have cd : c * d ≤ max a c * max b d,
  from mul_le_mul (le_max_right a c) (le_max_right b d) hd (le_trans ha (le_max_left a c)),
max_le
  (by simpa [mul_comm, max_comm] using ba)
  (by simpa [mul_comm, max_comm] using cd)

end decidable_linear_ordered_comm_ring
