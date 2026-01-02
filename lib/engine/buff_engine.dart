import '../core/hero_model.dart';
import '../core/enums.dart';

class BuffEngine {
  /// =========================
  /// OUTGOING DAMAGE
  /// =========================

  int modifyOutgoingDamage(HeroModel attacker, int baseDamage) {
    int modified = baseDamage;

    for (final buff in attacker.buffs) {
      if (buff.type == BuffType.attackUp) {
        modified += buff.value;
      }
    }

    return modified.clamp(0, 9999);
  }

  /// =========================
  /// INCOMING DAMAGE
  /// =========================

  int modifyIncomingDamage(HeroModel defender, int damage) {
    int modified = damage;

    for (final buff in defender.buffs) {
      if (buff.type == BuffType.defenseUp) {
        modified -= buff.value;
      }
    }

    return modified.clamp(0, 9999);
  }

  /// =========================
  /// FLAGS (NON-MATH)
  /// =========================

  bool hasSwiftPlus(HeroModel hero) {
    return hero.buffs.any((b) => b.type == BuffType.swiftPlus);
  }
}
