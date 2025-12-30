import '../core/hero.dart';
import '../core/attack_card.dart';
import '../core/enums.dart';

class SwiftComboResult {
  final bool allowed;
  final bool isCombo;
  final String? reason;

  const SwiftComboResult({
    required this.allowed,
    required this.isCombo,
    this.reason,
  });
}

class SwiftComboEngine {
  static SwiftComboResult validate({
    required HeroModel hero,
    required AttackCard attackCard,
  }) {
    // ❌ Already attacked
    if (hero.hasAttackedThisTurn) {
      return const SwiftComboResult(
        allowed: false,
        isCombo: false,
        reason: 'Hero has already attacked this turn',
      );
    }

    // =========================
    // Swift logic
    // =========================
    if (attackCard.speed == AttackType.swift) {
      // Swift usage tracking
      hero.swiftUsedThisTurn++;

      // First Swift → may combo
      if (hero.swiftUsedThisTurn == 1 &&
          !hero.comboUsedThisTurn) {
        return const SwiftComboResult(
          allowed: true,
          isCombo: false,
        );
      }

      // Second Swift → allowed but NO combo
      return const SwiftComboResult(
        allowed: true,
        isCombo: false,
      );
    }

    // =========================
    // Normal / Heavy logic
    // =========================
    if (!hero.comboUsedThisTurn) {
      hero.comboUsedThisTurn = true;
      return const SwiftComboResult(
        allowed: true,
        isCombo: true,
      );
    }

    return const SwiftComboResult(
      allowed: false,
      isCombo: false,
      reason: 'Combo already used this turn',
    );
  }
}
