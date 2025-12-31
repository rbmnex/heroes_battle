import 'enums.dart';

class CardModel {
  final String id;
  final String name;
  final CardType cardType;

  // Attack
  final AttackCategory? attackCategory;
  final AttackType? attackType;
  final TargetType? targetType;
  final int? baseDamage;

  // Reaction
  final ReactionType? reactionType;

  // Buff / Status
  final BuffType? buffType;
  final StatusType? statusType;
  final int? value;

  // Item
  final ItemType? itemType;

  const CardModel({
    required this.id,
    required this.name,
    required this.cardType,
    this.attackCategory,
    this.attackType,
    this.targetType,
    this.baseDamage,
    this.reactionType,
    this.buffType,
    this.statusType,
    this.value,
    this.itemType,
  });
}
