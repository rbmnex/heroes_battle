import '../core/hero_model.dart';
import '../core/enums.dart';

class BuffEngine {
  /// =========================
  /// OUTGOING DAMAGE
  /// =========================
  int modifyOutgoingDamage(HeroModel hero, int baseDamage) {
    int modified = baseDamage;

    for (final buff in hero.buffs) {
      switch (buff.type) {
        case BuffType.attackUp:
          modified += buff.value;
          break;

        case BuffType.swiftPlus:
          // SwiftPlus does NOT increase damage
          // It is validated in SwiftComboEngine
          break;

        case BuffType.defenseUp:
          // Not applicable for outgoing damage
          break;
      }
    }

    return modified.clamp(0, 9999);
  }

  /// =========================
  /// INCOMING DAMAGE
  /// =========================
  int modifyIncomingDamage(HeroModel hero, int incomingDamage) {
    int modified = incomingDamage;

    for (final buff in hero.buffs) {
      switch (buff.type) {
        case BuffType.defenseUp:
          modified -= buff.value;
          break;

        case BuffType.attackUp:
        case BuffType.swiftPlus:
          // Not applicable for incoming damage
          break;
      }
    }

    return modified.clamp(0, 9999);
  }
}
