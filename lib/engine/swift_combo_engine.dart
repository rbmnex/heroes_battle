import '../core/card_model.dart';
import '../core/hero_model.dart';
import '../core/enums.dart';
import '../model/swift_combo_state.dart';

class SwiftComboEngine {
  final Map<String, SwiftComboState> _states = {};

  /// =========================
  /// VALIDATE ATTACK
  /// =========================
  bool canExecuteAttack({
    required HeroModel hero,
    required CardModel attackCard,
    required bool isCombo,
  }) {
    final state = _stateFor(hero);

    // Only attack cards
    if (attackCard.cardType != CardType.attack) return false;

    // First attack of the turn
    if (!state.swiftUsed && !state.comboConsumed) {
      return true;
    }

    // Combo attempt
    if (isCombo) {
      if (state.comboConsumed) return false;
      if (attackCard.attackType != AttackType.swift) return false;
      return true;
    }

    return false;
  }

  /// =========================
  /// MARK ATTACK RESOLVED
  /// =========================
  void markAttackResolved(
    HeroModel hero,
    CardModel attackCard,
    bool isCombo,
  ) {
    final state = _stateFor(hero);

    if (attackCard.attackType == AttackType.swift) {
      state.swiftUsed = true;
    }

    if (isCombo) {
      state.comboConsumed = true;
    }
  }

  /// =========================
  /// TURN RESET
  /// =========================
  void resetForNewTurn(HeroModel hero) {
    hero.swiftUsedThisTurn = false;
    hero.comboUsedThisTurn = false;
    _stateFor(hero).reset();
  }

  /// =========================
  /// INTERNAL
  /// =========================
  SwiftComboState _stateFor(HeroModel hero) {
    return _states.putIfAbsent(hero.id, () => SwiftComboState());
  }
}
