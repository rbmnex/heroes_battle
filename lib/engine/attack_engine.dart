import '../core/card_model.dart';
import '../core/hero_model.dart';
import '../core/enums.dart';

import 'reaction_engine.dart';
import 'buff_engine.dart';
import 'status_effect_engine.dart';
import 'swift_combo_engine.dart';
import '../model/combat_result.dart';
import '../model/reaction_result.dart';

class AttackEngine {
  final ReactionEngine _reactionEngine;
  final BuffEngine _buffEngine;
  final StatusEffectEngine _statusEffectEngine;
  final SwiftComboEngine _swiftComboEngine;

  AttackEngine({
    required ReactionEngine reactionEngine,
    required BuffEngine buffEngine,
    required StatusEffectEngine statusEffectEngine,
    required SwiftComboEngine swiftComboEngine,
  })  : _reactionEngine = reactionEngine,
        _buffEngine = buffEngine,
        _statusEffectEngine = statusEffectEngine,
        _swiftComboEngine = swiftComboEngine;

  /// =========================
  /// MAIN ENTRY
  /// =========================
  CombatResult resolveAttack({
    required HeroModel attacker,
    required CardModel attackCard,
    required List<HeroModel> defenders,
    required bool isCombo,
    Map<String, CardModel?> reactions = const {},
  }) {
    _validateAttack(attacker, attackCard);

    // Swift legality
    if (!_swiftComboEngine.canExecuteAttack(
      hero: attacker,
      attackCard: attackCard,
      isCombo: isCombo,
    )) {
      throw Exception('Illegal Swift / Combo usage');
    }

    final baseDamage = attackCard.baseDamage ?? 0;
    final targetResults = <TargetResult>[];
    int totalCounterDamage = 0;

    for (final defender in defenders) {
      if (defender.isDefeated) continue;

      // =========================
      // 1️⃣ OUTGOING BUFFS
      // =========================
      int damage =
          _buffEngine.modifyOutgoingDamage(attacker, baseDamage);

      // =========================
      // 2️⃣ REACTION
      // =========================
      final reactionCard = reactions[defender.id];

      final ReactionResult reaction = _reactionEngine.resolveReaction(
        attackCard: attackCard,
        attacker: attacker,
        defender: defender,
        reactionCard: reactionCard,
      );

      totalCounterDamage += reaction.reflectedDamage;

      // =========================
      // 3️⃣ NEGATION CHECK
      // =========================
      if (reaction.attackNegated) {
        targetResults.add(
          TargetResult(
            defender: defender,
            damageTaken: 0,
            wasNegated: true,
          ),
        );
        continue;
      }

      // =========================
      // 4️⃣ INCOMING BUFFS
      // =========================
      damage =
          _buffEngine.modifyIncomingDamage(defender, damage);

      // =========================
      // 5️⃣ REACTION MODIFIER
      // =========================
      damage = (damage * reaction.damageMultiplier).round();

      // =========================
      // 6️⃣ CLAMP
      // =========================
      damage = damage.clamp(0, 9999);

      // =========================
      // 7️⃣ APPLY DAMAGE
      // =========================
      defender.currentHp -= damage;

      // =========================
      // 8️⃣ STATUS EFFECTS
      // =========================
      if (damage > 0) {
        _statusEffectEngine.applyOnHit(
          attacker: attacker,
          defender: defender,
          attackCard: attackCard,
          isCombo: isCombo,
        );
      }

      targetResults.add(
        TargetResult(
          defender: defender,
          damageTaken: damage,
          wasNegated: false,
        ),
      );
    }

    // =========================
    // 9️⃣ COUNTER DAMAGE
    // =========================
    if (totalCounterDamage > 0) {
      attacker.currentHp -= totalCounterDamage;
    }

    // =========================
    // 🔟 SWIFT STATE UPDATE
    // =========================
    _swiftComboEngine.markAttackResolved(
      attacker,
      attackCard,
      isCombo,
    );

    return CombatResult(
      attackCard: attackCard,
      isCombo: isCombo,
      targets: targetResults,
      totalCounterDamage: totalCounterDamage,
    );
  }

  /// =========================
  /// VALIDATION
  /// =========================
  void _validateAttack(HeroModel attacker, CardModel card) {
    if (card.cardType != CardType.attack) {
      throw Exception('Card is not an attack');
    }

    if (!attacker.jobClass.allowedAttackCategories
        .contains(card.attackCategory)) {
      throw Exception('JobClass cannot use this attack');
    }

    if (attacker.isDefeated) {
      throw Exception('Defeated hero cannot attack');
    }
  }
}
