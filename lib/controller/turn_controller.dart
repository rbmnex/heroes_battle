import '../core/hero.dart';
import '../core/card.dart';
import '../core/attack_card.dart';
import '../core/enums.dart';
import '../engine/attack_engine.dart';
import '../engine/swift_combo_engine.dart';

class TurnController {
  TurnPhase currentPhase = TurnPhase.draw;

  final List<CardModel> drawPile;
  final List<CardModel> discardPile;
  final List<CardModel> hand;

  final AttackEngine attackEngine = AttackEngine();

  TurnController({
    required this.drawPile,
    required this.discardPile,
    required this.hand,
  });

  /// =========================
  /// PHASE CONTROL
  /// =========================

  void startTurn() {
    currentPhase = TurnPhase.draw;
  }

  void nextPhase() {
    switch (currentPhase) {
      case TurnPhase.draw:
        _handleDrawPhase();
        currentPhase = TurnPhase.item;
        break;

      case TurnPhase.item:
        currentPhase = TurnPhase.action;
        break;

      case TurnPhase.action:
        currentPhase = TurnPhase.end;
        break;

      case TurnPhase.end:
        _handleEndPhase();
        currentPhase = TurnPhase.draw;
        break;
    }
  }

  /// =========================
  /// DRAW PHASE
  /// =========================

  void _handleDrawPhase({int drawCount = 1}) {
    for (int i = 0; i < drawCount; i++) {
      if (drawPile.isEmpty) {
        _reshuffleDiscardIntoDraw();
      }

      if (drawPile.isNotEmpty) {
        hand.add(drawPile.removeAt(0));
      }
    }
  }

  void _reshuffleDiscardIntoDraw() {
    drawPile.addAll(discardPile);
    discardPile.clear();
    drawPile.shuffle();
  }

  /// =========================
  /// ACTION PHASE (ATTACK ENTRY)
  /// =========================

  void performAttack({
    required HeroModel attacker,
    required HeroModel defender,
    required AttackCard attackCard,
  }) {
    if (currentPhase != TurnPhase.action) {
      throw Exception('Not in Action phase');
    }

    final comboResult = SwiftComboEngine.validate(
      hero: attacker,
      attackCard: attackCard,
    );

    if (!comboResult.allowed) {
      throw Exception(comboResult.reason);
    }

    attackEngine.performAttack(
      attacker: attacker,
      defender: defender,
      attackCard: attackCard,
      isCombo: comboResult.isCombo,
    );
  }

  /// =========================
  /// END PHASE
  /// =========================

  void _handleEndPhase() {
    discardPile.addAll(hand);
    hand.clear();
  }

  /// =========================
  /// TURN RESET
  /// =========================

  void resetHeroForNewTurn(HeroModel hero) {
    hero
      ..hasAttackedThisTurn = false
      ..swiftUsedThisTurn = 0
      ..comboUsedThisTurn = false;
  }

  /// Whether an item may be used in the current phase and there is at least
  /// one item card in hand.
  bool canUseItem() {
    if (currentPhase != TurnPhase.item) return false;
    return hand.any((c) => c.cardType == CardType.item);
  }

  /// Whether the provided hero can perform an attack in the current phase.
  /// Checks phase, alive state, and that the hero hasn't already attacked.
  bool canAttack(HeroModel hero) {
    if (currentPhase != TurnPhase.action) return false;
    if (!hero.canAct) return false;
    if (hero.hasAttackedThisTurn) return false;
    // Disallow attacking while stunned
    if (hero.statusEffects.any((s) => s.type == StatusType.stun)) return false;
    return true;
  }
}
