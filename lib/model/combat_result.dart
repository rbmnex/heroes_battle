import '../core/hero_model.dart';
import '../core/status_effect.dart';

class CombatResult {
  /// Attacker
  final HeroModel attacker;

  /// All affected defenders (single, multi, area)
  final List<HeroModel> defenders;

  /// Damage dealt per defender (after all modifiers)
  final Map<HeroModel, int> damageDealt;

  /// Counter damage returned to attacker
  final int counterDamageTaken;

  /// Defenders who fully negated the attack
  final List<HeroModel> evadedTargets;

  /// Status effects applied per defender
  final Map<HeroModel, List<StatusEffect>> appliedStatusEffects;

  /// Combo flags
  final bool wasSwiftCombo;
  final bool wasComboAttack;

  CombatResult({
    required this.attacker,
    required this.defenders,
    required this.damageDealt,
    this.counterDamageTaken = 0,
    this.evadedTargets = const [],
    this.appliedStatusEffects = const {},
    this.wasSwiftCombo = false,
    this.wasComboAttack = false,
  });
}
