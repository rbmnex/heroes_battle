import '../core/hero.dart';
import '../core/item.dart';

class ItemEngine {
  /// Use a consumable item
  void useConsumable({
    required HeroModel user,
    required HeroModel target,
    required ItemCard item,
  }) {
    if (item.type != ItemType.consumable) {
      throw Exception('${item.name} is not a consumable item');
    }

    switch (item.effectType) {
      case ItemEffectType.heal:
        target.hp += item.value;
        break;

      case ItemEffectType.cure:
        // Placeholder for status engine
        // target.clearStatus();
        break;

      case ItemEffectType.buff:
        // Buffs handled by skill/status engine later
        break;
    }
  }

  /// Equip a permanent item
  void equipItem({
    required HeroModel hero,
    required ItemCard item,
  }) {
    if (item.type != ItemType.equipment) {
      throw Exception('${item.name} is not an equipment item');
    }

    if (hero.equippedItem != null) {
      throw Exception('${hero.name} already has equipment');
    }

    hero.equippedItem = item;
  }
}
