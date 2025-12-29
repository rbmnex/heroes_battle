import '../core/card.dart';
import '../core/enums.dart';

class SwiftComboEngine {
  bool _comboUsedThisTurn = false;
  bool _nonSwiftAttackUsed = false;

  /// Call this at the start of the hero's turn
  void resetTurn() {
    _comboUsedThisTurn = false;
    _nonSwiftAttackUsed = false;
  }

  /// Validate if an attack sequence is legal
  void validateAttackSequence(List<CardModel> attackCards) {
    if (attackCards.isEmpty) {
      throw Exception('No attack cards provided');
    }

    final swiftCards =
        attackCards.where((c) => c.attackType == AttackType.swift).toList();

    final nonSwiftCards =
        attackCards.where((c) => c.attackType != AttackType.swift).toList();

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
  AttackResolution resolveAttack(List<CardModel> attackCards) {
    validateAttackSequence(attackCards);

    final int swiftCount =
        attackCards.where((c) => c.attackType == AttackType.swift).length;

    // Guaranteed to return a CardModel
    final CardModel baseAttack = attackCards.firstWhere(
      (c) => c.attackType != AttackType.swift,
      orElse: () => attackCards.first,
    );

    bool comboTriggered = false;

    // Swift + Normal / Heavy combo
    if (swiftCount > 0 &&
        baseAttack.attackType != AttackType.swift &&
        !_comboUsedThisTurn) {
      comboTriggered = true;
      _comboUsedThisTurn = true;
    }

    // Mark non-swift usage
    if (baseAttack.attackType != AttackType.swift) {
      _nonSwiftAttackUsed = true;
    }

    return AttackResolution(
      baseAttack: baseAttack,
      swiftCount: swiftCount,
      comboTriggered: comboTriggered,
    );
  }
}

class AttackResolution {
  final CardModel baseAttack;
  final int swiftCount;
  final bool comboTriggered;

  AttackResolution({
    required this.baseAttack,
    required this.swiftCount,
    required this.comboTriggered,
  });
}
