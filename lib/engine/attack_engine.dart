import '../core/hero.dart';
import '../core/attack_card.dart';
import '../core/enums.dart';
import '../model/attack_result.dart';
import '../model/reaction_result.dart';
import 'buff_engine.dart';
import 'status_engine.dart';
import 'reaction_engine.dart';

class AttackEngine {
  static AttackResult performAttack({
    required HeroModel attacker,
    required HeroModel defender,
    required AttackCard card,
    required List<ReactionType> reactions,
  }) {
    // =========================
    // 0️⃣ PRE-CHECKS
    // =========================
    if (attacker.isDefeated || defender.isDefeated) {
      return AttackResult.invalid();
    }

    // =========================
    // 1️⃣ BASE DAMAGE
    // =========================
    int damage = card.baseDamage;

    // =========================
    // 2️⃣ ATTACKER BUFFS
    // =========================
    damage = BuffEngine.modifyOutgoingDamage(attacker, damage);

    // =========================
    // 3️⃣ ATTACKER STATUS
    // =========================
    damage = StatusEngine.modifyOutgoingDamage(attacker, damage);

    // =========================
    // 4️⃣ COUNTER (RAW DAMAGE)
    // =========================
    if (reactions.contains(ReactionType.counter)) {
      final int counterDamage = (damage * 0.5).round();

      attacker.currentHp -= counterDamage;
      if (attacker.currentHp < 0) attacker.currentHp = 0;

      if (attacker.currentHp == 0) {
        attacker.isDefeated = true;
      }
    }

    // =========================
    // 5️⃣ REACTION RESOLUTION
    // =========================
    final ReactionResult reactionResult =
        ReactionEngine.resolve(reactions, damage);

    if (reactionResult.evaded) {
      return AttackResult.evaded();
    }

    damage = reactionResult.finalDamage;

    // =========================
    // 6️⃣ DEFENDER BUFFS
    // =========================
    final double buffMultiplier =
        BuffEngine.modifyIncomingDamageMultiplier(defender);

    damage = (damage * buffMultiplier).round();

    // =========================
    // 7️⃣ DEFENDER STATUS
    // =========================
    damage =
        StatusEngine.modifyIncomingDamage(defender, damage);

    // =========================
    // 8️⃣ APPLY DAMAGE
    // =========================
    defender.currentHp -= damage;
    if (defender.currentHp < 0) defender.currentHp = 0;

    if (defender.currentHp == 0) {
      defender.isDefeated = true;
    }

    return AttackResult.success(
      damageDealt: damage,
      counterDamageTaken:
          reactions.contains(ReactionType.counter)
              ? (damage * 0.5).round()
              : 0,
    );
  }
}
