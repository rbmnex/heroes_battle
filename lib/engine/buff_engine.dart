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

  static int modifyOutgoingDamage(HeroModel hero, int baseDamage) {
    int modified = baseDamage;

    for (final buff in hero.buffs) {
      if (buff.type == BuffType.attackUp) {
        modified += buff.value;
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
  /// SWIFT MODIFIER
  /// =========================

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
