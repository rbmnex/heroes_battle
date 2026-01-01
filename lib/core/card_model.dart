import 'enums.dart';

class CardModel {

  /// =========================
  /// IDENTITY
  /// =========================
  final String id;
  final String name;
  final CardType cardType;

  /// =========================
  /// ATTACK PROPERTIES
  /// =========================
  final AttackCategory? attackCategory;
  final AttackType? attackType;
  final TargetType? targetType;

  /// Base damage BEFORE buffs / reactions
  final int baseDamage;

  /// =========================
  /// REACTION PROPERTIES
  /// =========================
  final ReactionType? reactionType;

  // Buff / Status
  // final BuffType? buffType;
  // final StatusType? statusType;
  // final int? value;

   /// =========================
  /// ITEM PROPERTIES
  /// =========================

  final ItemType? itemType;

  const CardModel({
    required this.id,
    required this.name,
    required this.cardType,
    this.attackCategory,
    this.attackType,
    this.targetType,
    this.baseDamage = 0,
    this.reactionType,
    this.itemType,
    // this.buffType,
    // this.statusType,
    // this.value,
  });
}
