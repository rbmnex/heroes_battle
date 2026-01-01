import '../core/hero_model.dart';
import '../core/enums.dart';
import '../core/status_effect.dart';
import '../core/card_model.dart';

class StatusEffectEngine {
  /// =========================
  /// APPLY ON HIT
  /// =========================
  void applyOnHit({
    required HeroModel attacker,
    required HeroModel defender,
    required CardModel attackCard,
    required bool isCombo,
  }) {
    // Status effects only come from attack cards
    if (attackCard.statusType == null) return;

    final status = attackCard.statusType!;

    // Example rules (expandable)
    switch (status) {
      case StatusType.bleed:
        if (attackCard.attackCategory == AttackCategory.melee) {
          _applyStatus(defender, status, 2);
        }
        break;

      case StatusType.burn:
        if (attackCard.attackCategory == AttackCategory.magic) {
          _applyStatus(defender, status, 2);
        }
        break;

      case StatusType.stun:
        if (!isCombo) {
          _applyStatus(defender, status, 1);
        }
        break;

      case StatusType.shielded:
        _applyStatus(defender, status, 1);
        break;
    }
  }

  /// =========================
  /// TURN START
  /// =========================
  void processTurnStart(HeroModel hero) {
    final expired = <StatusEffect>[];

    for (final status in hero.statusEffects) {
      switch (status.type) {
        case StatusType.bleed:
        case StatusType.poison:
          hero.currentHp -= 1;
          break;

        case StatusType.burn:
          hero.currentHp -= 2;
          break;

        case StatusType.stun:
        case StatusType.shielded:
          // No damage on turn start
          break;
      }

      status.duration--;

      if (status.duration <= 0) {
        expired.add(status);
      }
    }

    hero.statusEffects.removeWhere(expired.contains);
  }

  void onTurnStart(HeroModel hero) {
    for (final status in hero.statusEffects) {
      if (status.type == StatusType.poison ||
          status.type == StatusType.bleed ||
          status.type == StatusType.burn) {
        hero.currentHp -= status.value;
      }
    }
  }

  void onTurnEnd(HeroModel hero) {
    hero.statusEffects.removeWhere((s) {
      s.duration--;
      return s.duration <= 0;
    });
  }

  /// =========================
  /// APPLY STATUS (PRIVATE)
  /// =========================
  void _applyStatus(
    HeroModel hero,
    StatusType type,
    int duration,
  ) {
    // Prevent stacking same status
    final existing = hero.statusEffects
        .where((s) => s.type == type)
        .toList();

    if (existing.isNotEmpty) return;

    hero.statusEffects.add(
      StatusEffect(
        type: type,
        duration: duration,
      ),
    );
  }
}
