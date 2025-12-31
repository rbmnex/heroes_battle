import '../model/reaction_result.dart';
import '../core/card_model.dart';
import '../core/hero_model.dart';
import '../core/enums.dart';


class ReactionEngine {
  ReactionResult resolveReaction({
    required CardModel attackCard,
    required HeroModel attacker,
    required HeroModel defender,
    CardModel? reactionCard,
  }) {
    // No reaction played
    if (reactionCard == null) {
      return ReactionResult.none();
    }

    // Validate reaction card
    if (reactionCard.cardType != CardType.reaction ||
        reactionCard.reactionType == null) {
      return ReactionResult.none();
    }

    final reactionType = reactionCard.reactionType!;

    // Validate job class permission
    if (!defender.jobClass.allowedReactions.contains(reactionType)) {
      return ReactionResult.none();
    }

    bool attackNegated = false;
    double damageMultiplier = 1.0;
    int reflectedDamage = 0;

    final isPhysical = attackCard.attackCategory == AttackCategory.melee ||
        attackCard.attackCategory == AttackCategory.range;

    final isMagic = attackCard.attackCategory == AttackCategory.magic;

    switch (reactionType) {
      case ReactionType.evade:
        // Evade negates ANY attack (including Area, per hero)
        attackNegated = true;
        break;

      case ReactionType.block:
        if (isPhysical) {
          damageMultiplier = 0.5;
        }
        break;

      case ReactionType.parry:
        if (isPhysical) {
          attackNegated = true;
        }
        break;

      case ReactionType.shield:
        if (isMagic) {
          attackNegated = true;
        }
        break;

      case ReactionType.deflect:
        if (isMagic) {
          damageMultiplier = 0.5;
          reflectedDamage = _calculateCounter(attackCard);
        }
        break;

      case ReactionType.counter:
        reflectedDamage = _calculateCounter(attackCard);
        break;
    }

    return ReactionResult(
      attackNegated: attackNegated,
      damageMultiplier: damageMultiplier,
      reflectedDamage: reflectedDamage,
    );
  }

  int _calculateCounter(CardModel attackCard) {
    final base = attackCard.baseDamage ?? 0;
    return (base * 0.5).round();
  }
}
