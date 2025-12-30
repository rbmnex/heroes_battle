import '../core/reaction.dart';
import '../core/card.dart';
import '../core/enums.dart';
import '../model/reaction_result.dart';

class ReactionEngine {
  ReactionResult resolveReaction({
    required CardModel attackCard,
    required int baseDamage,
    ReactionCard? reaction,
    ReactionCard? counter,
  }) {
    final result = ReactionResult();

    // 1️⃣ Counter (based on BASE damage, always)
    if (reaction?.type == ReactionType.counter || counter != null) {
      result.reflectedDamage = (baseDamage * 0.5).round();
    }

    // 2️⃣ Evade (per-hero, including Area)
    if (reaction?.type == ReactionType.evade) {
      result.attackNegated = true;
    }

    // 3️⃣ Shield
    if (reaction?.type == ReactionType.shield &&
        attackCard.attackCategory == AttackCategory.magic) {
      result.attackNegated = true;
    }

    // 4️⃣ Block
    if (!result.attackNegated &&
        reaction?.type == ReactionType.block &&
        _isPhysical(attackCard)) {
      result.damageMultiplier = 0.5;
    }

    return result;
  }

  bool _isPhysical(CardModel card) {
    return card.attackCategory == AttackCategory.melee ||
           card.attackCategory == AttackCategory.range;
  }
}
