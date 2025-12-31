import 'package:heroes_battle/model/status_effect.dart';

import '../core/enums.dart';
import '../core/hero.dart';

class StatusEffectEngine {
  /// =========================
  /// APPLY STATUS ON HIT
  /// =========================
  void applyOnHit({
    required HeroModel attacker,
    required HeroModel defender,
    required bool isCombo,
    required AttackCategory category,
  }) {
    // Example rules (expand later)

    if (category == AttackCategory.magic) {
      defender.statusEffects.add(
        StatusEffect(
          type: StatusType.burn,
          duration: isCombo ? 3 : 2,
          value: isCombo ? 4 : 2,
        ),
      );
    }

    if (isCombo && category == AttackCategory.melee) {
      defender.statusEffects.add(
        StatusEffect(
          type: StatusType.stun,
          duration: 1,
        ),
      );
    }
  }

  /// =========================
  /// TURN START TICK
  /// =========================
  void processTurnStart(HeroModel hero) {
     for (final status in List.of(hero.statusEffects)) {
      switch (status.type) {
        case StatusType.burn:
        case StatusType.bleed:
        case StatusType.poison:
          hero.takeDamage(status.value);
          status.tick();
          break;

        case StatusType.stun:
          status.tick(); // stun duration decreases each turn
          break;

        case StatusType.shielded:
          // Shield does NOT tick here.
          // It is consumed via damage pipeline.
          break;
      }
    }

    hero.statusEffects.removeWhere((s) => s.isExpired);
  }
}
