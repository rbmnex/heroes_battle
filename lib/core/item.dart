enum ItemType {
  consumable,
  equipment,
}

enum ItemEffectType {
  heal,
  cure,
  buff,
}

class ItemCard {
  final String id;
  final String name;
  final ItemType type;
  final ItemEffectType effectType;
  final int value;

  const ItemCard({
    required this.id,
    required this.name,
    required this.type,
    required this.effectType,
    required this.value,
  });
}
