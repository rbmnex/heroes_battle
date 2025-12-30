import '../core/hero.dart';
import '../model/status_effect.dart';
import '../core/enums.dart';


class StatusEffectEngine {
  /// =========================
  /// APPLY STATUS
  /// =========================

  static void applyStatus(
    HeroModel hero,
    StatusEffect newEffect,
  ) {
    // Prevent duplicate stun/shield unless refreshed
    final existing = hero.statusEffects
        .where((e) => e.type == newEffect.type)
        .toList();

    if (existing.isNotEmpty) {
      // Refresh duration
      existing.first.duration =
          existing.first.duration > newEffect.duration
              ? existing.first.duration
              : newEffect.duration;
      return;
    }

    hero.statusEffects.add(newEffect);
  }

  /// =========================
  /// TURN START TICK
  /// =========================

  static void onTurnStart(HeroModel hero) {
    for (final effect in hero.statusEffects) {
      switch (effect.type) {
        case StatusType.burn:
          hero.currentHp -= effect.value;
          break;

        case StatusType.stun:
          hero.isStunned = true;
          break;

        default:
          break;
      }
    }
  }

  /// =========================
  /// ON HERO ACTION
  /// =========================

  static void onHeroAction(HeroModel hero) {
    for (final effect in hero.statusEffects) {
      if (effect.type == StatusType.bleed) {
        hero.currentHp -= effect.value;
      }
    }
  }

  /// =========================
  /// TURN END TICK
  /// =========================

  static void onTurnEnd(HeroModel hero) {
    hero.isStunned = false;

    hero.statusEffects.removeWhere((effect) {
      effect.duration -= 1;
      return effect.duration <= 0;
    });
  }

  // =========================
  // DAMAGE MODIFIERS
  // =========================

  static int modifyOutgoingDamage(HeroModel hero, int damage) {
    int modified = damage;

    for (final status in hero.statusEffects) {
      // Example future-proofing
      // if (status.type == StatusType.weaken) {
      //   modified -= status.value;
      // }
    }

    return modified < 0 ? 0 : modified;
  }

  static int modifyIncomingDamage(HeroModel hero, int damage) {
    int modified = damage;

    for (final status in hero.statusEffects) {
      // Example:
      // if (status.type == StatusType.vulnerable) {
      //   modified += status.value;
      // }
    }

    return modified < 0 ? 0 : modified;
  }

  // =========================
  // EXISTING PHASE METHODS
  // =========================
  // onTurnStart(hero)
  // onHeroAction(hero)
  // onTurnEnd(hero)
}
