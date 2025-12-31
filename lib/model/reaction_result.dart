class ReactionResult {
  final bool attackNegated;
  final double damageMultiplier;
  final int reflectedDamage;

  const ReactionResult({
    required this.attackNegated,
    required this.damageMultiplier,
    required this.reflectedDamage,
  });

  factory ReactionResult.none() {
    return const ReactionResult(
      attackNegated: false,
      damageMultiplier: 1.0,
      reflectedDamage: 0,
    );
  }
}
