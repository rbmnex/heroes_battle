import '../core/hero_model.dart';
import '../core/card_model.dart';

class CombatResult {
  final CardModel attackCard;
  final bool isCombo;
  final List<TargetResult> targets;
  final int totalCounterDamage;

  CombatResult({
    required this.attackCard,
    required this.isCombo,
    required this.targets,
    required this.totalCounterDamage,
  });
}

class TargetResult {
  final HeroModel defender;
  final int damageTaken;
  final bool wasNegated;

  TargetResult({
    required this.defender,
    required this.damageTaken,
    required this.wasNegated,
  });
}
