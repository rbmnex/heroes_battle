import '../core/attack_card.dart';
import '../core/enums.dart';
import '../model/attack_resolution.dart';

class SwiftComboEngine {
  bool _comboUsedThisTurn = false;
  bool _nonSwiftAttackUsed = false;

  /// Call this at the start of the hero's turn
  void resetTurn() {
    _comboUsedThisTurn = false;
    _nonSwiftAttackUsed = false;
  }

  /// Validate if an attack sequence is legal
  void validateAttackSequence(List<AttackCard> attackCards) {
    if (attackCards.isEmpty) {
      throw Exception('No attack cards provided');
    }

    final swiftCards =
        attackCards.where((c) => c.speed == AttackType.swift).toList();

    final nonSwiftCards =
        attackCards.where((c) => c.speed != AttackType.swift).toList();

    if (nonSwiftCards.length > 1) {
      throw Exception('Only one Normal or Heavy attack allowed per turn');
    }

    if (nonSwiftCards.isNotEmpty && _nonSwiftAttackUsed) {
      throw Exception('Non-swift attack already used this turn');
    }

    if (swiftCards.isNotEmpty &&
        nonSwiftCards.isNotEmpty &&
        _comboUsedThisTurn) {
      throw Exception('Swift combo already used this turn');
    }
  }

  /// Resolve Swift logic and return attack resolution
  AttackResolution resolveAttack(List<AttackCard> attackCards) {
    validateAttackSequence(attackCards);

    final int swiftCount =
        attackCards.where((c) => c.speed == AttackType.swift).length;

    // Guaranteed to return a CardModel
    final AttackCard baseAttack = attackCards.firstWhere(
      (c) => c.speed != AttackType.swift,
      orElse: () => attackCards.first,
    );

    bool comboTriggered = false;

    // Swift + Normal / Heavy combo
    if (swiftCount > 0 &&
        baseAttack.speed != AttackType.swift &&
        !_comboUsedThisTurn) {
      comboTriggered = true;
      _comboUsedThisTurn = true;
    }

    // Mark non-swift usage
    if (baseAttack.speed != AttackType.swift) {
      _nonSwiftAttackUsed = true;
    }

    return AttackResolution(
      attackCard: baseAttack,
      isCombo: comboTriggered,
      wasEvaded: false,
      damageDealt: 0,
      counterDamageTaken: 0,
    );
  }
}


