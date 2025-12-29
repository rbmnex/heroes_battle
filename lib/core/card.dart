import 'enums.dart';

class CardModel {
  final String id;
  final String name;
  final CardType cardType;

  // Optional properties depending on card type
  final AttackCategory? attackCategory;
  final AttackType? attackType;
  final TargetType? targetType;
  final ItemType? itemType;

  const CardModel({
    required this.id,
    required this.name,
    required this.cardType,
    this.attackCategory,
    this.attackType,
    this.targetType,
    this.itemType,
  });
}
