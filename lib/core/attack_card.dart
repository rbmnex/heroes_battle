import 'card.dart';
import 'enums.dart';

class AttackCard extends CardModel {
  final AttackCategory category;
  final AttackType speed;
  final int baseDamage;
  final bool isArea;
  final bool isMultiTarget;

  const AttackCard({
    required super.id,
    required super.name,
    required this.category,
    required this.speed,
    required this.baseDamage,
    this.isArea = false,
    this.isMultiTarget = false,
  }) : super(
          cardType: CardType.attack,
        );
}
