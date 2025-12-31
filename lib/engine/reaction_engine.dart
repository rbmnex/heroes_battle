import '../core/hero.dart';
import '../core/attack_card.dart';
import '../core/enums.dart';
import '../model/reaction_result.dart';

class ReactionEngine {
  ReactionResult resolve({
    required HeroModel defender,
    required AttackCard attackCard,
    required int baseDamage,
    ReactionType? reaction,
    bool hasCounter = false,
  }) {
    final result = ReactionResult();

    /// =========================
    /// JOB CLASS VALIDATION
    /// =========================

    if (reaction != null && !_canUseReaction(defender.jobClass, reaction)) {
      return result; // illegal reaction ignored
    }

    /// =========================
    /// COUNTER (BASE DAMAGE)
    /// =========================
    if (reaction == ReactionType.counter || hasCounter) {
      if (_canUseReaction(defender.jobClass, ReactionType.counter)) {
        result.reflectedDamage = (baseDamage * 0.5).round();
      }
    }

    /// =========================
    /// EVADE (NEGATES ALL TYPES)
    /// =========================
    if (reaction == ReactionType.evade) {
      result.attackNegated = true;
      return result; // Evade overrides damage
    }

    /// =========================
    /// SHIELD (MAGIC ONLY)
    /// =========================
    if (reaction == ReactionType.shield &&
        attackCard.category == AttackCategory.magic) {
      result.attackNegated = true;
      return result;
    }

    /// =========================
    /// BLOCK (PHYSICAL ONLY)
    /// =========================
    if (reaction == ReactionType.block &&
        _isPhysical(attackCard.category)) {
      result.damageMultiplier = 0.5;
    }

    return result;
  }

  /// =========================
  /// VALIDATION HELPERS
  /// =========================

  bool _canUseReaction(JobClass job, ReactionType reaction) {
    switch (reaction) {
      case ReactionType.block:
      case ReactionType.parry:
        return job == JobClass.melee || job == JobClass.ranged;

      case ReactionType.evade:
        return true;

      case ReactionType.counter:
        return job == JobClass.melee;

      case ReactionType.shield:
      case ReactionType.deflect:
        return job == JobClass.mage || job == JobClass.support;
    }
  }

  bool _isPhysical(AttackCategory category) {
    return category == AttackCategory.melee ||
        category == AttackCategory.range;
  }
}