class ReactionResult {
  bool attackNegated;
  double damageMultiplier;
  int reflectedDamage;

  ReactionResult({
    this.attackNegated = false,
    this.damageMultiplier = 1.0,
    this.reflectedDamage = 0,
  });
}
