import '../core/enums.dart';
import '../core/hero_model.dart';
import '../core/status_effect.dart';

class StatusEffectEngine {
  /// =========================
  /// TURN START
  /// =========================

  void processTurnStart(HeroModel hero) {
    for (final effect in hero.statusEffects) {
      switch (effect.type) {
        case StatusType.burn:
        case StatusType.poison:
        case StatusType.bleed:
          _applyDot(hero, effect.value);
          break;

        case StatusType.freeze:
        case StatusType.stun:
          // Handled via query flags
          break;

        case StatusType.silence:
          // Handled via query flags  
          break;

        case StatusType.shielded:
          // No action needed at turn start
          break;

      }
    }
  }

  /// =========================
  /// TURN END
  /// =========================

  void processTurnEnd(HeroModel hero) {
    hero.statusEffects.removeWhere((effect) {
      effect.duration -= 1;
      return effect.duration <= 0;
    });
  }

  /// =========================
  /// QUERIES (FLAGS)
  /// =========================

  bool isStunned(HeroModel hero) {
    return hero.statusEffects.any(
      (e) => e.type == StatusType.stun,
    );
  }

  bool isFrozen(HeroModel hero) {
    return hero.statusEffects.any(
      (e) => e.type == StatusType.freeze,
    );
  }

  bool isSilenced(HeroModel hero) {
    return hero.statusEffects.any(
      (e) => e.type == StatusType.silence,
    );
  }

  /// =========================
  /// INTERNAL
  /// =========================

  void _applyDot(HeroModel hero, int damage) {
    hero.currentHp =
        (hero.currentHp - damage).clamp(0, hero.maxHp);
  }

  // void applyOnHit({
  //   required HeroModel attacker,
  //   required HeroModel defender,
  //   required AttackCardCategory category,
  //   required bool isCombo,
  // }) {
  //   // Example rules — deterministic, data-driven

  //   switch (category) {
  //     case AttackCardCategory.fire:
  //       _addStatus(defender, StatusEffectType.burn, 2, 3);
  //       break;

  //     case AttackCardCategory.poison:
  //       _addStatus(defender, StatusEffectType.poison, 1, 4);
  //       break;

  //     case AttackCardCategory.ice:
  //       if (isCombo) {
  //         _addStatus(defender, StatusEffectType.freeze, 0, 1);
  //       }
  //       break;

  //     case AttackCardCategory.physical:
  //       // no status
  //       break;
  //   }
  // }

  /// =========================
  /// INTERNAL
  /// =========================

  void _addStatus(
    HeroModel hero,
    StatusType type,
    int value,
    int duration,
  ) {
    hero.statusEffects.add(
      StatusEffect(
        type: type,
        value: value,
        duration: duration,
      ),
    );
  }
}
