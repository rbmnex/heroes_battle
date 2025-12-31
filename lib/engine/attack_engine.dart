

import 'package:heroes_battle/core/attack_card.dart';
import 'package:heroes_battle/core/enums.dart';
import 'package:heroes_battle/core/hero.dart';
import 'package:heroes_battle/engine/buff_engine.dart';
import 'package:heroes_battle/engine/reaction_engine.dart';
import 'package:heroes_battle/engine/status_engine.dart';
import 'package:heroes_battle/model/attack_resolution.dart';
import 'package:heroes_battle/model/reaction_result.dart';

class AttackEngine {
  final ReactionEngine _reactionEngine = ReactionEngine();
  final BuffEngine _buffEngine = BuffEngine();
  final StatusEffectEngine _statusEffectEngine = StatusEffectEngine();

  AttackResolution performAttack({
    required HeroModel attacker,
    required HeroModel defender,
    required AttackCard attackCard,
    required bool isCombo,
    ReactionType? defenderReaction,
    bool hasCounter = false,
  }) {
    if (attacker.isDefeated || defender.isDefeated) {
      throw Exception('Invalid combatants');
    }

    /// =========================
    /// 1️⃣ BASE DAMAGE
    /// =========================
    int baseDamage = _calculateBaseDamage(attackCard);

    /// =========================
    /// 2️⃣ APPLY ATTACKER BUFFS
    /// =========================
    baseDamage = _buffEngine.modifyOutgoingDamage(
      attacker: attacker,
      baseDamage: baseDamage,
      isCombo: isCombo,
    );

    /// =========================
    /// 3️⃣ RESOLVE REACTION
    /// =========================
    final ReactionResult reactionResult =
        _reactionEngine.resolve(
      defender: defender,
      attackCard: attackCard,
      baseDamage: baseDamage,
      reaction: defenderReaction,
      hasCounter: hasCounter,
    );

    /// =========================
    /// 4️⃣ DAMAGE NEGATION
    /// =========================
    int finalDamage = baseDamage;

    if (reactionResult.attackNegated) {
      finalDamage = 0;
    }

    /// =========================
    /// 5️⃣ DAMAGE MULTIPLIER
    /// =========================
    finalDamage =
        (finalDamage * reactionResult.damageMultiplier).round();

    /// =========================
    /// 6️⃣ DEAL DAMAGE
    /// =========================
    defender.takeDamage(finalDamage);

    /// =========================
    /// 7️⃣ COUNTER DAMAGE
    /// =========================
    if (reactionResult.reflectedDamage > 0) {
      attacker.takeDamage(reactionResult.reflectedDamage);
    }

    /// =========================
    /// 8️⃣ POST-HIT STATUS (HOOK)
    /// =========================
    _applyStatusEffects(
      attacker: attacker,
      defender: defender,
      attackCard: attackCard,
      isCombo: isCombo,
      reactionResult: reactionResult,
      finalDamage: finalDamage,
    );

    /// =========================
    /// 9️⃣ MARK TURN STATE
    /// =========================
    attacker.hasAttackedThisTurn = true;
    if (isCombo) attacker.comboUsedThisTurn = true;

    return AttackResolution(
      attackCard: attackCard,
      isCombo: isCombo,
      wasEvaded: reactionResult.attackNegated,
      damageDealt: finalDamage,
      counterDamageTaken: reactionResult.reflectedDamage,
    );
  }

  /// =========================
  /// DAMAGE CALCULATION
  /// =========================

  int _calculateBaseDamage(AttackCard card) {
    switch (card.speed) {
      case AttackType.normal:
        return 10;
      case AttackType.heavy:
        return 15;
      case AttackType.swift:
        return 8;
    }
  }

  

  /// =========================
  /// STATUS EFFECT HOOK
  /// =========================

  void _applyStatusEffects({
    required HeroModel attacker,
    required HeroModel defender,
    required AttackCard attackCard,
    required bool isCombo,
    required ReactionResult reactionResult,
    required int finalDamage,
  }) {
    if (reactionResult.attackNegated || finalDamage <= 0) return;

    _statusEffectEngine.applyOnHit(
      attacker: attacker,
      defender: defender,
      isCombo: isCombo,
      category: attackCard.category,
    );
  }

}
