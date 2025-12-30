import '../core/hero.dart';
import '../core/attack_card.dart';
import '../engine/buff_engine.dart';
import '../engine/status_engine.dart';
import '../engine/reaction_engine.dart';
import '../model/attack_resolution.dart';
import '../core/reaction.dart';

class AttackEngine {
  final ReactionEngine _reactionEngine = ReactionEngine();

  AttackResolution performAttack({
    required HeroModel attacker,
    required HeroModel defender,
    required AttackCard attackCard,
    required bool isCombo,
    ReactionCard? reaction,
    ReactionCard? counter,
  }) {
    // =========================
    // 1️⃣ Base Damage
    // =========================
    int damage = attackCard.baseDamage;

    // =========================
    // 2️⃣ Attacker Modifiers
    // =========================
    damage = BuffEngine.modifyOutgoingDamage(attacker, damage);
    damage = StatusEffectEngine.modifyOutgoingDamage(attacker, damage);

    // Save BASE damage for counter calculation
    final int baseDamageForCounter = damage;

    // =========================
    // 3️⃣ Reaction Resolution
    // =========================
    final reactionResult = _reactionEngine.resolveReaction(
      attackCard: attackCard,
      baseDamage: baseDamageForCounter,
      reaction: reaction,
      counter: counter,
    );

    if (reactionResult.attackNegated) {
      // Apply reflected damage even if negated
      if (reactionResult.reflectedDamage > 0) {
        attacker.takeDamage(reactionResult.reflectedDamage);
      }

      return AttackResolution(
        attackCard: attackCard,
        damageDealt: 0,
        wasEvaded: true,
        isCombo: isCombo,
        counterDamageTaken: reactionResult.reflectedDamage,
      );
    }

    // Apply block multiplier
    damage = (damage * reactionResult.damageMultiplier).round();

    // =========================
    // 4️⃣ Defender Modifiers
    // =========================
    damage = StatusEffectEngine.modifyIncomingDamage(defender, damage);

    final defenseMultiplier =
        BuffEngine.modifyIncomingDamageMultiplier(defender);
    damage = (damage * defenseMultiplier).round();

    // Clamp
    if (damage < 0) damage = 0;

    // =========================
    // 5️⃣ Apply Damage
    // =========================
    defender.takeDamage(damage);

    if (reactionResult.reflectedDamage > 0) {
      attacker.takeDamage(reactionResult.reflectedDamage);
    }

    // =========================
    // 6️⃣ Finalize
    // =========================
    attacker.hasAttackedThisTurn = true;

    return AttackResolution(
      attackCard: attackCard,
      damageDealt: damage,
      wasEvaded: false,
      isCombo: isCombo,
      counterDamageTaken: reactionResult.reflectedDamage,
    );
  }
}
