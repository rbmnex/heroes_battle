import '../core/card_model.dart';
import '../core/hero_model.dart';
import '../core/status_effect.dart';
import '../core/enums.dart';
import '../model/combat_result.dart';
import 'buff_engine.dart';
import 'reaction_engine.dart';
import 'status_effect_engine.dart';

class AttackEngine {
  final ReactionEngine reactionEngine;
  final BuffEngine buffEngine;
  final StatusEffectEngine statusEffectEngine;

  AttackEngine({
    required this.reactionEngine,
    required this.buffEngine,
    required this.statusEffectEngine,
  });

  /// =========================
  /// PUBLIC ENTRY POINT
  /// =========================

  CombatResult executeAttack({
    required HeroModel attacker,
    required List<HeroModel> defenders,
    required CardModel attackCard,
    bool isSwiftCombo = false,
    bool isComboAttack = false,
  }) {
    _validateAttack(attacker, attackCard);

    final Map<HeroModel, int> damageMap = {};
    final Map<HeroModel, List<StatusEffect>> statusMap = {};
    final List<HeroModel> evadedTargets = [];

    int totalCounterDamage = 0;

    for (final defender in defenders) {
      if (defender.isDefeated) continue;

      // 1️⃣ Base damage
      int baseDamage = attackCard.baseDamage;

      // 2️⃣ Attacker buffs
      baseDamage = buffEngine.modifyOutgoingDamage(
        attacker,
        baseDamage,
      );

      // 3️⃣ Defender reaction
      final reactionResult = reactionEngine.resolveReaction(
        attackCard: attackCard,
        baseDamage: baseDamage,
        defender: defender,
      );

      // Counter damage is based on BASE damage
      totalCounterDamage += reactionResult.counterDamage;

      // Evade / negate
      if (reactionResult.attackNegated) {
        evadedTargets.add(defender);
        damageMap[defender] = 0;
        continue;
      }

      // 4️⃣ Final damage
      int finalDamage =
          (baseDamage * reactionResult.damageMultiplier).round();

      finalDamage = finalDamage.clamp(0, defender.currentHp);
      defender.currentHp -= finalDamage;
      damageMap[defender] = finalDamage;

    // 5️⃣ Apply counter damage to attacker
    if (totalCounterDamage > 0) {
      attacker.currentHp -= totalCounterDamage.clamp(0, attacker.currentHp);
    }

    attacker.hasAttackedThisTurn = true;

    return CombatResult(
      attacker: attacker,
      defenders: defenders,
      damageDealt: damageMap,
      counterDamageTaken: totalCounterDamage,
      evadedTargets: evadedTargets,
      appliedStatusEffects: statusMap,
      wasSwiftCombo: isSwiftCombo,
      wasComboAttack: isComboAttack,
    );
  }

  /// =========================
  /// VALIDATION
  /// =========================

  void _validateAttack(HeroModel attacker, CardModel card) {
    if (card.cardType != CardType.attack) {
      throw Exception('Card is not an attack card');
    }

    if (attacker.hasAttackedThisTurn) {
      throw Exception('${attacker.name} has already attacked this turn');
    }
  }
}
