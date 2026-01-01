import '../core/card_model.dart';
import '../core/hero_model.dart';
import '../core/enums.dart';
import '../core/job_class.dart';
import '../model/reaction_result.dart';

class ReactionEngine {
  ReactionResult resolveReaction({
    required CardModel attackCard,
    required HeroModel defender,
    required int baseDamage,
  }) {
    // No reaction available
    final reaction = defender.activeReaction;
    if (reaction == null) {
      return const ReactionResult();
    }

    // JobClass validation
    if (!_canUseReaction(defender.jobClass, reaction.reactionType!)) {
      return const ReactionResult();
    }

    switch (reaction.reactionType!) {
      case ReactionType.evade:
      case ReactionType.parry:
        return const ReactionResult(
          attackNegated: true,
        );

      case ReactionType.block:
        if (_isPhysical(attackCard)) {
          return const ReactionResult(
            damageMultiplier: 0.5,
          );
        }
        break;

      case ReactionType.counter:
        return ReactionResult(
          counterDamage: (baseDamage * 0.5).round(),
        );

      case ReactionType.shield:
        if (attackCard.attackCategory == AttackCategory.magic) {
          return const ReactionResult(
            attackNegated: true,
          );
        }
        break;

      case ReactionType.deflect:
        if (attackCard.attackCategory == AttackCategory.magic) {
          return ReactionResult(
            reflectedDamage: (baseDamage * 0.5).round(),
          );
        }
        break;
    }

    return const ReactionResult();
  }

  /// =========================
  /// HELPERS
  /// =========================

  bool _isPhysical(CardModel card) {
    return card.attackCategory == AttackCategory.melee ||
        card.attackCategory == AttackCategory.range;
  }

  bool _canUseReaction(JobClass job, ReactionType type) {
    return job.allowedReactions.contains(type);
  }
}
