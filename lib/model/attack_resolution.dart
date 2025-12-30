import '../core/attack_card.dart';

class AttackResolution {
  final AttackCard attackCard;
  final bool isCombo;
  final bool wasEvaded;
  final int damageDealt;
  final int counterDamageTaken;

  const AttackResolution({
    required this.attackCard,
    required this.isCombo,
    required this.wasEvaded,
    required this.damageDealt,
    required this.counterDamageTaken,
  });
}
