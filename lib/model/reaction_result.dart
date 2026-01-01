class ReactionResult {
  final bool attackNegated;
  final double damageMultiplier;
  final int reflectedDamage;
  final int counterDamage;

  const ReactionResult({
     this.attackNegated = false,
     this.damageMultiplier = 1.0,
     this.reflectedDamage = 0,
     this.counterDamage = 0,
  });

  factory ReactionResult.none() {
    return const ReactionResult(
      attackNegated: false,
      damageMultiplier: 1.0,
      reflectedDamage: 0,
      counterDamage: 0,
    );
  }
}
