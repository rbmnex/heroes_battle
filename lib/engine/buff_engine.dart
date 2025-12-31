import '../core/hero.dart';
import '../model/buff_effect.dart';
import '../core/enums.dart';


class BuffEngine {
  /// =========================
  /// APPLY BUFF
  /// =========================

  static void applyBuff(
    HeroModel hero,
    BuffEffect newBuff,
  ) {
    final existing = hero.buffs
        .where((b) => b.type == newBuff.type)
        .toList();

    if (existing.isNotEmpty) {
      // Refresh stronger or longer buff
      existing.first.duration =
          existing.first.duration > newBuff.duration
              ? existing.first.duration
              : newBuff.duration;
      return;
    }

    hero.buffs.add(newBuff);
  }

  /// =========================
  /// DAMAGE MODIFIERS
  /// =========================

  int modifyOutgoingDamage({
    required HeroModel attacker,
    required int baseDamage,
    required bool isCombo,
  }) {
    int modified = baseDamage;

    for (final buff in attacker.buffs) {
      switch (buff.type) {
        case BuffType.attackUp:
          modified += buff.value;
          break;

        case BuffType.swiftPlus:
          // Swift+ only applies when attack is a combo
          if (isCombo) {
            modified += buff.value;
          }
          break;

        default:
          break;
      }
    }

    return modified;
  }

  static double modifyIncomingDamageMultiplier(HeroModel hero) {
    double multiplier = 1.0;

    for (final buff in hero.buffs) {
      if (buff.type == BuffType.defenseUp) {
        multiplier -= buff.value / 100;
      }
    }

    return multiplier.clamp(0.1, 1.0);
  }

  /// =========================
  /// INCOMING DAMAGE
  /// =========================
  int modifyIncomingDamage({
    required HeroModel defender,
    required int damage,
  }) {
    int modified = damage;

    for (final buff in defender.buffs) {
      switch (buff.type) {
        case BuffType.defenseUp:
          modified -= buff.value;
          break;

        case BuffType.guardPlus:
          // Flat reduction, future-proof hook
          modified -= buff.value;
          break;

        default:
          break;
      }
    }

    return modified < 0 ? 0 : modified;
  }

  /// =========================
  /// SWIFT MODIFIER
  /// =========================

  // ✅ ADD THIS (used by Swift engine)
  static bool allowsExtraSwiftCombo(HeroModel hero) {
    return hero.buffs.any((b) => b.type == BuffType.swiftPlus);
  }

  /// =========================
  /// TURN END
  /// =========================

  static void onTurnEnd(HeroModel hero) {
    hero.buffs.removeWhere((buff) {
      buff.duration -= 1;
      return buff.duration <= 0;
    });
  }
}
